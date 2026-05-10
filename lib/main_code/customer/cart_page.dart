import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tech_e_commerce/main_code/shared/models/order_model.dart';
import 'package:tech_e_commerce/main_code/shared/services/firebase_helper.dart';
import 'package:tech_e_commerce/main_code/shared/services/images_services.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirebaseHelper _firebaseHelper = FirebaseHelper();
  final ImagesServices _imagesServices = ImagesServices();
  double subtotal = 0, total = 0;
  double delivery = 15;

  User? get user => FirebaseAuth.instance.currentUser;

  void calculatePrices(List<Map<String, dynamic>> cartItems) {
    subtotal = 0;

    for (var item in cartItems) {
      double price = (item['price'] ?? 0).toDouble();
      int qty = (item['quantity'] ?? 0);
      subtotal += price * qty;
    }

    total = subtotal + delivery;
  }

  Future<void> confirmOrder(List<Map<String, dynamic>> cartItems) async {
    for (var item in cartItems) {
      final productId = item['productId'];
      final orderedQty = item['quantity'];

      final productRef =
          FirebaseFirestore.instance.collection('Product').doc(productId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(productRef);
        if (!snapshot.exists) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.redAccent, content: Text('Product')));
        }

        final currentQty = snapshot['quantity'];
        if (currentQty < orderedQty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.redAccent, content: Text('Product')));
        }
        transaction.update(productRef, {'quantity': currentQty - orderedQty});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart', style: TextStyle(color: color.primary)),
        elevation: 0,
        centerTitle: true,
        backgroundColor: color.onPrimary,
        foregroundColor: color.primary,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Carts')
                  .doc(user!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart, size: 50),
                      Text("Cart is empty"),
                    ],
                  ));
                }

                final data = snapshot.data!.data() as Map<String, dynamic>?;

                if (data == null || !data.containsKey('items')) {
                  return const Center(
                      child: Column(
                    children: [
                      Icon(Icons.shopping_cart, size: 50),
                      Text("Cart is empty"),
                    ],
                  ));
                }

                Map<String, dynamic> items =
                    Map<String, dynamic>.from(data['items']);

                final List<Map<String, dynamic>> cartItems =
                    items.entries.map((e) {
                  return {
                    "productId": e.key,
                    ...Map<String, dynamic>.from(e.value),
                  };
                }).toList();

                calculatePrices(cartItems);

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(15),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          var item = cartItems[index];
                          int qty = item['quantity'] ?? 1;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: color.surface,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    color: color.onSurface.withOpacity(0.4),
                                    child: Image.network(
                                      _imagesServices.image(item['publicId'])
                                        ,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(item['name'] ?? '',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: color.onSurface,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16)),
                                          ),
                                          const SizedBox(width: 5),
                                          GestureDetector(
                                            onTap: () =>
                                                _firebaseHelper.removeItem(
                                                    item['productId'],
                                                    user!.uid),
                                            child: Icon(Icons.delete_outline,
                                                color: color.error
                                                    .withOpacity(0.7),
                                                size: 30),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Text("\$${item['price']}",
                                          style: TextStyle(
                                              color: color.primary,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          _qtyBtn(
                                              Icons.remove,
                                              () => _firebaseHelper
                                                  .updateQuantity(
                                                      item['productId'],
                                                      qty - 1,
                                                      user!.uid)),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Text("$qty",
                                                style: TextStyle(
                                                    color: color.onSurface,
                                                    fontSize: 16)),
                                          ),
                                          _qtyBtn(
                                              Icons.add,
                                              () => _firebaseHelper
                                                  .updateQuantity(
                                                      item['productId'],
                                                      qty + 1,
                                                      user!.uid)),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    _buildCheckoutSection(cartItems),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    ColorScheme color = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: icon == Icons.add ? color.secondary : color.error,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
        ),
        child: Icon(icon, color: color.onPrimary, size: 16),
      ),
    );
  }

  Widget _buildCheckoutSection(List<Map<String, dynamic>> cartItems) {
    ColorScheme color = Theme.of(context).colorScheme;
    return Card(
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            _rowPrice("Subtotal", "$subtotal"),
            const SizedBox(height: 10),
            _rowPrice("Delivery Fee", "$delivery"),
            Divider(color: color.onSurface.withOpacity(0.3), height: 30),
            _rowPrice("Total", "$total", isTotal: true),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              // height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  final orderId = await _firebaseHelper.getNextOrderID();
                  final OrderModel orderModel = OrderModel(
                    id: orderId,
                    customerName: user!.displayName!,
                    userId: user!.uid,
                    cartItems: cartItems,
                    total: total,
                    status: 'Pending',
                    createdAt: FieldValue.serverTimestamp(),
                  );

                  _firebaseHelper.setCollection(
                      collection: 'orders', data: orderModel.toMap());

                  confirmOrder(cartItems);

                  _firebaseHelper.deletedDoc(
                      collection: 'Carts', id: user!.uid);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: color.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: Text("Confirm Order",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color.onPrimary)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowPrice(String label, String value, {bool isTotal = false}) {
    ColorScheme color = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                color: isTotal
                    ? color.onSurface
                    : color.onSurface.withOpacity(0.5),
                fontSize: isTotal ? 18 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        Text('\$$value',
            style: TextStyle(
                color: isTotal ? color.primary : color.onSurface,
                fontSize: isTotal ? 20 : 16,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}

