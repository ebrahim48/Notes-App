class NoteEntity {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int colorIndex;

  const NoteEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.colorIndex = 0,
  });

  NoteEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? colorIndex,
  }) {
    return NoteEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      colorIndex: colorIndex ?? this.colorIndex,
    );
  }

  @override
  String toString() =>
      'NoteEntity(id: $id, title: $title, userId: $userId)';
}
