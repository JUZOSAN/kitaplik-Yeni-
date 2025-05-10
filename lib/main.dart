import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'indirilen.dart';
import 'begendigim_kitaplar.dart';
import 'navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBUOK4EwbUmwjOf8ieOmccL_JFijsvnFUc",
          authDomain: "kitappppp-f04a3.firebaseapp.com",
          projectId: "kitappppp-f04a3",
          storageBucket: "kitappppp-f04a3.firebasestorage.app",
          messagingSenderId: "794287189815",
          appId: "1:794287189815:web:ad89e612ba7acbf142b4b2",
          measurementId: "G-1XQ4Q2RR2D"),
    );
  } catch (e) {
    print('Firebase başlatma hatası: $e');
  }
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kitaplık',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    try {
      _user = _auth.currentUser;
      if (_user != null) {
        // Kullanıcı zaten giriş yapmış
        print('Kullanıcı giriş yapmış: ${_user?.email}');
      }
      setState(() {});
    } catch (e) {
      print('Kullanıcı kontrolü hatası: $e');
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Google hesabıyla giriş yap
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Google kimlik doğrulama bilgilerini al
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Firebase kimlik bilgilerini oluştur
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase'e giriş yap
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      _user = userCredential.user;

      print('Google ile giriş başarılı: ${_user?.email}');
    } catch (e) {
      String errorMessage = 'Bilinmeyen bir hata oluştu.';
      if (e is FirebaseException) {
        errorMessage = e.message ?? errorMessage;
      } else if (e is Exception) {
        errorMessage = e.toString();
      }
      print('Google ile giriş hatası: $errorMessage');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Giriş yapılırken bir hata oluştu: $errorMessage'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleSignOut() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      _user = null;
    } catch (e) {
      print('Çıkış hatası: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Çıkış yapılırken bir hata oluştu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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
          icon: Icon(Icons.search, color: Colors.blue.shade900),
          onPressed: () {
            // Arama sayfasına yönlendirme işlemi buraya gelecek
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Colors.black12,
            height: 1.0,
          ),
        ),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  // Popüler butonuna tıklandığında yapılacak işlemler
                },
                child: Container(
                  width: 110,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Popüler',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.favorite,
                          color: Colors.blue.shade900, size: 16),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12),
              InkWell(
                onTap: () {
                  // En Son butonuna tıklandığında yapılacak işlemler
                },
                child: Container(
                  width: 110,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'En Son',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.access_time,
                          color: Colors.blue.shade900, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.blue.shade900),
              onPressed: () async {
                await _checkUser();
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              GestureDetector(
                onTap: _user == null && !_isLoading
                    ? _handleGoogleSignIn
                    : () async {
                        await Navigation.goToProfil(context);
                      },
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                  ),
                  accountName: Text(
                    _user?.displayName ?? 'Misafir',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: Text(_user?.email ?? 'Giriş yapmadınız'),
                  currentAccountPicture: _user?.photoURL != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(_user!.photoURL!),
                          backgroundColor: Colors.white,
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.white,
                          child:
                              Icon(Icons.person, color: Colors.blue.shade900),
                        ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home, color: Colors.blue.shade900),
                title: Text('Ana Sayfa'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.favorite, color: Colors.blue.shade900),
                title: Text('Beğendiğim Kitaplar'),
                onTap: () {
                  Navigation.closeDrawer(context);
                  Navigation.goToBegendigimKitaplar(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.download, color: Colors.blue.shade900),
                title: Text('İndirilen Kitaplar'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const IndirilenKitaplar()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.blue.shade900),
                title: Text('Ayarlar'),
                onTap: () {
                  // Ayarlar sayfası yönlendirmesi
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.info, color: Colors.blue.shade900),
                title: Text('Hakkında'),
                onTap: () {
                  // Hakkında sayfası yönlendirmesi
                },
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hoş Geldiniz',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
