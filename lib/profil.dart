import 'package:flutter/material.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilSayfasi extends StatefulWidget {
  @override
  _ProfilSayfasiState createState() => _ProfilSayfasiState();
}

class _ProfilSayfasiState extends State<ProfilSayfasi> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  Future<void> _signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MyHomePage()),
          (route) => false,
        );
      }
    } catch (e) {
      print('Çıkış hatası: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Çıkış yapılırken bir hata oluştu'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue.shade900),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profil',
          style: TextStyle(color: Colors.blue.shade900),
        ),
      ),
      body: _user == null
          ? Center(
              child: Text('Giriş yapılmamış'),
            )
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue.shade50,
                        backgroundImage: _user?.photoURL != null
                            ? NetworkImage(_user!.photoURL!)
                            : null,
                        child: _user?.photoURL == null
                            ? Text(
                                _user?.displayName
                                        ?.substring(0, 2)
                                        .toUpperCase() ??
                                    '?',
                                style: TextStyle(
                                  fontSize: 32,
                                  color: Colors.blue.shade900,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.blue.shade900),
                    title: Text('Ad Soyad'),
                    subtitle: Text(_user?.displayName ?? 'İsimsiz'),
                  ),
                  ListTile(
                    leading: Icon(Icons.email, color: Colors.blue.shade900),
                    title: Text('E-posta'),
                    subtitle: Text(_user?.email ?? ''),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.book, color: Colors.blue.shade900),
                    title: Text('Toplam Okunan Kitap'),
                    subtitle: Text('0'),
                  ),
                  ListTile(
                    leading: Icon(Icons.favorite, color: Colors.blue.shade900),
                    title: Text('Beğenilen Kitaplar'),
                    subtitle: Text('0'),
                  ),
                  Spacer(),
                  ElevatedButton.icon(
                    onPressed: _signOut,
                    icon: Icon(Icons.logout),
                    label: Text('Oturumu Kapat'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
    );
  }
}
