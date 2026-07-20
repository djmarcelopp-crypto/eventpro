/// Semantic version for a declared business command.
///
/// Stable ids identify the command; [AssistantBusinessCommandVersion]
/// tracks declarative contract evolution without ERP coupling.
class AssistantBusinessCommandVersion {
  const AssistantBusinessCommandVersion({
    required this.major,
    this.minor = 0,
    this.patch = 0,
  });

  /// Initial contract version for AI-019 CP-1.
  static const v1 = AssistantBusinessCommandVersion(major: 1);

  final int major;
  final int minor;
  final int patch;

  String get label => '$major.$minor.$patch';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssistantBusinessCommandVersion &&
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
