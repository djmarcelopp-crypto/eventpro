import 'package:eventpro/features/team/models/team_member_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TeamMemberStatus', () {
    test('exposes all expected values', () {
      expect(TeamMemberStatus.values, [
        TeamMemberStatus.active,
        TeamMemberStatus.unavailable,
        TeamMemberStatus.inactive,
      ]);
    });

    test('labels are in Portuguese', () {
      expect(TeamMemberStatus.active.label, 'Ativo');
      expect(TeamMemberStatus.unavailable.label, 'Indisponível');
      expect(TeamMemberStatus.inactive.label, 'Inativo');
    });
  });
}
