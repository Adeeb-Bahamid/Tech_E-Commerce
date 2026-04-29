import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  Future<DocumentSnapshot<Map<String, dynamic>>> getCollectionUser(
      {required String collection, required String uid}) {
    return fireStore.collection(collection).doc(uid).get();
  }
}
