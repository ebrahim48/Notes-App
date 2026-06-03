import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/note_remote_datasource.dart';
import '../models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteRemoteDataSource _dataSource;

  NoteRepositoryImpl({required NoteRemoteDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Stream<List<NoteEntity>> getNotes(String userId) {
    return _dataSource.getNotes(userId);
  }

  @override
  Future<void> addNote(NoteEntity note) async {
    await _dataSource.addNote(NoteModel.fromEntity(note));
  }

  @override
  Future<void> updateNote(NoteEntity note) async {
    await _dataSource.updateNote(NoteModel.fromEntity(note));
  }

  @override
  Future<void> deleteNote(String noteId, String userId) async {
    await _dataSource.deleteNote(noteId, userId);
  }
}
