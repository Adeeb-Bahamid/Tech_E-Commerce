import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tech_e_commerce/main_code/shared/services/firebase_helper.dart';
import 'package:tech_e_commerce/main_code/shared/services/images_services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;
  final ImagesServices _imagesServices = ImagesServices();
  final FirebaseHelper _firebaseHelper = FirebaseHelper();
  Map? image;
  String? imageProfile;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser!;
    ColorScheme color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: color.primary)),
        centerTitle: true,
        backgroundColor: color.onPrimary,
        foregroundColor: color.primary,
        elevation: 0,
      ),
      body: FutureBuilder(
          future: _firebaseHelper.getCollectionUser(
              collection: 'Users', uid: user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError ||
                !snapshot.hasData ||
                !snapshot.data!.exists) {
              return const Center(
                child: Text('Something Worng'),
              );
            }

            var userData = snapshot.data!.data() as Map<String, dynamic>;

            if (!isEditing) {
              if (userData['imageProfile'] != null) {
                image = {'public_id': userData['imageProfile']};
              }
              _nameController.text = userData['username'];
              _emailController.text = userData['email'];
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 90,
                          backgroundImage: image == null
                              ? const AssetImage(
                                  'assets/images/profile.jpg',
                                )
                              : NetworkImage(
                                  _imagesServices.image(image!['public_id'])),
                        ),
                      ),
                      Positioned(
                        bottom: -20,
                        left: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () async {
                            var pickedImage =
                                await _imagesServices.uploadImage();
                            if (pickedImage != null) {
                              setState(() {
                                image = pickedImage;
                                // isSelectImage = true;
                              });
                            }
                            if (image != null) {
                              _firebaseHelper.updateCollection(
                                  collection: 'Users',
                                  data: {'imageProfile': image!['public_id']},
                                  id: user.uid);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color.secondary,
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _nameController.text,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _emailController.text,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding:
                        isEditing ? const EdgeInsets.all(16) : EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: color.onPrimary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: isEditing
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.person_outline,
                                  color: color.secondary,
                                ),
                                title: const Text('Edit Profile'),
                                trailing: const Icon(Icons.keyboard_arrow_down,
                                    size: 16),
                                onTap: () {
                                  setState(() => isEditing = !isEditing);
                                },
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Your Name',
                                style: TextStyle(fontSize: 16),
                              ),
                              TextField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                    hintText: 'Your Name'),
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                'Email',
                                style: TextStyle(fontSize: 16),
                              ),
                              TextField(
                                controller: _emailController,
                                enabled: false,
                                decoration:
                                    const InputDecoration(hintText: 'Email'),
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                'Password',
                                style: TextStyle(fontSize: 16),
                              ),
                              TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                      hintText: 'Password')),
                              const SizedBox(height: 20),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      await user.updateDisplayName(
                                          _nameController.text);
                                      await _firebaseHelper.updateCollection(
                                        collection: 'Users',
                                        data: {
                                          'username': _nameController.text,
                                        },
                                        id: user.uid,
                                      );
                                      if (_passwordController.text.isNotEmpty) {
                                        if (_passwordController.text.length <
                                            6) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .clearSnackBars();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  backgroundColor: color.error,
                                                  content: Text(
                                                    'The password must be at least 6 letters',
                                                    style: TextStyle(
                                                        color: color.onError),
                                                  )),
                                            );
                                          }
                                          return;
                                        }

                                        await user.updatePassword(
                                            _passwordController.text);
                                      }

                                      setState(() => isEditing = false);
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .clearSnackBars();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              backgroundColor: color.secondary,
                                              content: Text(
                                                  'تم تحديث البيانات بنجاح',
                                                  style: TextStyle(
                                                      color:
                                                          color.onSecondary))),
                                        );
                                      }
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'requires-recent-login') {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                backgroundColor: color.error,
                                                content: Text(
                                                  'You must re-login to change the password for your account security',
                                                  style: TextStyle(
                                                      color: color.onError),
                                                )),
                                          );
                                        }
                                      } else {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                backgroundColor: color.error,
                                                content: const Text(
                                                    'Something wrong')),
                                          );
                                        }
                                      }
                                    } catch (_) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              backgroundColor: color.error,
                                              content: const Text(
                                                  'Something wrong')),
                                        );
                                      }
                                    }

                                    setState(() => isEditing = false);
                                  },
                                  child: const Text('Save Changes'),
                                ),
                              )
                            ],
                          )
                        : Column(
                            children: [
                              ListTile(
                                leading: Icon(Icons.person_outline,
                                    color: color.secondary),
                                title: const Text('Edit Profile'),
                                trailing: const Icon(Icons.arrow_forward_ios,
                                    size: 16),
                                onTap: () {
                                  setState(() => isEditing = true);
                                },
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {
                      _firebaseHelper.signOutApp();
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFFFEBEE), // لون خلفية الزر
                      foregroundColor: color.error, // لون النص والأيقونة
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
