import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const Color primary = Color(0xFF5C6BC0);
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animasi progress bar
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start animasi
    _animationController.forward();

    // Cek auth setelah 3 detik
    Timer(const Duration(seconds: 3), _checkAuth);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _checkAuth() {
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final user = auth.currentUser;
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/notes');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Container dengan shadow
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.note_alt,
                  size: 64,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              // App Title
              const Text(
                'Catatanku',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle
              Text(
                'Catat Hal Penting Anda',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 32),
              // Animated Progress Bar
              SizedBox(
                width: 150,
                child: AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return Column(
                      children: [
                        // Linear Progress Indicator
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: _progressAnimation.value,
                            minHeight: 6,
                            backgroundColor: primary.withValues(alpha: 0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(primary),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Loading Text dengan opacity animation
                        Opacity(
                          opacity: 0.7,
                          child: Text(
                            'Memuat...',
                            style: TextStyle(
                              fontSize: 12,
                              color: primary,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
