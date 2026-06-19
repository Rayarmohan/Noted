import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noted/features/auth/presentation/widgets/auth_widgets.dart';
import '../../bloc/note_bloc.dart';
import '../../bloc/note_event.dart';
import '../../bloc/note_state.dart';
import 'package:noted/features/auth/bloc/auth_bloc.dart';
import 'package:noted/features/auth/bloc/auth_state.dart';
import 'package:noted/core/theme/theme_cubit.dart';
import '../widgets/note_card.dart';
import 'package:noted/features/auth/data/entities/user_entity.dart';
import '../../data/entities/note_entity.dart';
import 'package:noted/features/auth/presentation/screens/login_screen.dart';
import '../widgets/note_widgets.dart';
import '../../data/actions/note_actions.dart';

class DashboardScreen extends StatefulWidget {
  final UserEntity user;
  const DashboardScreen({super.key, required this.user});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NoteBloc>().add(LoadNotes(userId: widget.user.id));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Blob decoration — matches auth screens
            Positioned(
              top: -40,
              right: -40,
              child: BlobDecoration(color: colorScheme.primary),
            ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 16, 0),
                    child: Row(
                      children: [
                        Text(
                          'Noted',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Spacer(),
                        IconCircleButton(
                          icon: context.watch<ThemeCubit>().state == ThemeMode.dark
                              ? Icons.light_mode_outlined
                              : Icons.dark_mode_outlined,
                          onPressed: () =>
                              context.read<ThemeCubit>().toggleTheme(),
                        ),
                        const SizedBox(width: 8),
                        IconCircleButton(
                          icon: Icons.logout_rounded,
                          onPressed: () => NoteActions.showLogoutDialog(context),
                        ),
                      ],
                    ),
                  ),

                  // Greeting + count
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hey, ${widget.user.name.split(' ').first} 👋',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        BlocBuilder<NoteBloc, NoteState>(
                          builder: (context, state) {
                            if (state is NotesLoaded) {
                              final count = state.notes.length;
                              return Text(
                                '$count ${count == 1 ? 'note' : 'notes'} total',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
                    child: Text(
                      'RECENT',
                      style: theme.textTheme.labelSmall?.copyWith(
                        letterSpacing: 1.2,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),

                  // Notes list
                  Expanded(
                    child: BlocBuilder<NoteBloc, NoteState>(
                      builder: (context, state) {
                        if (state is NoteLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is NotesLoaded) {
                          if (state.notes.isEmpty) return _buildEmptyState(theme);
                          return _buildNotesList(state.notes);
                        } else if (state is NoteError) {
                          return _buildErrorState(state.message, theme);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: FloatingActionButton.extended(
            onPressed: () => NoteActions.navigateToAddNote(context),
            elevation: 0,
            shape: const StadiumBorder(),
            label: const Text(
              'New note',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            icon: const Icon(Icons.add_rounded),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.note_alt_outlined,
              size: 32,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No notes yet',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap "New note" below to get started',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList(List<NoteEntity> notes) {
  return RefreshIndicator(
    onRefresh: () async =>
        context.read<NoteBloc>().add(LoadNotes(userId: widget.user.id)),
    child: GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.9,
      ),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return NoteCard(
          note: note,
          onEdit: () => NoteActions.navigateToEditNote(context, note),
          onDelete: () => NoteActions.showDeleteDialog(context, note),
        );
      },
    ),
  );
}

  Widget _buildErrorState(String message, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded,
              size: 48, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(message, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

}