/// Semantic version for a declared business capability.
///
/// Stable ids identify the capability; [AssistantBusinessCapabilityVersion]
/// tracks declarative contract evolution without ERP coupling.
class AssistantBusinessCapabilityVersion {
  const AssistantBusinessCapabilityVersion({
    required this.major,
    this.minor = 0,
    this.patch = 0,
  });

  /// Initial catalog version for AI-018 built-ins.
  static const v1 = AssistantBusinessCapabilityVersion(major: 1);

  final int major;
  final int minor;
  final int patch;

  String get label => '$major.$minor.$patch';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssistantBusinessCapabilityVersion &&
          other.major == major &&
          other.minor == minor &&
          other.patch == patch;

  @override
  int get hashCode => Object.hash(major, minor, patch);

  @override
  String toString() => label;

  Map<String, Object?> toDeterministicMap() => {
        'major': major,
        'minor': minor,
        'patch': patch,
        'label': label,
      };
}
