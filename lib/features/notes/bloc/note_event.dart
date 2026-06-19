import 'package:equatable/equatable.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotes extends NoteEvent {
  final String userId;
  const LoadNotes({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class AddNote extends NoteEvent {
  final String title;
  final String description;

  const AddNote({required this.title, required this.description});

  @override
  List<Object?> get props => [title, description];
}

class UpdateNote extends NoteEvent {
  final String id;
  final String title;
  final String description;

  const UpdateNote({
    required this.id,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [id, title, description];
}

class DeleteNote extends NoteEvent {
  final String id;

  const DeleteNote({required this.id});

  @override
  List<Object?> get props => [id];
}
