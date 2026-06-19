import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';
import '../datasources/note_remote_data_source.dart';
import '../models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteRemoteDataSource remoteDataSource;

  NoteRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<NoteEntity>> getNotes(String userId) {
    return remoteDataSource.getNotes(userId);
  }

  @override
  Future<void> addNote(NoteEntity note) async {
    await remoteDataSource.addNote(NoteModel(
      id: note.id,
      userId: note.userId,
      title: note.title,
      description: note.description,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
    ));
  }

  @override
  Future<void> updateNote(NoteEntity note) async {
    await remoteDataSource.updateNote(NoteModel(
      id: note.id,
      userId: note.userId,
      title: note.title,
      description: note.description,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
    ));
  }

  @override
  Future<void> deleteNote(String noteId) async {
    await remoteDataSource.deleteNote(noteId);
  }
}
