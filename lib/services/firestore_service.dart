import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Kullanıcı bilgilerini kaydet
  Future<void> saveUserData(String name, String email) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Kullanıcı bilgilerini getir
  Future<Map<String, dynamic>?> getUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      return doc.data();
    }
    return null;
  }

  // Kitap ekle
  Future<void> addBook(String title, String author, String coverUrl) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('books').add({
        'title': title,
        'author': author,
        'coverUrl': coverUrl,
        'userId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Kullanıcının kitaplarını getir
  Stream<QuerySnapshot> getUserBooks() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('books')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .snapshots();
    }
    return const Stream.empty();
  }
}
