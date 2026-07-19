import 'assistant_module_availability.dart';
import 'assistant_module_capability.dart';
import 'assistant_module_data_source.dart';
import 'assistant_module_error.dart';
import 'assistant_module_result.dart';

/// Immutable gateway response. Failures are carried in [error], never thrown.
class AssistantModuleResponse {
  const AssistantModuleResponse({
    required this.requestId,
    required this.capability,
    required this.availability,
    required this.dataSource,
    this.result,
    this.error,
  });

  final String requestId;
  final AssistantModuleCapability capability;
  final AssistantModuleAvailability availability;

  /// Origin claimed for this response (must match [result.dataSource] when set).
  final AssistantModuleDataSource dataSource;

  final AssistantModuleResult? result;
  final AssistantModuleError? error;

  bool get isSuccess =>
      availability == AssistantModuleAvailability.available &&
      error == null &&
      result != null;

  bool get isSimulated =>
      dataSource == AssistantModuleDataSource.inMemory ||
      dataSource == AssistantModuleDataSource.demo ||
      dataSource == AssistantModuleDataSource.test;

  AssistantModuleResponse copyWith({
    String? requestId,
    AssistantModuleCapability? capability,
    AssistantModuleAvailability? availability,
    AssistantModuleDataSource? dataSource,
    AssistantModuleResult? result,
    AssistantModuleError? error,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return AssistantModuleResponse(
      requestId: requestId ?? this.requestId,
      capability: capability ?? this.capability,
      availability: availability ?? this.availability,
      dataSource: dataSource ?? this.dataSource,
      result: clearResult ? null : (result ?? this.result),
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantModuleResponse &&
            other.requestId == requestId &&
            other.capability == capability &&
            other.availability == availability &&
            other.dataSource == dataSource &&
            other.result == result &&
            other.error == error;
  }

  @override
  int get hashCode => Object.hash(
        requestId,
        capability,
        availability,
        dataSource,
        result,
        error,
      );
}
