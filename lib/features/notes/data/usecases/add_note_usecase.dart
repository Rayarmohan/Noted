import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';

class AddNoteUseCase {
  final NoteRepository repository;
  AddNoteUseCase(this.repository);

  Future<void> call(NoteEntity note) {
    return repository.addNote(note);
  }
}
