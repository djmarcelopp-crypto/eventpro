import 'package:eventpro/features/contracts/providers/contract_repository_provider.dart';
import 'package:eventpro/features/contracts/providers/contract_template_repository_provider.dart';
import 'package:eventpro/features/contracts/providers/contracts_clock_provider.dart';
import 'package:eventpro/features/quotes/providers/quote_repository_provider.dart';
import 'package:flutter_riverpod/misc.dart';

import '../../quotes/fakes/fake_quote_repository.dart';
import 'fake_contract_repository.dart';
import 'fake_contract_template_repository.dart';

List<Override> contractsRepositoryOverrides({
  FakeContractRepository? contractRepository,
  FakeContractTemplateRepository? templateRepository,
  FakeQuoteRepository? quoteRepository,
  DateTime Function()? clock,
}) {
  return [
    contractRepositoryProvider.overrideWithValue(
      contractRepository ?? FakeContractRepository(),
    ),
    contractTemplateRepositoryProvider.overrideWithValue(
      templateRepository ?? FakeContractTemplateRepository(),
    ),
    quoteRepositoryProvider.overrideWithValue(
      quoteRepository ?? FakeQuoteRepository(),
    ),
    if (clock != null) contractsClockProvider.overrideWithValue(clock),
  ];
}
