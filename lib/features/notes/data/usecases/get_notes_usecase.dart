import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';

class GetNotesUseCase {
  final NoteRepository repository;
  GetNotesUseCase(this.repository);

  Stream<List<NoteEntity>> call(String userId) {
    return repository.getNotes(userId);
  }
}
