import 'package:eventpro/features/equipment/providers/equipment_category_repository_provider.dart';
import 'package:eventpro/features/equipment/providers/equipment_clock_provider.dart';
import 'package:eventpro/features/equipment/providers/equipment_repository_provider.dart';
import 'package:eventpro/features/equipment/providers/quote_equipment_repository_provider.dart';
import 'package:eventpro/features/quotes/providers/quote_repository_provider.dart';
import 'package:flutter_riverpod/misc.dart';

import '../../quotes/fakes/fake_quote_repository.dart';
import 'fake_equipment_category_repository.dart';
import 'fake_equipment_repository.dart';
import 'fake_quote_equipment_repository.dart';

List<Override> equipmentRepositoryOverrides({
  FakeEquipmentRepository? equipmentRepository,
  FakeEquipmentCategoryRepository? categoryRepository,
  FakeQuoteEquipmentRepository? quoteEquipmentRepository,
  FakeQuoteRepository? quoteRepository,
  DateTime Function()? clock,
}) {
  return [
    equipmentRepositoryProvider.overrideWithValue(
      equipmentRepository ?? FakeEquipmentRepository(),
    ),
    equipmentCategoryRepositoryProvider.overrideWithValue(
      categoryRepository ?? FakeEquipmentCategoryRepository(),
    ),
    quoteEquipmentRepositoryProvider.overrideWithValue(
      quoteEquipmentRepository ?? FakeQuoteEquipmentRepository(),
    ),
    quoteRepositoryProvider.overrideWithValue(
      quoteRepository ?? FakeQuoteRepository(),
    ),
    if (clock != null) equipmentClockProvider.overrideWithValue(clock),
  ];
}
