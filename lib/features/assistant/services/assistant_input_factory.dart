import '../domain/input/assistant_input.dart';
import '../domain/input/assistant_input_content.dart';
import '../domain/input/assistant_input_id.dart';
import '../domain/input/assistant_input_metadata.dart';
import '../domain/input/assistant_input_source.dart';
import '../domain/input/assistant_input_type.dart';
import '../models/assistant_input_origin.dart';
import '../models/assistant_request.dart';

/// Bridges legacy [AssistantRequest] text intake to [AssistantInput].
abstract final class AssistantInputFactory {
  static AssistantInput fromRequest(AssistantRequest request) {
    return AssistantInput(
      id: AssistantInputId('in-${request.id}'),
      type: AssistantInputType.text,
      content: AssistantInputContent(text: request.rawText),
      metadata: AssistantInputMetadata(
        source: _mapSource(request.origin),
        locale: request.locale,
        timezone: request.timezone,
        correlationId: request.id,
      ),
      receivedAt: request.timestamp.toUtc(),
      correlationId: request.id,
    );
  }

  static AssistantInputSource _mapSource(AssistantInputOrigin origin) {
    switch (origin) {
      case AssistantInputOrigin.typedText:
        return AssistantInputSource.typedText;
      case AssistantInputOrigin.pastedText:
        return AssistantInputSource.pastedText;
      case AssistantInputOrigin.audioTranscript:
        return AssistantInputSource.microphone;
      case AssistantInputOrigin.imageDescription:
        return AssistantInputSource.camera;
      case AssistantInputOrigin.documentText:
        return AssistantInputSource.filePicker;
      case AssistantInputOrigin.whatsappConversation:
        return AssistantInputSource.whatsapp;
      case AssistantInputOrigin.emailText:
        return AssistantInputSource.email;
    }
  }
}
