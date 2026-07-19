import 'assistant_write_authorization_status.dart';
import 'assistant_write_constraint.dart';

/// Result of validating a write intent — never an ERP mutation.
class AssistantWriteValidationResult {
  const AssistantWriteValidationResult({
    required this.valid,
    required this.authorizationStatus,
    this.validationErrors = const [],
    this.blockedConstraints = const [],
    this.warnings = const [],
  });

  final bool valid;
  final List<String> validationErrors;
  final AssistantWriteAuthorizationStatus authorizationStatus;
  final List<AssistantWriteConstraint> blockedConstraints;
  final List<String> warnings;

  factory AssistantWriteValidationResult.fromParts({
    required List<String> validationErrors,
    required AssistantWriteAuthorizationStatus authorizationStatus,
    required List<AssistantWriteConstraint> blockedConstraints,
    List<String> warnings = const [],
  }) {
    final authBlocks = authorizationStatus ==
            AssistantWriteAuthorizationStatus.denied ||
        authorizationStatus ==
            AssistantWriteAuthorizationStatus.insufficientPrivileges;
    return AssistantWriteValidationResult(
      valid: validationErrors.isEmpty &&
          blockedConstraints.isEmpty &&
          !authBlocks,
      validationErrors: List.unmodifiable(validationErrors),
      authorizationStatus: authorizationStatus,
      blockedConstraints: List.unmodifiable(blockedConstraints),
      warnings: List.unmodifiable(warnings),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantWriteValidationResult &&
            other.valid == valid &&
            _listEquals(other.validationErrors, validationErrors) &&
            other.authorizationStatus == authorizationStatus &&
            _constraintsEquals(other.blockedConstraints, blockedConstraints) &&
            _listEquals(other.warnings, warnings);
  }

  @override
  int get hashCode => Object.hash(
        valid,
        Object.hashAll(validationErrors),
        authorizationStatus,
        Object.hashAll(blockedConstraints),
        Object.hashAll(warnings),
      );

  static bool _listEquals(List<String> a, List<String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static bool _constraintsEquals(
    List<AssistantWriteConstraint> a,
    List<AssistantWriteConstraint> b,
  ) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
