import '../catalog_item_type.dart';
import '../catalog_package_constants.dart';
import '../models/catalog_item.dart';
import '../models/catalog_package_component.dart';
import 'catalog_quantity_validator.dart';

enum CatalogPackageIssueSeverity {
  error,
  warning,
}

class CatalogPackageIssue {
  const CatalogPackageIssue({
    required this.message,
    required this.severity,
    this.catalogItemId,
  });

  final String? catalogItemId;
  final String message;
  final CatalogPackageIssueSeverity severity;

  bool get isError => severity == CatalogPackageIssueSeverity.error;
  bool get isWarning => severity == CatalogPackageIssueSeverity.warning;
}

class CatalogPackageValidationResult {
  const CatalogPackageValidationResult({
    required this.issues,
  });

  final List<CatalogPackageIssue> issues;

  bool get canSave => !issues.any((issue) => issue.isError);

  bool get hasWarnings => issues.any((issue) => issue.isWarning);
}

abstract class CatalogPackageValidator {
  static CatalogPackageValidationResult validate({
    required CatalogItem item,
    required CatalogItem? Function(String id) resolveItem,
    Set<String> existingComponentIds = const {},
  }) {
    final issues = <CatalogPackageIssue>[];

    if (item.type == CatalogItemType.package) {
      issues.addAll(_validatePackageStructure(item));
      issues.addAll(
        _validateComponents(
          components: item.components,
          resolveItem: resolveItem,
          existingComponentIds: existingComponentIds,
        ),
      );
    } else if (item.components.isNotEmpty) {
      issues.add(
        const CatalogPackageIssue(
          message: 'Somente pacotes podem ter componentes',
          severity: CatalogPackageIssueSeverity.error,
        ),
      );
    }

    return CatalogPackageValidationResult(issues: List.unmodifiable(issues));
  }

  static List<CatalogPackageIssue> _validatePackageStructure(CatalogItem item) {
    final issues = <CatalogPackageIssue>[];

    if (item.unit != CatalogPackageConstants.unit) {
      issues.add(
        const CatalogPackageIssue(
          message: 'Pacotes devem usar a unidade "Pacote"',
          severity: CatalogPackageIssueSeverity.error,
        ),
      );
    }

    if (item.components.isEmpty) {
      issues.add(
        const CatalogPackageIssue(
          message: 'Informe pelo menos um componente no pacote',
          severity: CatalogPackageIssueSeverity.error,
        ),
      );
    }

    return issues;
  }

  static List<CatalogPackageIssue> _validateComponents({
    required List<CatalogPackageComponent> components,
    required CatalogItem? Function(String id) resolveItem,
    required Set<String> existingComponentIds,
  }) {
    final issues = <CatalogPackageIssue>[];
    final seenIds = <String>{};

    for (final component in components) {
      final componentId = component.catalogItemId.trim();

      if (componentId.isEmpty) {
        issues.add(
          const CatalogPackageIssue(
            message: 'Componente sem referência de catálogo',
            severity: CatalogPackageIssueSeverity.error,
          ),
        );
        continue;
      }

      if (!CatalogQuantityValidator.isValid(component.quantityPerPackage)) {
        issues.add(
          CatalogPackageIssue(
            catalogItemId: componentId,
            message: 'Quantidade por pacote inválida',
            severity: CatalogPackageIssueSeverity.error,
          ),
        );
      }

      if (!seenIds.add(componentId)) {
        issues.add(
          CatalogPackageIssue(
            catalogItemId: componentId,
            message: 'Componente duplicado no pacote',
            severity: CatalogPackageIssueSeverity.error,
          ),
        );
      }

      final referenced = resolveItem(componentId);
      if (referenced == null) {
        issues.add(
          CatalogPackageIssue(
            catalogItemId: componentId,
            message: 'Componente não encontrado no catálogo',
            severity: CatalogPackageIssueSeverity.error,
          ),
        );
        continue;
      }

      if (referenced.type == CatalogItemType.package) {
        issues.add(
          CatalogPackageIssue(
            catalogItemId: componentId,
            message: 'Pacotes não podem conter outros pacotes',
            severity: CatalogPackageIssueSeverity.error,
          ),
        );
        continue;
      }

      if (!referenced.active) {
        final isExisting = existingComponentIds.contains(componentId);
        issues.add(
          CatalogPackageIssue(
            catalogItemId: componentId,
            message: isExisting
                ? 'Componente inativo preservado no pacote'
                : 'Somente equipamentos e serviços ativos podem ser adicionados',
            severity: isExisting
                ? CatalogPackageIssueSeverity.warning
                : CatalogPackageIssueSeverity.error,
          ),
        );
      }
    }

    return issues;
  }
}
