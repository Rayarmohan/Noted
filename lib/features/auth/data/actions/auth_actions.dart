import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';

class AuthActions {
  static void onLogin(
    BuildContext context,
    GlobalKey<FormState> formKey,
    String email,
    String password,
  ) {
    if (formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginSubmitted(email: email.trim(), password: password),
      );
    }
  }

  static void onSignup(
    BuildContext context,
    GlobalKey<FormState> formKey,
    String name,
    String email,
    String password,
  ) {
    if (formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignupSubmitted(
          name: name.trim(),
          email: email.trim(),
          password: password,
        ),
      );
    }
  }
}
