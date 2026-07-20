import 'assistant_business_command.dart';
import 'assistant_business_command_category.dart';
import 'assistant_business_command_id.dart';

/// Extensible catalog of declarative business commands — no giant switch.
abstract class AssistantBusinessCommandRegistry {
  AssistantBusinessCommand? find(AssistantBusinessCommandId id);

  AssistantBusinessCommand? findByOperationCode(String operationCode);

  Iterable<AssistantBusinessCommand> findByCategory(
    AssistantBusinessCommandCategory category,
  );

  bool contains(AssistantBusinessCommandId id) => find(id) != null;

  Iterable<AssistantBusinessCommand> get commands;
}
