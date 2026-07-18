import 'package:drift/drift.dart';
import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/core/database/converters/timestamp_converter.dart';
import 'package:eventpro/features/team/models/team_member.dart';
import 'package:eventpro/features/team/models/team_member_status.dart';

abstract class TeamMemberMapper {
  static TeamMember toDomain(TeamMemberRow row) {
    return TeamMember(
      id: row.id,
      name: row.name,
      phone: row.phone,
      email: row.email,
      roleId: row.roleId,
      observations: row.observations ?? '',
      dailyRate: row.dailyRate,
      status: TeamMemberStatus.values.byName(row.status),
      createdAt: TimestampConverter.fromUtcMillis(row.createdAt),
      updatedAt: TimestampConverter.fromUtcMillis(row.updatedAt),
    );
  }

  static TeamMembersCompanion toInsertCompanion(TeamMember member) {
    return _toCompanion(member);
  }

  static TeamMembersCompanion toUpdateCompanion(TeamMember member) {
    return _toCompanion(member);
  }

  static TeamMembersCompanion _toCompanion(TeamMember member) {
    final observations = member.observations.trim().isEmpty
        ? null
        : member.observations;
    return TeamMembersCompanion.insert(
      id: member.id,
      name: member.name,
      phone: member.phone,
      email: Value(member.email),
      roleId: member.roleId,
      observations: Value(observations),
      dailyRate: member.dailyRate,
      status: member.status.name,
      createdAt: TimestampConverter.toUtcMillis(member.createdAt),
      updatedAt: TimestampConverter.toUtcMillis(member.updatedAt),
    );
  }
}
