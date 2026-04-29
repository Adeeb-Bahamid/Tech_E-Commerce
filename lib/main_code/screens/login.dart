import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    setState(() {
      _isLoading = true;
    });
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userCredential.user!.uid)
            .set({
          'username': userCredential.user!.displayName,
          'role': 'customer',
          'email': userCredential.user!.email
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: const Text("Success! Welcome back."),
                backgroundColor: Theme.of(context).colorScheme.secondary),
          );
        }
      }
    } on FirebaseException catch (e) {
      setState(() {
        _isLoading = false;
      });
      switch (e.code) {
        case 'account-exists-with-different-credential':
          _showErrorSnackbar('Account registered in another way.');
        case 'invalid-credential':
          _showErrorSnackbar('Incorrect login data.');
        default:
          _showErrorSnackbar('An unexpected error occurred.');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackbar('Check out the internet connection.');
    }
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      try {
        if (_isLogin) {
          await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
        } else {
          final userCredential = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          await FirebaseFirestore.instance
              .collection('Users')
              .doc(userCredential.user!.uid)
              .set({'username': name, 'role': 'customer', 'email': email});
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: const Text("Success! Welcome back."),
                backgroundColor: Theme.of(context).colorScheme.secondary),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = "An error occurred, please try again.";

        if (e.code == 'user-not-found') {
          errorMessage = "No user found for that email.";
        } else if (e.code == 'wrong-password') {
          errorMessage = "Wrong password provided.";
        } else if (e.code == 'invalid-email') {
          errorMessage = "The email address is badly formatted.";
        } else if (e.code == 'user-disabled') {
          errorMessage = "This user account has been disabled.";
        } else if (e.code == 'too-many-requests') {
          errorMessage = "Too many failed attempts. Try again later.";
        }

        _showErrorSnackbar(errorMessage);
      } catch (e) {
        _showErrorSnackbar("Connection error");
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 600;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWeb ? 450 : double.infinity,
                ),
                child: Container(
                  padding: EdgeInsets.all(isWeb ? 40.0 : 24.0),
                  decoration: BoxDecoration(
                    color: color.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white10),
                    boxShadow: isWeb
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            )
                          ]
                        : [],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- >>>>>>>>>>>>>>>> (Logo) <<<<<<<<<<<<<<< ---
                        Center(
                          child: Image.asset('assets/images/tech_store.png'),
                        ),
                        const SizedBox(height: 24),

                        // --- (Header) ---
                        Center(
                          child: Text(
                            _isLogin ? "Welcome Back!" : "Create Account",
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: color.onSurface),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            _isLogin
                                ? "We Missed You"
                                : "Join Us! We Can'n Wait To See You",
                            style: TextStyle(
                                color: color.onSurface.withOpacity(0.5),
                                fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // --- >>>>>>>>>>>>>>> (Full Name) <<<<<<<<<<<<<< ---
                        _isLogin
                            ? const SizedBox.shrink()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Full Name",
                                    style: TextStyle(
                                        color: color.onSurface.withOpacity(0.7),
                                        fontSize: 14),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildTextFormField(
                                    controller: _nameController,
                                    hint: "Your Name",
                                    icon: Icons.person,
                                    keyboardType: TextInputType.name,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),

                        const SizedBox(height: 20),

                        // --- >>>>>>>>>>>>>>> (Email Address) <<<<<<<<<<<<<< ---
                        Text(
                          "Email Address",
                          style: TextStyle(
                              color: color.onSurface.withOpacity(0.7),
                              fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        _buildTextFormField(
                          controller: _emailController,
                          hint: "name@example.com",
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || !value.contains('@')) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // --- >>>>>>>>>>>>>>>>> (Password) <<<<<<<<<<<<<<<<< ---
                        Text(
                          "Password",
                          style: TextStyle(
                              color: color.onSurface.withOpacity(0.7),
                              fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        _buildTextFormField(
                          controller: _passwordController,
                          hint: "••••••••",
                          icon: Icons.lock,
                          isPassword: true,
                          suffixIcon: Icons.visibility_off,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Enter a valid password';
                            }
                            if (value.trim().length < 6) {
                              return 'Enter a password longer than six letters';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 32),

                        // --- >>>>>>>>>>>>>>>>>>>>> (ElevatedButton Sign In)<<<<<<<<<<<<<<<<< ---
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: _isLoading ? null : _handleLogin,
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          _isLogin
                                              ? "Sign In"
                                              : "Create Account",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: color.onPrimary)),
                                      const SizedBox(width: 10),
                                      Icon(Icons.arrow_forward_rounded,
                                          size: 20, color: color.onPrimary),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // --- >>>>>>>>>>>>>>>>>>>>> (ElevatedButton Sign In with google)<<<<<<<<<<<<<<<<< ---
                        _isLogin && !kIsWeb
                            ? SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        color.primary.withOpacity(0.2),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                  onPressed: signInWithGoogle,
                                  child: _isLoading
                                      ? const CircularProgressIndicator()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              width: 20,
                                              height: 20,
                                              'assets/images/google.png',
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              'Continue with Google',
                                              style: TextStyle(
                                                  color: color.onSurface),
                                            ),
                                          ],
                                        ),
                                ),
                              )
                            : const SizedBox.shrink(),

                        const SizedBox(height: 32),

                        // --- >>>>>>>>>>>>>>>> (Divider) <<<<<<<<<<<<<<<<<<<<<<<< ---
                        Row(
                          children: [
                            const Expanded(
                                child: Divider(
                                    color: Colors.white10, thickness: 1)),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text("OR",
                                  style: TextStyle(
                                      color: color.onSurface.withOpacity(0.3),
                                      fontSize: 12)),
                            ),
                            const Expanded(
                                child: Divider(
                                    color: Colors.white10, thickness: 1)),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // --- >>>>>>>>>>>>>>>>>>>>> (Create Account) <<<<<<<<<<<<<<<<<<<< ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                _isLogin
                                    ? "Don't have an account?"
                                    : "Already have an account?",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(
                                _isLogin ? "Create Account" : "Sign In",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: color.secondary,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // --- >>>>>>>>>>>>>>>>> (Footer) <<<<<<<<<<<<<<<<<<<<<<< ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline,
                      color: Colors.white.withOpacity(0.2), size: 14),
                  const SizedBox(width: 6),
                  Text(
                    "SECURE ACCESS SYSTEM",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.2),
                        fontSize: 11,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    IconData? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    ColorScheme color = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      style: TextStyle(color: color.onSurface),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            TextStyle(color: color.onSurface.withOpacity(0.5), fontSize: 14),
        prefixIcon:
            Icon(icon, color: color.onSurface.withOpacity(0.7), size: 20),
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon,
                color: color.onSurface.withOpacity(0.7), size: 20)
            : null,
        filled: true,
        fillColor: color.onError.withOpacity(0.2),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color.error, width: 1.5),
        ),
      ),
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
    );
  }
}
