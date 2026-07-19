import '../domain/conversation/assistant_conversation_planner.dart';
import '../domain/read/assistant_read_planner.dart';
import '../models/assistant_conversation_context.dart';
import '../models/assistant_conversation_plan.dart';
import '../models/assistant_conversation_session.dart';
import '../models/assistant_read_intent.dart';
import '../models/assistant_read_pagination.dart';
import '../models/assistant_read_query.dart';
import '../models/assistant_read_sort.dart';
import '../models/assistant_reference_kind.dart';
import '../models/assistant_request.dart';
import 'assistant_capabilities.dart';
import 'local_assistant_read_intent_resolver.dart';
import 'local_assistant_read_planner.dart';
import 'local_assistant_reference_resolver.dart';

/// Follow-up planner: reuses session context to build the next read query.
class LocalAssistantConversationPlanner implements AssistantConversationPlanner {
  const LocalAssistantConversationPlanner({
    LocalAssistantReferenceResolver? referenceResolver,
    LocalAssistantReadIntentResolver? intentResolver,
    AssistantReadPlanner? readPlanner,
  })  : _references = referenceResolver ?? const LocalAssistantReferenceResolver(),
        _intents = intentResolver ?? const LocalAssistantReadIntentResolver(),
        _readPlanner = readPlanner ?? const LocalAssistantReadPlanner();

  final LocalAssistantReferenceResolver _references;
  final LocalAssistantReadIntentResolver _intents;
  final AssistantReadPlanner _readPlanner;

  static const missingContextMessage =
      'Não há contexto conversacional suficiente para essa referência. '
      'Faça uma consulta completa primeiro (por exemplo: “Mostre os últimos orçamentos”).';

  @override
  AssistantConversationPlan plan({
    required AssistantRequest request,
    required AssistantConversationSession? session,
    required AssistantCapabilities capabilities,
  }) {
    if (!capabilities.canPlanStructuredQuoteRead &&
        !capabilities.canExecuteStructuredQuoteRead) {
      return const AssistantConversationPlan(kind: AssistantReferenceKind.none);
    }

    final context = session?.context ?? AssistantConversationContext.empty;
    final reference = _references.resolve(request.rawText, context: context);

    if (reference.kind != AssistantReferenceKind.none) {
      return _planFollowUp(
        request: request,
        context: context,
        reference: reference,
      );
    }

    final fresh = _intents.resolve(
      request: request,
      capabilities: capabilities,
    );
    if (fresh == null) {
      return const AssistantConversationPlan(kind: AssistantReferenceKind.none);
    }
    return AssistantConversationPlan.fresh(fresh);
  }

  AssistantConversationPlan _planFollowUp({
    required AssistantRequest request,
    required AssistantConversationContext context,
    required AssistantResolvedReference reference,
  }) {
    if (context.isEmpty) {
      // Status refine can stand alone as a fresh filtered list.
      if (reference.kind == AssistantReferenceKind.filterRefine) {
        final intent = ReadQuotesIntent(statusToken: reference.statusToken);
        return AssistantConversationPlan(
          kind: reference.kind,
          intent: intent,
          isFollowUp: true,
        );
      }
      return AssistantConversationPlan.missingContext(missingContextMessage);
    }

    switch (reference.kind) {
      case AssistantReferenceKind.client:
        final client = context.focusedRecord?.attributes['clientDisplayName'] ??
            context.lastClientName;
        if (client == null || client.trim().isEmpty) {
          return AssistantConversationPlan.missingContext(missingContextMessage);
        }
        return AssistantConversationPlan.answer(
          'O cliente do orçamento '
          '${context.lastQuoteNumber ?? context.lastQuoteId ?? 'atual'} '
          'é $client.',
        );

      case AssistantReferenceKind.details:
      case AssistantReferenceKind.thisOne:
        final id = context.focusedRecord?.id ?? context.lastQuoteId;
        if (id == null) {
          return AssistantConversationPlan.missingContext(missingContextMessage);
        }
        return AssistantConversationPlan(
          kind: reference.kind,
          intent: ReadQuoteByIdIntent(id),
          isFollowUp: true,
          focusIndex: context.focusedIndex,
        );

      case AssistantReferenceKind.last:
        final records = context.lastRecords;
        if (records.isEmpty) {
          return AssistantConversationPlan.missingContext(missingContextMessage);
        }
        final index = records.length - 1;
        return AssistantConversationPlan(
          kind: reference.kind,
          intent: ReadQuoteByIdIntent(records[index].id),
          isFollowUp: true,
          focusIndex: index,
        );

      case AssistantReferenceKind.previous:
        return _focusRelative(context, -1, reference.kind);

      case AssistantReferenceKind.next:
        return _focusRelative(context, 1, reference.kind);

      case AssistantReferenceKind.ordinal:
        final ordinal = reference.ordinal;
        if (ordinal == null || ordinal < 1) {
          return AssistantConversationPlan.missingContext(missingContextMessage);
        }
        final index = ordinal - 1;
        final records = context.lastRecords;
        if (index >= records.length) {
          return AssistantConversationPlan.missingContext(
            'Não há um $ordinalº item no último resultado '
            '(${records.length} encontrados).',
          );
        }
        return AssistantConversationPlan(
          kind: reference.kind,
          intent: ReadQuoteByIdIntent(records[index].id),
          isFollowUp: true,
          focusIndex: index,
        );

      case AssistantReferenceKind.nextPage:
        final page = context.lastPagination ??
            const AssistantReadPagination();
        final nextOffset = page.offset + page.limit;
        final filters = context.lastFilters;
        final query = AssistantReadQuery(
          id: 'rquery-${request.id}',
          requestId: request.id,
          module: AssistantReadModules.quote,
          filters: filters,
          sorting: const [
            AssistantReadSort(field: 'createdAt', ascending: false),
          ],
          pagination: AssistantReadPagination(
            offset: nextOffset,
            limit: page.limit,
          ),
          requiredCapabilities: const {
            AssistantReadCapabilities.structuredQuoteRead,
          },
        );
        return AssistantConversationPlan(
          kind: reference.kind,
          intent: context.lastIntent ?? const ReadRecentQuotesIntent(),
          query: query,
          isFollowUp: true,
        );

      case AssistantReferenceKind.filterRefine:
        final limit = context.lastPagination?.limit ??
            AssistantReadPagination.defaultLimit;
        final intent = ReadQuotesIntent(
          statusToken: reference.statusToken,
          limit: limit,
        );
        // Preserve non-status filters (e.g. client) from context.
        final preserved = context.lastFilters
            .where((f) => f.field.toLowerCase() != 'status')
            .toList(growable: false);
        final planned = _readPlanner.plan(intent, requestId: request.id);
        final query = AssistantReadQuery(
          id: planned.id,
          requestId: planned.requestId,
          module: planned.module,
          filters: [...preserved, ...planned.filters],
          projection: planned.projection,
          sorting: planned.sorting,
          pagination: planned.pagination,
          requiredCapabilities: planned.requiredCapabilities,
        );
        return AssistantConversationPlan(
          kind: reference.kind,
          intent: intent,
          query: query,
          isFollowUp: true,
        );

      case AssistantReferenceKind.none:
        return const AssistantConversationPlan(kind: AssistantReferenceKind.none);
    }
  }

  AssistantConversationPlan _focusRelative(
    AssistantConversationContext context,
    int delta,
    AssistantReferenceKind kind,
  ) {
    final records = context.lastRecords;
    if (records.isEmpty) {
      return AssistantConversationPlan.missingContext(missingContextMessage);
    }
    final current = context.focusedIndex ?? 0;
    final next = current + delta;
    if (next < 0 || next >= records.length) {
      return AssistantConversationPlan.missingContext(
        'Não há item ${delta < 0 ? 'anterior' : 'próximo'} no resultado atual.',
      );
    }
    return AssistantConversationPlan(
      kind: kind,
      intent: ReadQuoteByIdIntent(records[next].id),
      isFollowUp: true,
      focusIndex: next,
    );
  }
}
