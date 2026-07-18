import '../models/assistant_confidence.dart';
import '../models/assistant_entity.dart';
import '../models/assistant_entity_type.dart';
import '../models/assistant_event_draft.dart';
import '../models/assistant_provenance.dart';
import '../models/assistant_quote_draft.dart';

/// Builds non-persistent event/quote drafts from extracted entities.
abstract class AssistantDraftBuilder {
  static AssistantEventDraft buildEventDraft({
    required String sourceText,
    required List<AssistantEntity> entities,
  }) {
    String? first(AssistantEntityType type) {
      for (final entity in entities) {
        if (entity.type == type) {
          return entity.normalizedValue ?? entity.rawValue;
        }
      }
      return null;
    }

    AssistantProvenance? provenance(AssistantEntityType type) {
      for (final entity in entities) {
        if (entity.type == type) return entity.provenance;
      }
      return null;
    }

    final dateRaw = first(AssistantEntityType.date);
    DateTime? date;
    if (dateRaw != null) {
      date = DateTime.tryParse(dateRaw);
    }

    final guestRaw = first(AssistantEntityType.guestCount);
    int? guests;
    if (guestRaw != null && !guestRaw.contains('-')) {
      guests = int.tryParse(guestRaw);
    }

    final fieldProvenance = <String, AssistantProvenance>{};
    void put(String field, AssistantEntityType type) {
      final value = provenance(type);
      if (value != null) fieldProvenance[field] = value;
    }

    put('eventType', AssistantEntityType.eventType);
    put('date', AssistantEntityType.date);
    put('startTime', AssistantEntityType.startTime);
    put('endTime', AssistantEntityType.endTime);
    put('city', AssistantEntityType.city);
    put('venue', AssistantEntityType.venue);
    put('guestCount', AssistantEntityType.guestCount);
    put('clientName', AssistantEntityType.clientName);

    final scores = entities.map((e) => e.confidence.score);
    final avg = scores.isEmpty
        ? 0.0
        : scores.reduce((a, b) => a + b) / scores.length;

    return AssistantEventDraft(
      eventType: first(AssistantEntityType.eventType),
      clientName: first(AssistantEntityType.clientName),
      date: date,
      startTime: first(AssistantEntityType.startTime),
      endTime: first(AssistantEntityType.endTime),
      city: first(AssistantEntityType.city),
      venue: first(AssistantEntityType.venue),
      guestCount: guests,
      notes: first(AssistantEntityType.notes),
      confidence: AssistantConfidence.fromScore(avg),
      sourceText: sourceText,
      fieldProvenance: fieldProvenance,
    );
  }

  static AssistantQuoteDraft buildQuoteDraft({
    required List<AssistantEntity> entities,
  }) {
    List<String> ofType(AssistantEntityType type) => [
          for (final entity in entities)
            if (entity.type == type) entity.normalizedValue ?? entity.rawValue,
        ];

    final equipment = ofType(AssistantEntityType.equipment);
    final services = ofType(AssistantEntityType.service);
    final team = ofType(AssistantEntityType.teamRequirement);
    final logistics = ofType(AssistantEntityType.vehicleRequirement);
    final filled = [
      ...equipment,
      ...services,
      ...team,
      ...logistics,
    ];

    return AssistantQuoteDraft(
      equipmentKeywords: equipment,
      serviceKeywords: services,
      teamKeywords: team,
      logisticsKeywords: logistics,
      confidence: AssistantConfidence.fromScore(
        filled.isEmpty ? 0.2 : 0.7,
        evidences: filled,
      ),
    );
  }
}
