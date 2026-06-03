import '../entities/note_entity.dart';

abstract class NoteRepository {
  /// Get stream of all notes for a user
  Stream<List<NoteEntity>> getNotes(String userId);

  /// Add a new note
  Future<void> addNote(NoteEntity note);

  /// Update an existing note
  Future<void> updateNote(NoteEntity note);

  /// Delete a note by id
  Future<void> deleteNote(String noteId, String userId);
}
