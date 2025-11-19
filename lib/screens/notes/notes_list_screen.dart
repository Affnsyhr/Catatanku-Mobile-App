import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/note_service.dart';
import '../../models/note.dart';
import '../settings_screen.dart';
import 'edit_note_screen.dart';

class NotesListScreen extends StatelessWidget {
  const NotesListScreen({super.key});
  static const Color primary = Color(0xFF5C6BC0);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final uid = auth.currentUser?.uid;
    final noteService = NoteService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text('Catatan Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutConfirmation(context, auth),
          ),
        ],
      ),
      body: uid == null
          ? const Center(child: Text('User belum login'))
          : StreamBuilder<List<Note>>(
              stream: noteService.streamNotes(uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final notes = snapshot.data ?? [];
                if (notes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.note_add_outlined,
                          size: 72,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Belum ada catatan',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: notes.length,
                  itemBuilder: (context, i) {
                    final n = notes[i];
                    return _noteCard(context, n, uid, noteService);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EditNoteScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, AuthService auth) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar Aplikasi'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              await auth.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            child: const Text(
              'Ya, Keluar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _noteCard(
    BuildContext context,
    Note note,
    String uid,
    NoteService noteService,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: Container(
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: const Icon(Icons.sticky_note_2, color: primary),
        ),
        title: Text(
          note.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(_formatTimestamp(note.createdAt), maxLines: 1),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () async {
            try {
              await noteService.deleteNote(uid, note.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Catatan dihapus'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal hapus: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EditNoteScreen(note: note)),
        ),
      ),
    );
  }

  static String _formatTimestamp(dynamic ts) {
    // ts biasanya Timestamp (Firestore). Kita handle jika null.
    try {
      final date = (ts != null && ts is DateTime)
          ? ts
          : (ts?.toDate?.call() ?? DateTime.now());
      final day = date.day.toString().padLeft(2, '0');
      final month = _monthName(date.month);
      final year = date.year;
      return '$day $month $year';
    } catch (e) {
      return '-';
    }
  }

  static String _monthName(int m) {
    const names = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    if (m >= 1 && m <= 12) return names[m - 1];
    return '';
  }
}
