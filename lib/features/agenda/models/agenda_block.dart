class AgendaBlock {
  const AgendaBlock({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
  });

  final String id;
  final String title;
  final String? notes;
  final DateTime start;
  final DateTime end;
  final DateTime createdAt;
  final DateTime updatedAt;

  AgendaBlock copyWith({
    String? id,
    String? title,
    DateTime? start,
    DateTime? end,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
    bool clearNotes = false,
  }) {
    return AgendaBlock(
      id: id ?? this.id,
      title: title ?? this.title,
      start: start ?? this.start,
      end: end ?? this.end,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: clearNotes ? null : (notes ?? this.notes),
    );
  }
}
