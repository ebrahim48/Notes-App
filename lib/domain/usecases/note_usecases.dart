import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';

class GetNotesUseCase {
  final NoteRepository _repository;

  GetNotesUseCase(this._repository);

  Stream<List<NoteEntity>> call(String userId) => _repository.getNotes(userId);
}

class AddNoteUseCase {
  final NoteRepository _repository;

  AddNoteUseCase(this._repository);

  Future<void> call(NoteEntity note) => _repository.addNote(note);
}

class UpdateNoteUseCase {
  final NoteRepository _repository;

  UpdateNoteUseCase(this._repository);

  Future<void> call(NoteEntity note) => _repository.updateNote(note);
}

class DeleteNoteUseCase {
  final NoteRepository _repository;

  DeleteNoteUseCase(this._repository);

  Future<void> call(String noteId, String userId) =>
      _repository.deleteNote(noteId, userId);
}
