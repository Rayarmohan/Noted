import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:noted/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:noted/features/notes/data/datasources/note_remote_data_source.dart';
import 'package:noted/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:noted/features/notes/data/repositories/note_repository_impl.dart';
import 'package:noted/features/auth/data/repositories/auth_repository.dart';
import 'package:noted/features/notes/data/repositories/note_repository.dart';
import 'package:noted/features/auth/data/usecases/signup_usecase.dart';
import 'package:noted/features/auth/data/usecases/login_usecase.dart';
import 'package:noted/features/auth/data/usecases/logout_usecase.dart';
import 'package:noted/features/auth/data/usecases/get_current_user_usecase.dart';
import 'package:noted/features/notes/data/usecases/add_note_usecase.dart';
import 'package:noted/features/notes/data/usecases/get_notes_usecase.dart';
import 'package:noted/features/notes/data/usecases/update_note_usecase.dart';
import 'package:noted/features/notes/data/usecases/delete_note_usecase.dart';
import 'package:noted/features/auth/bloc/auth_bloc.dart';
import 'package:noted/features/notes/bloc/note_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl(), sl()),
  );
  sl.registerLazySingleton<NoteRemoteDataSource>(
    () => NoteRemoteDataSource(sl()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<NoteRepository>(
    () => NoteRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => AddNoteUseCase(sl()));
  sl.registerLazySingleton(() => GetNotesUseCase(sl()));
  sl.registerLazySingleton(() => UpdateNoteUseCase(sl()));
  sl.registerLazySingleton(() => DeleteNoteUseCase(sl()));

  sl.registerFactory(
    () => AuthBloc(
      signUpUseCase: sl(),
      loginUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => NoteBloc(
      getNotesUseCase: sl(),
      addNoteUseCase: sl(),
      updateNoteUseCase: sl(),
      deleteNoteUseCase: sl(),
    ),
  );
}
