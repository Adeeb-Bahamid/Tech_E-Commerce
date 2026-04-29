import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreenCustomer extends StatelessWidget {
  const HomeScreenCustomer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
          onPressed: () async {
            GoogleSignIn googleSignIn = GoogleSignIn();
            await googleSignIn.signOut();
            await FirebaseAuth.instance.signOut();
          },
          icon: const Icon(Icons.logout)),
    );
  }
}
