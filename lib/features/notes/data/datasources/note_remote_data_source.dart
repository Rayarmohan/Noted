import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noted/core/constants/app_constants.dart';
import 'package:noted/features/notes/data/models/note_model.dart';

class NoteRemoteDataSource {
  final FirebaseFirestore _firestore;

  NoteRemoteDataSource(this._firestore);

  Stream<List<NoteModel>> getNotes(String userId) {
    return _firestore
        .collection(AppConstants.notesCollection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final notes = snapshot.docs
          .map((doc) => NoteModel.fromFirestore(doc.id, doc.data()))
          .toList();
      notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return notes;
    });
  }

  Future<void> addNote(NoteModel note) async {
    await _firestore
        .collection(AppConstants.notesCollection)
        .doc(note.id)
        .set(note.toFirestore());
  }

  Future<void> updateNote(NoteModel note) async {
    await _firestore
        .collection(AppConstants.notesCollection)
        .doc(note.id)
        .update(note.toFirestore());
  }

  Future<void> deleteNote(String noteId) async {
    await _firestore
        .collection(AppConstants.notesCollection)
        .doc(noteId)
        .delete();
  }
}
