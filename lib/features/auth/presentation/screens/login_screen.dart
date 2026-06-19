import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_state.dart';
import 'package:noted/core/theme/theme_cubit.dart';
import 'package:noted/core/widgets/custom_text_field.dart';
import 'package:noted/core/utils/snackbar.dart';
import 'package:noted/core/utils/validators.dart';
import '../widgets/auth_widgets.dart';
import 'signup_screen.dart';
import 'package:noted/features/notes/presentation/screens/dashboard_screen.dart';
import '../../data/actions/auth_actions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => DashboardScreen(user: state.user),
              ),
            );
          } else if (state is AuthError) {
            showSnackBar(context, state.message, color: colorScheme.error);
          }
        },
        child: Stack(
          children: [
            // Blob decoration (top-right)
            Positioned(
              top: -40,
              right: -40,
              child: BlobDecoration(color: colorScheme.primary),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 48),
                          // App icon
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.note_alt_outlined,
                              size: 28,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Welcome back',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Sign in to continue to Noted',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Email field
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

                          // Password field
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FieldLabel(label: 'Password'),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text('Forgot?'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          CustomTextField(
                            controller: _passwordController,
                            hint: 'Enter your password',
                            prefixIcon: Icons.lock_outline_rounded,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            validator: Validators.password,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Sign in button
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return PillButton(
                                label: 'Sign in',
                                isLoading: state is AuthLoading,
                                onPressed: () => AuthActions.onLogin(context, _formKey, _emailController.text, _passwordController.text),
                              );
                            },
                          ),
                          const SizedBox(height: 24),

                          // Sign up link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const SignupScreen(),
                                  ),
                                ),
                                child: Text(
                                  'Sign up',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Theme toggle
                          Center(
                            child: IconButton(
                              icon: Icon(
                                context.watch<ThemeCubit>().state == ThemeMode.dark
                                    ? Icons.light_mode_outlined
                                    : Icons.dark_mode_outlined,
                                size: 20,
                              ),
                              onPressed: () =>
                                  context.read<ThemeCubit>().toggleTheme(),
                            ),
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
    );
  }

}