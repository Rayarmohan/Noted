import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_state.dart';
import 'login_screen.dart';
import 'package:noted/features/notes/presentation/screens/dashboard_screen.dart';
import 'package:noted/features/onboarding/presentation/screens/intro_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _onboardingChecked = false;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final onboarded = prefs.getBool('onboarding_complete') ?? false;
    if (!mounted) return;
    if (!onboarded) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const IntroScreen()),
      );
      return;
    }
    setState(() => _onboardingChecked = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_onboardingChecked) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => DashboardScreen(user: state.user),
            ),
          );
        } else if (state is Unauthenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
