import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class NoteService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // path: users/{uid}/notes
  CollectionReference notesCollection(String uid) =>
      _db.collection('users').doc(uid).collection('notes');

  Stream<List<Note>> streamNotes(String uid) {
    return notesCollection(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Note.fromDoc(d)).toList());
  }

  Future<void> addNote(String uid, Note note) {
    return notesCollection(uid).add(note.toMap());
  }

  Future<void> updateNote(String uid, Note note) {
    return notesCollection(uid).doc(note.id).update({
      'title': note.title,
      'content': note.content,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> deleteNote(String uid, String noteId) {
    return notesCollection(uid).doc(noteId).delete();
  }
}
