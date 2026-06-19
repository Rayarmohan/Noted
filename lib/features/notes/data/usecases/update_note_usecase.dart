import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';

class UpdateNoteUseCase {
  final NoteRepository repository;
  UpdateNoteUseCase(this.repository);

  Future<void> call(NoteEntity note) {
    return repository.updateNote(note);
  }
}
