import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_state.dart';
import 'package:noted/core/widgets/custom_text_field.dart';
import 'package:noted/core/utils/snackbar.dart';
import 'package:noted/core/utils/validators.dart';
import '../widgets/auth_widgets.dart';
import 'package:noted/features/notes/presentation/screens/dashboard_screen.dart';
import '../../data/actions/auth_actions.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => DashboardScreen(user: state.user),
              ),
              (route) => false,
            );
          } else if (state is AuthError) {
            showSnackBar(context, state.message, color: colorScheme.error);
          }
        },
        child: Stack(
          children: [
            // Blob decoration
            Positioned(
              top: -40,
              right: -40,
              child: BlobDecoration(color: colorScheme.primary),
            ),
            SafeArea(
              child: Column(
                children: [
                  // Custom back button row
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              size: 18),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 8),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Create account',
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Join Noted and start writing',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 32),

                                FieldLabel(label: 'Full name'),
                                const SizedBox(height: 6),
                                CustomTextField(
                                  controller: _nameController,
                                  hint: 'Enter your full name',
                                  prefixIcon: Icons.person_outline_rounded,
                                  textInputAction: TextInputAction.next,
                                  validator: (v) =>
                                      Validators.required(v, 'Full Name'),
                                ),
                                const SizedBox(height: 20),

                                FieldLabel(label: 'Email'),
                                const SizedBox(height: 6),
                                CustomTextField(
                                  controller: _emailController,
                                  hint: 'Enter your email',
                                  prefixIcon: Icons.mail_outline_rounded,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  validator: Validators.email,
                                ),
                                const SizedBox(height: 20),

                                FieldLabel(label: 'Password'),
                                const SizedBox(height: 6),
                                CustomTextField(
                                  controller: _passwordController,
                                  hint: 'Minimum 6 characters',
                                  prefixIcon: Icons.lock_outline_rounded,
                                  obscureText: _obscurePassword,
                                  textInputAction: TextInputAction.next,
                                  validator: Validators.password,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                    ),
                                    onPressed: () => setState(() =>
                                        _obscurePassword = !_obscurePassword),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                FieldLabel(label: 'Confirm password'),
                                const SizedBox(height: 6),
                                CustomTextField(
                                  controller: _confirmPasswordController,
                                  hint: 'Re-enter your password',
                                  prefixIcon: Icons.lock_outline_rounded,
                                  obscureText: _obscureConfirm,
                                  textInputAction: TextInputAction.done,
                                  validator: (v) => Validators.confirmPassword(
                                      v, _passwordController.text),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirm
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                    ),
                                    onPressed: () => setState(
                                        () => _obscureConfirm = !_obscureConfirm),
                                  ),
                                ),
                                const SizedBox(height: 32),

                                BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, state) {
                                    return PillButton(
                                      label: 'Sign up',
                                      isLoading: state is AuthLoading,
                                      onPressed: () => AuthActions.onSignup(context, _formKey, _nameController.text, _emailController.text, _passwordController.text),
                                    );
                                  },
                                ),
                                const SizedBox(height: 24),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Already have an account? ',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          Navigator.of(context).pop(),
                                      child: Text(
                                        'Sign in',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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