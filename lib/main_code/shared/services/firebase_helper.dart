import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseHelper {
  Future<void> signOutWeb() async {
    // GoogleSignIn googleSignIn = GoogleSignIn();
    // await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }

  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  Future<DocumentSnapshot<Map<String, dynamic>>> getCollectionUser(
      {required String collection, required String uid}) async {
    return await fireStore.collection(collection).doc(uid).get();
  }

  Future<void> setProduct(
      {required String collection,
      required Map<String, dynamic> product}) async {
    await fireStore.collection(collection).doc(product['id']).set(product);
  }

  Query<Map<String, dynamic>> getCollection(
      {required String collection, String? selectedCategory})  {
    if (selectedCategory == 'All' || selectedCategory == null) {
      return  FirebaseFirestore.instance.collection(collection);
    }
    return  fireStore
        .collection(collection)
        .where('category', isEqualTo: selectedCategory);
  }
}
