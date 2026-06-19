import '../entities/note_entity.dart';

abstract class NoteRepository {
  Stream<List<NoteEntity>> getNotes(String userId);
  Future<void> addNote(NoteEntity note);
  Future<void> updateNote(NoteEntity note);
  Future<void> deleteNote(String noteId);
}
