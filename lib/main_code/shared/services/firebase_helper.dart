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

  Future<DocumentSnapshot<Map<String, dynamic>>> getCollectionDoc(
      {required String collection, required String id}) async {
    return await fireStore.collection(collection).doc(id).get();
  }

  Future<void> setCollection(
      {required String collection,
      required Map<String, dynamic> product}) async {
    await fireStore.collection(collection).doc(product['id']).set(product);
  }

  Future<void> updateCollection(
      {required String collection,
      required Map<String, dynamic> product,
      required String id}) async {
    await fireStore.collection(collection).doc(id).update(product);
  }

  Query<Map<String, dynamic>> getCollection(
      {required String collection, String? selectedCategory}) {
    if (selectedCategory == 'All' || selectedCategory == null) {
      return FirebaseFirestore.instance.collection(collection);
    }
    return fireStore
        .collection(collection)
        .where('category', isEqualTo: selectedCategory);
  }

  void deletedDoc({required String collection, required String id}) {
    FirebaseFirestore.instance.collection(collection).doc(id).delete();
  }
}
