/// Presentation-only recent activity row for the dashboard.
enum DashboardActivityKind { contract, invoice, quote, agenda }

class DashboardActivityItem {
  const DashboardActivityItem({
    required this.id,
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.occurredAt,
    this.route,
  });

  final String id;
  final DashboardActivityKind kind;
  final String title;
  final String subtitle;
  final DateTime occurredAt;
  final String? route;
}
