/// A line linking a [TeamMember] to a quote/event with a rate snapshot.
///
/// [dailyRate] is stored in **cents** at association time so later roster
/// changes do not rewrite historical quote costs. Does not create schedules,
/// check-ins, or payroll entries.
class QuoteTeamMember {
  const QuoteTeamMember({
    required this.id,
    required this.quoteId,
    required this.teamMemberId,
    required this.roleId,
    required this.dailyRate,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
  });

  final String id;
  final String quoteId;
  final String teamMemberId;

  /// Role snapshot at association time ([TeamRole.id]).
  final String roleId;

  /// Daily rate snapshot in cents.
  final int dailyRate;

  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  QuoteTeamMember copyWith({
    String? id,
    String? quoteId,
    String? teamMemberId,
    String? roleId,
    int? dailyRate,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearNotes = false,
  }) {
    return QuoteTeamMember(
      id: id ?? this.id,
      quoteId: quoteId ?? this.quoteId,
      teamMemberId: teamMemberId ?? this.teamMemberId,
      roleId: roleId ?? this.roleId,
      dailyRate: dailyRate ?? this.dailyRate,
      notes: clearNotes ? null : (notes ?? this.notes),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is QuoteTeamMember &&
            other.id == id &&
            other.quoteId == quoteId &&
            other.teamMemberId == teamMemberId &&
            other.roleId == roleId &&
            other.dailyRate == dailyRate &&
            other.notes == notes &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        quoteId,
        teamMemberId,
        roleId,
        dailyRate,
        notes,
        createdAt,
        updatedAt,
      );
}
