import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  final _pw2Ctrl = TextEditingController();
  bool _loading = false;
  static const Color primary = Color(0xFF5C6BC0);

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    _pw2Ctrl.dispose();
    super.dispose();
  }

  void _register() async {
    final email = _emailCtrl.text.trim();
    final pw = _pwCtrl.text;
    final pw2 = _pw2Ctrl.text;

    if (email.isEmpty || pw.isEmpty || pw2.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Semua field wajib diisi')));
      return;
    }
    if (pw != pw2) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Password tidak sama')));
      return;
    }

    setState(() => _loading = true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      await auth.registerWithEmail(email, pw);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/notes');
    } on FirebaseAuthException catch (e) {
      String err = e.message ?? 'Gagal registrasi';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(err), backgroundColor: Colors.red));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register'), backgroundColor: primary),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 8),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _pwCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _pw2Ctrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
