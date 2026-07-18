import 'package:drift/drift.dart';
import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/core/database/converters/timestamp_converter.dart';
import 'package:eventpro/features/team/models/team_role.dart';

abstract class TeamRoleMapper {
  static TeamRole toDomain(TeamRoleRow row) {
    return TeamRole(
      id: row.id,
      name: row.name,
      description: row.description,
      active: row.active,
      createdAt: TimestampConverter.fromUtcMillis(row.createdAt),
      updatedAt: TimestampConverter.fromUtcMillis(row.updatedAt),
    );
  }

  static TeamRolesCompanion toInsertCompanion(TeamRole role) {
    return _toCompanion(role);
  }

  static TeamRolesCompanion toUpdateCompanion(TeamRole role) {
    return _toCompanion(role);
  }

  static TeamRolesCompanion _toCompanion(TeamRole role) {
    return TeamRolesCompanion.insert(
      id: role.id,
      name: role.name,
      description: Value(role.description),
      active: role.active,
      createdAt: TimestampConverter.toUtcMillis(role.createdAt),
      updatedAt: TimestampConverter.toUtcMillis(role.updatedAt),
    );
  }
}
