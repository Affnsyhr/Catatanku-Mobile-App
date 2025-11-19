import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/note.dart';
import '../../services/auth_service.dart';
import '../../services/note_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditNoteScreen extends StatefulWidget {
  final Note? note;
  const EditNoteScreen({super.key, this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  bool _loading = false;
  static const Color primary = Color(0xFF5C6BC0);

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleCtrl.text = widget.note!.title;
      _contentCtrl.text = widget.note!.content;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final uid = auth.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User belum login'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final title = _titleCtrl.text.trim();
    final content = _contentCtrl.text.trim();
    if (title.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi atau judul tidak boleh kosong')),
      );
      return;
    }

    setState(() => _loading = true);
    final noteService = NoteService();
    try {
      if (widget.note == null) {
        final newNote = Note(
          title: title.isEmpty ? 'Tanpa judul' : title,
          content: content,
          createdAt: Timestamp.now(),
        );
        await noteService.addNote(uid, newNote);
      } else {
        final edited = widget.note!
          ..title = title
          ..content = content
          ..updatedAt = Timestamp.now();
        await noteService.updateNote(uid, edited);
      }
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.note != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Catatan' : 'Tambah Catatan'),
        backgroundColor: primary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _titleCtrl,
                decoration: InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TextField(
                  controller: _contentCtrl,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    labelText: 'Isi',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('[ Simpan ]'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
