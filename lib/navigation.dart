import 'package:flutter/material.dart';
import 'main.dart';
import 'indirilen.dart';
import 'begendigim_kitaplar.dart';
import 'profil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Navigation {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    clientId:
        '794287189815-pvfmf21nqqgl3u9kjb1o1he5jg285j16.apps.googleusercontent.com',
  );
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static void goToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()),
      (route) => false,
    );
  }

  static void goToIndirilenKitaplar(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const IndirilenKitaplar()),
    );
  }

  static void goToBegendigimKitaplar(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BegendigimKitaplar()),
    );
  }

  static Future<void> goToProfil(BuildContext context) async {
    try {
      // Önce mevcut kullanıcıyı kontrol et
      final user = _auth.currentUser;
      if (user == null) {
        // Google hesabından çıkış yap
        await _googleSignIn.signOut();

        // Google hesabıyla giriş yap
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Giriş işlemi iptal edildi'),
                backgroundColor: Colors.orange,
              ),
            );
          }
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
        await _auth.signInWithCredential(credential);
      }

      // Profil sayfasına git
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilSayfasi()),
        );
      }
    } catch (e) {
      print('Google ile giriş hatası: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Giriş yapılırken bir hata oluştu: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  static void closeDrawer(BuildContext context) {
    Navigator.pop(context);
  }
}
