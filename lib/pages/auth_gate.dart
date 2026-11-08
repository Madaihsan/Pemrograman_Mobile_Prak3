import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Tampilkan indikator loading saat memeriksa status autentikasi
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Jika user sudah login, arahkan ke HomePage
        if (snapshot.hasData) {
          return const HomePage();
        }

        // Jika user belum login, arahkan ke LoginPage
        return const LoginPage();
      },
    );
  }
}

