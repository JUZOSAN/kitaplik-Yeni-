import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BegendigimKitaplar extends StatefulWidget {
  const BegendigimKitaplar({super.key});

  @override
  State<BegendigimKitaplar> createState() => _BegendigimKitaplarState();
}

class _BegendigimKitaplarState extends State<BegendigimKitaplar> {
  List<Map<String, String>> begendigimKitaplar = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadKitaplar();
    _user = _auth.currentUser;
  }

  // Kitapları yükle
  Future<void> _loadKitaplar() async {
    final prefs = await SharedPreferences.getInstance();
    final kitaplarJson = prefs.getString('begendigimKitaplar');
    if (kitaplarJson != null) {
      setState(() {
        begendigimKitaplar = List<Map<String, String>>.from(
            json.decode(kitaplarJson).map((x) => Map<String, String>.from(x)));
      });
    }
  }

  // Kitapları kaydet
  Future<void> _saveKitaplar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'begendigimKitaplar', json.encode(begendigimKitaplar));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigation.closeDrawer(context);
                  Navigation.goToProfil(context);
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
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: _user?.photoURL != null
                        ? NetworkImage(_user!.photoURL!)
                        : null,
                    child: _user?.photoURL == null
                        ? Icon(Icons.person, color: Colors.blue.shade900)
                        : null,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home, color: Colors.blue.shade900),
                title: Text('Ana Sayfa'),
                onTap: () {
                  Navigation.closeDrawer(context);
                  Navigation.goToHome(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.favorite, color: Colors.blue.shade900),
                title: Text('Beğendiğim Kitaplar'),
                onTap: () {
                  Navigation.closeDrawer(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.download, color: Colors.blue.shade900),
                title: Text('İndirilen Kitaplar'),
                onTap: () {
                  Navigation.closeDrawer(context);
                  Navigation.goToIndirilenKitaplar(context);
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: Text(
          'Beğendiğim Kitaplar',
          style: TextStyle(color: Colors.blue.shade900),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.blue.shade900),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      body: begendigimKitaplar.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.blue.shade200,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Henüz beğendiğiniz kitap yok',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Kitapları beğenmek için kalp ikonuna tıklayın',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: begendigimKitaplar.length,
              itemBuilder: (context, index) {
                final kitap = begendigimKitaplar[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.book,
                          color: Colors.blue.shade900,
                          size: 30,
                        ),
                      ),
                    ),
                    title: Text(
                      kitap['name'] ?? 'Kitap Adı',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    subtitle: Text(kitap['author'] ?? 'Yazar Adı'),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        setState(() {
                          begendigimKitaplar.removeAt(index);
                        });
                        await _saveKitaplar();
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
