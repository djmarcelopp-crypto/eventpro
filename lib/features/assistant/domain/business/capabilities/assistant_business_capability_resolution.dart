import 'assistant_business_capability.dart';
import 'assistant_business_capability_warning.dart';
import 'capability_resolution_status.dart';

/// Result of resolving a single capability against context/inputs.
///
/// Never executes — only readiness for planning.
class AssistantBusinessCapabilityResolution {
  const AssistantBusinessCapabilityResolution({
    required this.capabilityId,
    this.capability,
    this.status = CapabilityResolutionStatus.blocked,
    this.warnings = const [],
  });

  final String capabilityId;
  final AssistantBusinessCapability? capability;
  final CapabilityResolutionStatus status;
  final List<AssistantBusinessCapabilityWarning> warnings;

  /// Compatibility alias — true only when [status] is [CapabilityResolutionStatus.ready].
  bool get ready => status.isReady;

  Map<String, Object?> toDeterministicMap() => {
        'capabilityId': capabilityId,
        'status': status.name,
        'ready': ready,
        'capability': capability?.toDeterministicMap(),
        'warnings': warnings.map((w) => w.toDeterministicMap()).toList(),
      };
}
