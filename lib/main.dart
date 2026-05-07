import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tech_e_commerce/main_code/customer/home_screen_customer.dart';
import 'package:tech_e_commerce/main_code/shared/services/firebase_helper.dart';
import 'main_code/admin/home_screen_admin.dart';
import 'main_code/admin/products.dart';
import 'main_code/shared/theme/app_theme.dart';
import 'firebase_options.dart';
import 'main_code/admin/dashboard.dart';
import 'main_code/customer/home_screen_customer.dart';
import 'main_code/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.darkTheme,
      home: const AuthGet(),
    );
  }
}

class AuthGet extends StatefulWidget {
  const AuthGet({super.key});

  @override
  State<AuthGet> createState() => _AuthGetState();
}

class _AuthGetState extends State<AuthGet> {
  final FirebaseHelper _firebaseHelper = FirebaseHelper();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // body: HomeScreenCustomer(),
        // body: HomeScreenAdmin(),
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, authSnapshot) {
            if (authSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (authSnapshot.hasError) {
              return const Center(
                  child: Text('An error occurred, please try again.'));
            }

            if (authSnapshot.hasData && authSnapshot.data != null) {
              final uid = authSnapshot.data!.uid;
              return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: _firebaseHelper.getCollectionUser(
                    collection: 'Users', uid: uid),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (userSnapshot.hasData && userSnapshot.data!.exists) {
                    final data = userSnapshot.data!.data();
                    final role = data?['role'];
                    if (role == 'admin') {
                      return const HomeScreenAdmin();
                    } else {
                      return const HomeScreenCustomer();
                    }
                  }
                  return const LoginPage();
                },
              );
            }

            return const LoginPage();
          },
        ),
      ),
    );
  }
}
