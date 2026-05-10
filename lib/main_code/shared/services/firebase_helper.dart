import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseHelper {
  Future<void> signOutWeb() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> signOutApp() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
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
      {required String collection, required Map<String, dynamic> data}) async {
    await fireStore.collection(collection).doc(data['id']).set(data);
  }

  Future<void> updateCollection(
      {required String collection,
      required Map<String, dynamic> data,
      required String id}) async {
    await fireStore.collection(collection).doc(id).update(data);
  }

  Query<Map<String, dynamic>> getCollection(
      {required String collection, String? selectedCategory}) {
    if (selectedCategory == 'All' || selectedCategory == null) {
      return fireStore.collection(collection);
    }
    return fireStore
        .collection(collection)
        .where('category', isEqualTo: selectedCategory);
  }

  void deletedDoc({required String collection, required String id}) {
    fireStore.collection(collection).doc(id).delete();
  }

  Future<String> getNextOrderID() async {
    final docRef = fireStore.collection('counters').doc('orders');

    return fireStore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      int lastId = 0;
      if (snapshot.exists) {
        lastId = snapshot['lastId'];
      }
      int newId = lastId + 1;
      transaction.set(docRef, {'lastId': newId});
      return '#${newId.toString().padLeft(4, '0')}';
    });
  }

  Future<void> addToCart({
    required String userId,
    required String productId,
    required String name,
    required double price,
    String? publicId,
  }) async {
    final docRef = fireStore.collection('Carts').doc(userId);

    final doc = await docRef.get();

    Map<String, dynamic> items = {};

    if (doc.exists && doc.data()!.containsKey('items')) {
      items = Map<String, dynamic>.from(doc['items']);
    }

    if (items.containsKey(productId)) {
      items[productId]['quantity'] += 1;
    } else {
      items[productId] = {
        "name": name,
        "price": price,
        "quantity": 1,
        "publicId": publicId,
      };
    }

    await docRef.set({
      "items": items,
    });
  }

  //>>>>>>>>>>>>>>>>>>>>> cart functoin <<<<<<<<<<<<<<<<<<<<<<<<<<<<
  // >>>>>>>>>>>>>>>>>>>>> updata Cart <<<<<<<<<<<<<<<<<<<<<<<
  Future<void> updateQuantity(
      String productId, int newQuantity, String userId) async {
    final docRef = fireStore.collection('Carts').doc(userId);

    final doc = await docRef.get();

    if (!doc.exists) return;

    Map<String, dynamic> items = Map<String, dynamic>.from(doc['items']);

    if (!items.containsKey(productId)) return;

    if (newQuantity > 0) {
      items[productId]['quantity'] = newQuantity;
    } else {
      items.remove(productId);
    }

    await docRef.update({"items": items});
  }

  // >>>>>>>>>>>>>>>>>>>> removeItem of Cart <<<<<<<<<<<<<<<<<<<<<<<<<<<<
  Future<void> removeItem(String productId, String userId) async {
    final docRef = fireStore.collection('Carts').doc(userId);

    final doc = await docRef.get();

    if (!doc.exists) return;

    Map<String, dynamic> items = Map<String, dynamic>.from(doc['items']);

    items.remove(productId);

    await docRef.update({"items": items});
  }
}
