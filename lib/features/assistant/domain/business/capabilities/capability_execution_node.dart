import 'assistant_business_capability_category.dart';
import 'assistant_business_capability_id.dart';
import 'assistant_business_capability_resolution.dart';
import 'assistant_business_capability_version.dart';
import 'capability_resolution_status.dart';

/// Ordered planning node linking a workflow business step to a capability
/// resolution. Declarative only — does not execute.
class CapabilityExecutionNode {
  const CapabilityExecutionNode({
    required this.index,
    required this.capabilityId,
    required this.status,
    required this.resolution,
    this.version,
    this.category,
    this.operationCode,
    this.stepId,
  });

  /// Zero-based order within the planned capability sequence.
  final int index;

  final AssistantBusinessCapabilityId capabilityId;
  final AssistantBusinessCapabilityVersion? version;
  final AssistantBusinessCapabilityCategory? category;
  final CapabilityResolutionStatus status;
  final AssistantBusinessCapabilityResolution resolution;

  /// Bridge to AI-017 operation code when known.
  final String? operationCode;

  /// Optional workflow step id from the definition.
  final String? stepId;

  bool get ready => status.isReady;

  Map<String, Object?> toDeterministicMap() => {
        'index': index,
        'capabilityId': capabilityId.toDeterministicMap(),
        'version': version?.toDeterministicMap(),
        'category': category?.name,
        'status': status.name,
        'operationCode': operationCode,
        'stepId': stepId,
        'resolution': resolution.toDeterministicMap(),
      };
}
