import 'contract_status.dart';

/// A contract linked to a quote.
///
/// Immutable domain entity. PDF generation and digital signature are out of
/// scope for the domain foundation checkpoint.
class Contract {
  const Contract({
    required this.id,
    required this.quoteId,
    required this.contractNumber,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.templateId,
    this.generatedAt,
    this.sentAt,
    this.signedAt,
    this.expiresAt,
    this.filePath,
    this.notes = '',
  });

  final String id;
  final String quoteId;
  final String? templateId;
  final String contractNumber;
  final ContractStatus status;
  final DateTime? generatedAt;
  final DateTime? sentAt;
  final DateTime? signedAt;
  final DateTime? expiresAt;
  final String? filePath;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isDraft => status == ContractStatus.draft;
  bool get isGenerated => status == ContractStatus.generated;
  bool get isSent => status == ContractStatus.sent;
  bool get isSigned => status == ContractStatus.signed;
  bool get isCancelled => status == ContractStatus.cancelled;
  bool get isExpired => status == ContractStatus.expired;

  Contract copyWith({
    String? id,
    String? quoteId,
    String? templateId,
    String? contractNumber,
    ContractStatus? status,
    DateTime? generatedAt,
    DateTime? sentAt,
    DateTime? signedAt,
    DateTime? expiresAt,
    String? filePath,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearTemplateId = false,
    bool clearGeneratedAt = false,
    bool clearSentAt = false,
    bool clearSignedAt = false,
    bool clearExpiresAt = false,
    bool clearFilePath = false,
  }) {
    return Contract(
      id: id ?? this.id,
      quoteId: quoteId ?? this.quoteId,
      templateId: clearTemplateId ? null : (templateId ?? this.templateId),
      contractNumber: contractNumber ?? this.contractNumber,
      status: status ?? this.status,
      generatedAt:
          clearGeneratedAt ? null : (generatedAt ?? this.generatedAt),
      sentAt: clearSentAt ? null : (sentAt ?? this.sentAt),
      signedAt: clearSignedAt ? null : (signedAt ?? this.signedAt),
      expiresAt: clearExpiresAt ? null : (expiresAt ?? this.expiresAt),
      filePath: clearFilePath ? null : (filePath ?? this.filePath),
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Contract &&
            other.id == id &&
            other.quoteId == quoteId &&
            other.templateId == templateId &&
            other.contractNumber == contractNumber &&
            other.status == status &&
            other.generatedAt == generatedAt &&
            other.sentAt == sentAt &&
            other.signedAt == signedAt &&
            other.expiresAt == expiresAt &&
            other.filePath == filePath &&
            other.notes == notes &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        quoteId,
        templateId,
        contractNumber,
        status,
        generatedAt,
        sentAt,
        signedAt,
        expiresAt,
        filePath,
        notes,
        createdAt,
        updatedAt,
      );
}
