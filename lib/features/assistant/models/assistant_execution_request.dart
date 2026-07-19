import 'assistant_execution_context.dart';
import 'assistant_execution_plan.dart';
import 'assistant_module_data_source.dart';

/// Input to the controlled execution pipeline (dry-run / simulation only).
class AssistantExecutionRequest {
  const AssistantExecutionRequest({
    required this.id,
    required this.context,
    required this.plan,
    this.consultedDataSources = const [],
  });

  final String id;
  final AssistantExecutionContext context;
  final AssistantExecutionPlan plan;
  final List<AssistantModuleDataSource> consultedDataSources;

  AssistantExecutionRequest copyWith({
    String? id,
    AssistantExecutionContext? context,
    AssistantExecutionPlan? plan,
    List<AssistantModuleDataSource>? consultedDataSources,
  }) {
    return AssistantExecutionRequest(
      id: id ?? this.id,
      context: context ?? this.context,
      plan: plan ?? this.plan,
      consultedDataSources: consultedDataSources ?? this.consultedDataSources,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantExecutionRequest &&
            other.id == id &&
            other.context == context &&
            other.plan == plan &&
            _listEquals(other.consultedDataSources, consultedDataSources);
  }

  @override
  int get hashCode => Object.hash(
        id,
        context,
        plan,
        Object.hashAll(consultedDataSources),
      );

  static bool _listEquals(
    List<AssistantModuleDataSource> a,
    List<AssistantModuleDataSource> b,
  ) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
