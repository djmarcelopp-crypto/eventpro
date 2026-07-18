/// Presentation-only operational alert for the dashboard.
enum DashboardAlertSeverity { info, warning, error }

class DashboardAlert {
  const DashboardAlert({
    required this.id,
    required this.message,
    required this.severity,
    this.route,
  });

  final String id;
  final String message;
  final DashboardAlertSeverity severity;
  final String? route;
}
