import 'package:drift/drift.dart';
import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/core/database/converters/timestamp_converter.dart';
import 'package:eventpro/features/team/models/quote_team_member.dart';

abstract class QuoteTeamMemberMapper {
  static QuoteTeamMember toDomain(QuoteTeamMemberRow row) {
    return QuoteTeamMember(
      id: row.id,
      quoteId: row.quoteId,
      teamMemberId: row.teamMemberId,
      roleId: row.roleId,
      dailyRate: row.dailyRate,
      notes: row.notes,
      createdAt: TimestampConverter.fromUtcMillis(row.createdAt),
      updatedAt: TimestampConverter.fromUtcMillis(row.updatedAt),
    );
  }

  static QuoteTeamMembersCompanion toInsertCompanion(QuoteTeamMember item) {
    return _toCompanion(item);
  }

  static QuoteTeamMembersCompanion toUpdateCompanion(QuoteTeamMember item) {
    return _toCompanion(item);
  }

  static QuoteTeamMembersCompanion _toCompanion(QuoteTeamMember item) {
    return QuoteTeamMembersCompanion.insert(
      id: item.id,
      quoteId: item.quoteId,
      teamMemberId: item.teamMemberId,
      roleId: item.roleId,
      dailyRate: item.dailyRate,
      notes: Value(item.notes),
      createdAt: TimestampConverter.toUtcMillis(item.createdAt),
      updatedAt: TimestampConverter.toUtcMillis(item.updatedAt),
    );
  }
}
