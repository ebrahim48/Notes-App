import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';
import '../../core/constants/app_constants.dart';

abstract class NoteRemoteDataSource {
  Stream<List<NoteModel>> getNotes(String userId);
  Future<void> addNote(NoteModel note);
  Future<void> updateNote(NoteModel note);
  Future<void> deleteNote(String noteId, String userId);
}

class NoteRemoteDataSourceImpl implements NoteRemoteDataSource {
  final FirebaseFirestore _firestore;

  NoteRemoteDataSourceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference<Map<String, dynamic>> get _notesRef =>
      _firestore.collection(AppConstants.notesCollection);

  @override
  Stream<List<NoteModel>> getNotes(String userId) {
    // orderBy is removed to avoid needing a composite Firestore index.
    // Sorting is done in-memory after fetching.
    return _notesRef
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final notes = snapshot.docs
          .map((doc) => NoteModel.fromMap(doc.data(), doc.id))
          .toList();
      notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return notes;
    });
  }

  @override
  Future<void> addNote(NoteModel note) async {
    await _notesRef.add(note.toMap());
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    await _notesRef.doc(note.id).update({
      'title': note.title,
      'description': note.description,
      'updatedAt': Timestamp.fromDate(note.updatedAt),
      'colorIndex': note.colorIndex,
    });
  }

  @override
  Future<void> deleteNote(String noteId, String userId) async {
    await _notesRef.doc(noteId).delete();
  }
}
