import 'package:eventpro/features/assistant/domain/business/commands/assistant_business_command.dart';
import 'package:eventpro/features/assistant/domain/business/commands/assistant_business_command_category.dart';
import 'package:eventpro/features/assistant/domain/business/commands/assistant_business_command_id.dart';
import 'package:eventpro/features/assistant/domain/business/commands/assistant_business_command_metadata.dart';
import 'package:eventpro/features/assistant/domain/business/commands/assistant_business_command_parameter.dart';
import 'package:eventpro/features/assistant/domain/business/commands/assistant_business_command_resolution.dart';
import 'package:eventpro/features/assistant/domain/business/commands/assistant_business_command_resolution_status.dart';
import 'package:eventpro/features/assistant/domain/business/commands/assistant_business_command_result.dart';
import 'package:eventpro/features/assistant/domain/business/commands/assistant_business_command_status.dart';
import 'package:eventpro/features/assistant/domain/business/commands/assistant_business_command_version.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AI-019 CP-1 business command contracts', () {
    const command = AssistantBusinessCommand(
      id: AssistantBusinessCommandId('FindClientCommand'),
      version: AssistantBusinessCommandVersion.v1,
      category: AssistantBusinessCommandCategory.lookup,
      metadata: AssistantBusinessCommandMetadata(
        label: 'Buscar cliente',
        description: 'Comando declarativo de lookup de cliente.',
        operationCode: 'FIND_CLIENT',
        tags: ['client', 'lookup'],
      ),
      parameters: [
        AssistantBusinessCommandParameter(
          key: 'query',
          required: false,
          description: 'Texto de busca',
        ),
      ],
      results: [
        AssistantBusinessCommandResult(
          key: 'clientReference',
          description: 'Referência opaca do cliente',
        ),
      ],
    );

    test('id: igualdade e serialização', () {
      const a = AssistantBusinessCommandId('FindClientCommand');
      const b = AssistantBusinessCommandId('FindClientCommand');
      expect(a, equals(b));
      expect(a.toDeterministicMap(), {'value': 'FindClientCommand'});
    });

    test('version e category', () {
      expect(AssistantBusinessCommandVersion.v1.label, '1.0.0');
      expect(AssistantBusinessCommandCategory.lookup.wireName, 'lookup');
    });

    test('command: operationCode como fonte única (sem capabilityId)', () {
      expect(command.operationCode, 'FIND_CLIENT');
      final meta = command.toDeterministicMap()['metadata'] as Map;
      expect(meta['operationCode'], 'FIND_CLIENT');
      expect(meta.containsKey('capabilityId'), isFalse);
    });

    test('command: fallback operationCode do id', () {
      const bare = AssistantBusinessCommand(
        id: AssistantBusinessCommandId('CustomCmd'),
        metadata: AssistantBusinessCommandMetadata(label: 'Custom'),
      );
      expect(bare.operationCode, 'CUSTOMCMD');
    });

    test('resolution e status', () {
      final ready = AssistantBusinessCommandResolution(
        commandId: command.id.value,
        command: command,
        resolutionStatus: AssistantBusinessCommandResolutionStatus.ready,
        commandStatus: AssistantBusinessCommandStatus.ready,
      );
      expect(ready.ready, isTrue);
      expect(AssistantBusinessCommandStatus.ready.isReady, isTrue);
    });
  });
}
