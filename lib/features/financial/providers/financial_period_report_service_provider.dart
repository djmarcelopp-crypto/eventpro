import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/financial_period_report_service.dart';
import 'financial_clock_provider.dart';

final financialPeriodReportServiceProvider =
    Provider<FinancialPeriodReportService>((ref) {
      return FinancialPeriodReportService(
        clock: ref.watch(financialClockProvider),
      );
    });
