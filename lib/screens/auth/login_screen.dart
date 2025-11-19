import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _loading = false;
  static const Color primary = Color(0xFF5C6BC0);

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  void _login() async {
    final email = _emailCtrl.text.trim();
    final password = _pwCtrl.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password tidak boleh kosong')),
      );
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Format email tidak valid')));
      return;
    }

    setState(() => _loading = true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      await auth.signInWithEmail(email, password);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/notes');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String errorMessage = 'Login gagal';
      switch (e.code) {
        case 'user-not-found':
          errorMessage =
              'Email tidak terdaftar. Silakan daftar terlebih dahulu.';
          break;
        case 'wrong-password':
          errorMessage = 'Password salah. Silakan coba lagi.';
          break;
        case 'invalid-email':
          errorMessage = 'Format email tidak valid.';
          break;
        case 'user-disabled':
          errorMessage = 'Akun Anda sudah dinonaktifkan. Hubungi support.';
          break;
        case 'too-many-requests':
          errorMessage =
              'Terlalu banyak percobaan login gagal. Coba lagi nanti.';
          break;
        default:
          errorMessage = e.message ?? 'Terjadi kesalahan saat login.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error tidak terduga: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _googleSignIn() async {
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final cred = await auth.signInWithGoogle();
      if (cred != null) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/notes');
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String errorMessage =
          e.message ?? 'Terjadi kesalahan saat Google Sign In.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 6),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Catatanku',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 28),

              // Card form
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _pwCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/register'),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: BorderSide(color: primary),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Register'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey[300],
                              thickness: 1,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('atau'),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey[300],
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _googleSignIn,
                          icon: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: const Icon(
                              Icons.g_mobiledata,
                              size: 18,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          label: const Text('Sign in dengan Google'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: BorderSide(color: Colors.grey.shade300),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  // forgot password - kamu bisa implementasi nanti
                },
                child: const Text('Forgot Password?'),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
