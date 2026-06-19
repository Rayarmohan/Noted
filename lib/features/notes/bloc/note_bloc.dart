import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'note_event.dart';
import 'note_state.dart';
import '../data/entities/note_entity.dart';
import '../data/usecases/add_note_usecase.dart';
import '../data/usecases/get_notes_usecase.dart';
import '../data/usecases/update_note_usecase.dart';
import '../data/usecases/delete_note_usecase.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final GetNotesUseCase getNotesUseCase;
  final AddNoteUseCase addNoteUseCase;
  final UpdateNoteUseCase updateNoteUseCase;
  final DeleteNoteUseCase deleteNoteUseCase;
  String? _currentUserId;

  NoteBloc({
    required this.getNotesUseCase,
    required this.addNoteUseCase,
    required this.updateNoteUseCase,
    required this.deleteNoteUseCase,
  }) : super(NoteInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
  }

  Future<void> _onLoadNotes(LoadNotes event, Emitter<NoteState> emit) async {
    _currentUserId = event.userId;
    emit(NoteLoading());
    await emit.forEach(
      getNotesUseCase.call(event.userId),
      onData: (notes) => NotesLoaded(notes),
      onError: (error, _) => NoteError(error.toString()),
    );
  }

  Future<void> _onAddNote(AddNote event, Emitter<NoteState> emit) async {
    try {
      final note = NoteEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString() +
            Random().nextInt(9999).toString(),
        userId: _currentUserId!,
        title: event.title,
        description: event.description,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await addNoteUseCase.call(note);
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }

  Future<void> _onUpdateNote(
    UpdateNote event,
    Emitter<NoteState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is NotesLoaded) {
        final oldNote = currentState.notes.firstWhere((n) => n.id == event.id);
        final updatedNote = NoteEntity(
          id: event.id,
          userId: oldNote.userId,
          title: event.title,
          description: event.description,
          createdAt: oldNote.createdAt,
          updatedAt: DateTime.now(),
        );
        await updateNoteUseCase.call(updatedNote);
      }
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }

  Future<void> _onDeleteNote(
    DeleteNote event,
    Emitter<NoteState> emit,
  ) async {
    try {
      await deleteNoteUseCase.call(event.id);
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }
}
