import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tech_e_commerce/main_code/shared/models/order_model.dart';
import 'package:tech_e_commerce/main_code/shared/services/firebase_helper.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirebaseHelper _firebaseHelper = FirebaseHelper();
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
                                    color: color.onSecondary,
                                    child: Image.network(
                                      item['imageUrl'] ?? '',
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
                                                color: color.onSurface
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                color: isTotal ? Colors.white : Colors.grey,
                fontSize: isTotal ? 18 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        Text(value,
            style: TextStyle(
                color: isTotal ? const Color(0xFF7C69FF) : Colors.white,
                fontSize: isTotal ? 20 : 16,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}




// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:tech_e_commerce/main_code/shared/services/firebase_helper.dart';

// class CartPage extends StatefulWidget {
//    CartPage({super.key});

//   @override
//   State<CartPage> createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {



//   final FirebaseHelper _firebaseHelper = FirebaseHelper();

//   // دالة لتحديث الكمية في الفايربيس
//   Future<void> updateQuantity(String docId, int newQuantity) async {
//     if (newQuantity > 0) {
//       await FirebaseFirestore.instance.collection('Carts').doc(docId).update({
//         'quantity': newQuantity,
//       });
//     } else {
//       // إذا وصلت الكمية لصفر، يمكن حذف المنتج أو تركه حسب رغبتك
//       await FirebaseFirestore.instance.collection('Carts').doc(docId).delete();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       // backgroundColor: const Color(0xFF0F0F0F),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: const Icon(Icons.arrow_back_ios, color: Colors.white),
//         title: const Text('My Cart',
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           // قائمة المنتجات من الفايربيس
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _firebaseHelper.getCartItems();
//                   ,
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 var docs = snapshot.data!.docs;

//                 return ListView.builder(
//                   padding: const EdgeInsets.all(20),
//                   itemCount: docs.length,
//                   itemBuilder: (context, index) {
//                     var data = docs[index].data() as Map<String, dynamic>;

//                     print('=====================+++++++++++++++++++++++++++$data++++++++++++++++++++++++++======================================');
//                     String docId = docs[index].id;
//                     int qty = data['quantity'] ?? 1;

//                     return Container(
//                       margin: const EdgeInsets.only(bottom: 20),
//                       padding: const EdgeInsets.all(15),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF1E1E1E),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Row(
//                         children: [
//                           // صورة المنتج
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(15),
//                             child: Image.network(
//                               '${data['imageUrl']}',
//                               width: 80,
//                               height: 80,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           const SizedBox(width: 15),
//                           // تفاصيل المنتج
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(data['name'],
//                                         style: const TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 16)),
//                                     const Icon(Icons.delete_outline,
//                                         color: Colors.grey, size: 20),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 5),
//                                 Text("\$${data['price']}",
//                                     style: const TextStyle(
//                                         color: Color(0xFF7C69FF),
//                                         fontWeight: FontWeight.bold)),
//                                 const SizedBox(height: 10),
//                                 // أزرار الزيادة والنقصان
//                                 Row(
//                                   children: [
//                                     _qtyBtn(Icons.remove,
//                                         () => updateQuantity(docId, qty - 1)),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 15),
//                                       child: Text("$qty",
//                                           style: const TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 16)),
//                                     ),
//                                     _qtyBtn(Icons.add,
//                                         () => updateQuantity(docId, qty + 1)),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),

//           // قسم الحساب النهائي (Footer)
//           _buildCheckoutSection(),
//         ],
//       ),
//     );
//   }

//   // ويدجت زر الكمية
//   Widget _qtyBtn(IconData icon, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(5),
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           border: Border.all(color: Colors.grey.withOpacity(0.5)),
//         ),
//         child: Icon(icon, color: Colors.white, size: 16),
//       ),
//     );
//   }

//   // قسم الملخص وزر التأكيد
//   Widget _buildCheckoutSection() {
//     return Container(
//       padding: const EdgeInsets.all(25),
//       decoration: const BoxDecoration(
//         color: Color(0xFF1E1E1E),
//         borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//       ),
//       child: Column(
//         children: [
//           _rowPrice("Subtotal", "\$1,548.00"),
//           const SizedBox(height: 10),
//           _rowPrice("Delivery Fee", "\$15.00"),
//           const Divider(color: Colors.grey, height: 30),
//           _rowPrice("Total", "\$1,563.00", isTotal: true),
//           const SizedBox(height: 20),
//           SizedBox(
//             width: double.infinity,
//             height: 55,
//             child: ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF7C69FF),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15)),
//               ),
//               child: const Text("Confirm Order",
//                   style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _rowPrice(String label, String value, {bool isTotal = false}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(label,
//             style: TextStyle(
//                 color: isTotal ? Colors.white : Colors.grey,
//                 fontSize: isTotal ? 18 : 14,
//                 fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
//         Text(value,
//             style: TextStyle(
//                 color: isTotal ? const Color(0xFF7C69FF) : Colors.white,
//                 fontSize: isTotal ? 20 : 16,
//                 fontWeight: FontWeight.bold)),
//       ],
//     );
//   }
// }
