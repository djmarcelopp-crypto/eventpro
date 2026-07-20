import '../business/assistant_business_reference.dart';
import '../business/assistant_business_result.dart';
import 'assistant_workflow_context.dart';

/// Stable context keys for business references (AI-017).
abstract final class AssistantWorkflowBusinessKeys {
  static const clientReference = 'clientReference';
  static const quoteReference = 'quoteReference';
  static const eventReference = 'eventReference';
  static const contractReference = 'contractReference';
  static const businessResult = 'businessResult';
}

/// Typed accessors for business references on [AssistantWorkflowContext].
extension AssistantWorkflowBusinessContext on AssistantWorkflowContext {
  ClientReference? get clientReference {
    final v = this[AssistantWorkflowBusinessKeys.clientReference];
    return v is ClientReference ? v : null;
  }

  QuoteReference? get quoteReference {
    final v = this[AssistantWorkflowBusinessKeys.quoteReference];
    return v is QuoteReference ? v : null;
  }

  EventReference? get eventReference {
    final v = this[AssistantWorkflowBusinessKeys.eventReference];
    return v is EventReference ? v : null;
  }

  ContractReference? get contractReference {
    final v = this[AssistantWorkflowBusinessKeys.contractReference];
    return v is ContractReference ? v : null;
  }

  AssistantBusinessResult? get businessResult {
    final v = this[AssistantWorkflowBusinessKeys.businessResult];
    return v is AssistantBusinessResult ? v : null;
  }

  AssistantWorkflowContext withClientReference(ClientReference reference) =>
      put(AssistantWorkflowBusinessKeys.clientReference, reference);

  AssistantWorkflowContext withQuoteReference(QuoteReference reference) =>
      put(AssistantWorkflowBusinessKeys.quoteReference, reference);

  AssistantWorkflowContext withEventReference(EventReference reference) =>
      put(AssistantWorkflowBusinessKeys.eventReference, reference);

  AssistantWorkflowContext withContractReference(
    ContractReference reference,
  ) =>
      put(AssistantWorkflowBusinessKeys.contractReference, reference);
}
