import 'package:eventpro/features/assistant/domain/input/assistant_input.dart';
import 'package:eventpro/features/assistant/domain/input/assistant_input_attachment.dart';
import 'package:eventpro/features/assistant/domain/input/assistant_input_content.dart';
import 'package:eventpro/features/assistant/domain/input/assistant_input_id.dart';
import 'package:eventpro/features/assistant/domain/input/assistant_input_metadata.dart';
import 'package:eventpro/features/assistant/domain/input/assistant_input_normalization_status.dart';
import 'package:eventpro/features/assistant/domain/input/assistant_input_source.dart';
import 'package:eventpro/features/assistant/domain/input/assistant_input_status.dart';
import 'package:eventpro/features/assistant/domain/input/assistant_input_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AI-020 CP-1 multimodal input contracts', () {
    final now = DateTime.utc(2026, 7, 20, 22);

    test('input imutável com attachment seguro (sem bytes)', () {
      const attachment = AssistantInputAttachment(
        reference: 'mem://img/1',
        fileName: 'foto.jpg',
        mimeType: 'image/jpeg',
        sizeBytes: 2048,
      );
      final input = AssistantInput(
        id: const AssistantInputId('in-1'),
        type: AssistantInputType.image,
        content: const AssistantInputContent(attachment: attachment),
        metadata: const AssistantInputMetadata(
          source: AssistantInputSource.camera,
          correlationId: 'corr-1',
        ),
        receivedAt: now,
        status: AssistantInputStatus.received,
      );

      expect(input.effectiveCorrelationId, 'corr-1');
      expect(input.content.hasAttachment, isTrue);
      expect(input.toDeterministicMap()['type'], 'image');
      expect(
        (input.toDeterministicMap()['content'] as Map)['attachment'],
        isA<Map>(),
      );
      expect(AssistantInputNormalizationStatus.ready.isReady, isTrue);
      expect(
        AssistantInputNormalizationStatus.requiresProcessing.blocksInterpretation,
        isTrue,
      );
    });

    test('tipos e fontes tipados', () {
      expect(AssistantInputType.values.map((e) => e.name),
          containsAll(['text', 'image', 'audio', 'document']));
      expect(AssistantInputSource.typedText.name, 'typedText');
    });
  });
}
