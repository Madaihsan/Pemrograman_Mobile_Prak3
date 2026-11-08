import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task.dart';

class FirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mendapatkan referensi koleksi tugas milik user yang sedang login (Tugas 2: users/{uid}/tasks)
  CollectionReference<Map<String, dynamic>> _getTasksRef() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Pengguna belum login.');
    }
    return _firestore.collection('users').doc(user.uid).collection('tasks');
  }

  // Tambah tugas baru
  Future<void> addTask(String title) async {
    await _getTasksRef().add({
      'title': title,
      'isDone': false,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Mengambil daftar tugas secara real-time berdasarkan urutan waktu terbaru
  Stream<List<Task>> getTasks() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }
    return _getTasksRef()
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromDoc(doc.id, doc.data()))
            .toList());
  }

  // Ubah status selesai / belum
  Future<void> toggleDone(String id, bool value) async {
    await _getTasksRef().doc(id).update({'isDone': value});
  }

  // Ubah judul tugas (Nilai Tambah Praktikum 3)
  Future<void> editTask(String id, String newTitle) async {
    await _getTasksRef().doc(id).update({'title': newTitle});
  }

  // Hapus tugas
  Future<void> deleteTask(String id) async {
    await _getTasksRef().doc(id).delete();
  }
}

