import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/note_bloc.dart';
import '../../bloc/note_event.dart';
import '../../bloc/note_state.dart';
import 'package:noted/core/widgets/custom_text_field.dart';
import 'package:noted/core/widgets/loading_button.dart';
import 'package:noted/core/utils/snackbar.dart';
import 'package:noted/core/utils/validators.dart';
import '../../data/entities/note_entity.dart';

class AddEditNoteScreen extends StatefulWidget {
  final NoteEntity? note;

  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSaving = false;

  bool get _isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Note' : 'New Note'),
      ),
      body: BlocListener<NoteBloc, NoteState>(
        listener: (context, state) {
          if (state is NotesLoaded && !_isSaving) {
            setState(() => _isSaving = true);
          } else if (state is NoteError) {
            setState(() => _isSaving = false);
            showSnackBar(context, state.message,
                color: Theme.of(context).colorScheme.error);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  controller: _titleController,
                  label: 'Title',
                  hint: 'Enter note title',
                  prefixIcon: Icons.title,
                  textInputAction: TextInputAction.next,
                  validator: (v) => Validators.required(v, 'Title'),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  hint: 'Enter note description',
                  prefixIcon: Icons.description,
                  maxLines: 5,
                  textInputAction: TextInputAction.newline,
                ),
                const SizedBox(height: 24),
                LoadingButton(
                  label: _isEditing ? 'Update Note' : 'Save Note',
                  isLoading: _isSaving,
                  onPressed: _onSave,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      if (_isEditing) {
        context.read<NoteBloc>().add(
              UpdateNote(
                id: widget.note!.id,
                title: _titleController.text.trim(),
                description: _descriptionController.text.trim(),
              ),
            );
      } else {
        context.read<NoteBloc>().add(
              AddNote(
                title: _titleController.text.trim(),
                description: _descriptionController.text.trim(),
              ),
            );
      }
      Navigator.of(context).pop();
    }
  }
}
