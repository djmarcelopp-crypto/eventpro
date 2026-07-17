import 'financial_flow_kind.dart';

/// A category used to classify [FinancialEntry] records (e.g. "Aluguel de
/// equipamentos", "Salários", "Locação de espaço").
///
/// A category has a fixed [kind]: it either groups revenues or expenses, it
/// never groups both. This mirrors the rule that a [FinancialEntry] must be
/// filed under a category of the same [kind].
class FinancialCategory {
  const FinancialCategory({
    required this.id,
    required this.name,
    required this.kind,
    required this.createdAt,
    this.active = true,
  });

  final String id;
  final String name;
  final FinancialFlowKind kind;
  final bool active;
  final DateTime createdAt;

  FinancialCategory copyWith({
    String? id,
    String? name,
    FinancialFlowKind? kind,
    bool? active,
    DateTime? createdAt,
  }) {
    return FinancialCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
