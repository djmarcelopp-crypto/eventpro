import 'team_member_status.dart';

/// A person on the event company roster (Equipe & Escalas).
///
/// Immutable domain entity. Persistence, schedules, providers and UI are
/// intentionally out of scope for the domain foundation checkpoint.
///
/// [dailyRate] is stored in **cents** (integer), aligned with Financeiro /
/// Orçamentos monetary conventions.
class TeamMember {
  const TeamMember({
    required this.id,
    required this.name,
    required this.phone,
    required this.roleId,
    required this.dailyRate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.email,
    this.observations = '',
  });

  final String id;
  final String name;
  final String phone;

  /// Optional contact e-mail. `null` when not provided.
  final String? email;

  final String roleId;
  final String observations;

  /// Daily rate in cents. Must be greater than or equal to zero
  /// (validated by [TeamMemberValidator]).
  final int dailyRate;

  final TeamMemberStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isActive => status == TeamMemberStatus.active;
  bool get isUnavailable => status == TeamMemberStatus.unavailable;
  bool get isInactive => status == TeamMemberStatus.inactive;

  TeamMember copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? roleId,
    String? observations,
    int? dailyRate,
    TeamMemberStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearEmail = false,
  }) {
    return TeamMember(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: clearEmail ? null : (email ?? this.email),
      roleId: roleId ?? this.roleId,
      observations: observations ?? this.observations,
      dailyRate: dailyRate ?? this.dailyRate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TeamMember &&
            other.id == id &&
            other.name == name &&
            other.phone == phone &&
            other.email == email &&
            other.roleId == roleId &&
            other.observations == observations &&
            other.dailyRate == dailyRate &&
            other.status == status &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        phone,
        email,
        roleId,
        observations,
        dailyRate,
        status,
        createdAt,
        updatedAt,
      );
}
