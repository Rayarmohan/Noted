import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/note_bloc.dart';
import '../../bloc/note_event.dart';
import '../../data/entities/note_entity.dart';
import 'package:noted/features/auth/bloc/auth_bloc.dart';
import 'package:noted/features/auth/bloc/auth_event.dart';
import 'package:noted/features/notes/presentation/screens/add_edit_note_screen.dart';

class NoteActions {
  static void navigateToAddNote(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddEditNoteScreen()),
    );
  }

  static void navigateToEditNote(BuildContext context, NoteEntity note) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AddEditNoteScreen(note: note)),
    );
  }

  static void showDeleteDialog(BuildContext context, NoteEntity note) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete note'),
        content: Text('Delete "${note.title}"? This can\'t be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<NoteBloc>().add(DeleteNote(id: note.id));
              Navigator.of(ctx).pop();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  static void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<AuthBloc>().add(LogoutPressed());
              Navigator.of(ctx).pop();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  static void onSave(
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController titleController,
    TextEditingController descriptionController,
    NoteEntity? note,
    VoidCallback onSaving,
  ) {
    if (formKey.currentState!.validate()) {
      onSaving();
      if (note != null) {
        context.read<NoteBloc>().add(
          UpdateNote(
            id: note.id,
            title: titleController.text.trim(),
            description: descriptionController.text.trim(),
          ),
        );
      } else {
        context.read<NoteBloc>().add(
          AddNote(
            title: titleController.text.trim(),
            description: descriptionController.text.trim(),
          ),
        );
      }
      Navigator.of(context).pop();
    }
  }

  static String formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}
