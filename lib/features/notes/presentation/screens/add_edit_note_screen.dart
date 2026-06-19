import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noted/features/auth/presentation/widgets/auth_widgets.dart';
import '../../bloc/note_bloc.dart';
import '../../bloc/note_state.dart';
import 'package:noted/core/utils/snackbar.dart';
import 'package:noted/core/utils/validators.dart';
import '../../data/entities/note_entity.dart';
import '../../data/actions/note_actions.dart';

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
  int _charCount = 0;

  bool get _isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
      _charCount = widget.note!.description.length;
    }
    _descriptionController.addListener(() {
      setState(() => _charCount = _descriptionController.text.length);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: BlocListener<NoteBloc, NoteState>(
        listener: (context, state) {
          if (state is NoteError) {
            setState(() => _isSaving = false);
            showSnackBar(context, state.message, color: colorScheme.error);
          }
        },
        child: Stack(
          children: [
            Positioned(
              top: -40,
              right: -40,
              child: BlobDecoration(color: colorScheme.primary),
            ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          borderRadius: BorderRadius.circular(99),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colorScheme.outlineVariant,
                                width: 0.5,
                              ),
                            ),
                            child: const Icon(
                                Icons.arrow_back_ios_new_rounded, size: 16),
                          ),
                        ),
                        const Spacer(),
                        if (_isEditing)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              'Editing',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isEditing ? 'Edit note' : 'New note',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isEditing
                              ? 'Last edited ${NoteActions.formatDate(widget.note!.updatedAt)}'
                              : NoteActions.formatDate(DateTime.now()),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Title field
                            Text(
                              'TITLE',
                              style: theme.textTheme.labelSmall?.copyWith(
                                letterSpacing: 1.0,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _titleController,
                              textInputAction: TextInputAction.next,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Give your note a title',
                                prefixIcon: const Icon(
                                    Icons.text_fields_rounded, size: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: colorScheme.outlineVariant,
                                    width: 0.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: colorScheme.outlineVariant
                                        .withOpacity(0.5),
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              validator: (v) => Validators.required(v, 'Title'),
                            ),
                            const SizedBox(height: 24),

                            // Content field
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'CONTENT',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    letterSpacing: 1.0,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                Text(
                                  '$_charCount chars',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant
                                        .withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _descriptionController,
                              maxLines: 8,
                              minLines: 6,
                              textInputAction: TextInputAction.newline,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.6,
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    'Write your note here…',
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: colorScheme.outlineVariant
                                        .withOpacity(0.5),
                                    width: 0.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Save button
                            FilledButton(
                              onPressed: _isSaving ? null : () => NoteActions.onSave(context, _formKey, _titleController, _descriptionController, widget.note, () => setState(() => _isSaving = true)),
                              style: FilledButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: const StadiumBorder(),
                              ),
                              child: _isSaving
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          _isEditing
                                              ? Icons.check_rounded
                                              : Icons.save_outlined,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _isEditing
                                              ? 'Update note'
                                              : 'Save note',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}