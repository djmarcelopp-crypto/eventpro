import 'package:flutter/material.dart';

import '../catalog_billing_unit.dart';
import '../catalog_category.dart';
import '../catalog_item_type.dart';
import '../models/catalog_item.dart';
import 'catalog_price_formatter.dart';

class CatalogFormValues {
  const CatalogFormValues({
    required this.type,
    required this.category,
    required this.billingUnit,
    required this.active,
    required this.name,
    required this.description,
    required this.customUnit,
    required this.priceText,
  });

  final CatalogItemType type;
  final CatalogCategory category;
  final CatalogBillingUnit billingUnit;
  final bool active;
  final String name;
  final String description;
  final String customUnit;
  final String priceText;
}

abstract class CatalogFormInitializer {
  static CatalogFormValues fromItem(CatalogItem item) {
    final unitValues = CatalogBillingUnitResolver.fromStoredUnit(item.unit);

    return CatalogFormValues(
      type: item.type,
      category: item.category,
      billingUnit: unitValues.unit,
      active: item.active,
      name: item.name,
      description: item.description ?? '',
      customUnit: unitValues.customUnit ?? '',
      priceText: CatalogPriceFormatter.formatForInput(item.price),
    );
  }

  static void applyToControllers({
    required CatalogFormValues values,
    required TextEditingController nameController,
    required TextEditingController descriptionController,
    required TextEditingController customUnitController,
    required TextEditingController priceController,
  }) {
    nameController.text = values.name;
    descriptionController.text = values.description;
    customUnitController.text = values.customUnit;
    priceController.text = values.priceText;
  }
}
