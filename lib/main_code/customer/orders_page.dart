import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../shared/models/order_model.dart';

class OrdersPage extends StatelessWidget {
  // final String currentUserId; // مرر الـ ID الخاص بالمستخدم هنا

  const OrdersPage({super.key});

  String get currentUserId => FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;
    return Scaffold(
      // backgroundColor: const Color(0xFFF8FAF8),
      // appBar: AppBar(
      //   title: const Text("ShopGreen",
      //       style: TextStyle(
      //           color: Color(0xFF1B5E20), fontWeight: FontWeight.bold)),
      //   centerTitle: true,
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      //   leading: const Icon(Icons.menu, color: Color(0xFF1B5E20)),
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  "My Orders",
                  style: TextStyle(
                      color: color.primary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .where('userId', isEqualTo: currentUserId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("لا توجد طلبات حالياً"));
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final order = OrderModel.fromMap(
                        docs[index].data() as Map<String, dynamic>,
                        // docs[index].id,
                      );
                      return OrderCard(order: order);
                    },
                  );
                },
              ),
              // child: StreamBuilder<DocumentSnapshot>(
              //   stream: FirebaseFirestore.instance
              //       .collection('orders') // الكولكشن الصحيح
              //       .doc(currentUserId) // الـ ID الخاص بالمستخدم
              //       .snapshots(),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const Center(child: CircularProgressIndicator());
              //     }

              //     if (!snapshot.hasData || !snapshot.data!.exists) {
              //       return const Center(
              //           child: Text("لا يوجد طلبات نشطة حالياً"));
              //     }

              //     final data = snapshot.data!.data() as Map<String, dynamic>;
              //     final order = OrderModel.fromMap(data);

              //     // عرض الطلب داخل ListView ليناسب شكل الواجهة المطلوبة
              //     return ListView(
              //       padding: const EdgeInsets.all(16),
              //       children: [
              //         OrderCard(order: order),
              //       ],
              //     );
              //   },
              // ),
              // child: StreamBuilder(
              //   // تأكد من أن اسم الكولكشن 'Carts' ومصفى حسب الـ userId
              //   stream: FirebaseFirestore.instance
              //       .collection('Carts')
              //       .doc(currentUserId)
              //       .snapshots(),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const Center(child: CircularProgressIndicator());
              //     }

              //     if (!snapshot.hasData || !snapshot.data!.exists) {
              //       return const Center(child: Text("لا توجد طلبات حالياً"));
              //     }

              //     // الحصول على البيانات من الدوكيومنت
              //     final data = snapshot.data!.data() as Map<String, dynamic>;

              //     // تحويل البيانات باستخدام المودل
              //     final order = OrderModel.fromMap(data, snapshot.data!.id);

              //     // بما أنه مستند واحد (طلب واحد أو قائمة واحدة)، سنعرضها مباشرة
              //     // أو نضعها في ListView إذا كنت تريد الاحتفاظ بنفس التنسيق
              //     return ListView(
              //       children: [
              //         OrderCard(order: order),
              //       ],
              //     );
              //   },
              // builder: (context, snapshot) {
              //   if (snapshot.connectionState == ConnectionState.waiting) {
              //     return const Center(child: CircularProgressIndicator());
              //   }
              //   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              //     return const Center(child: Text("لا توجد طلبات حالياً"));
              //   }

              //   final docs = snapshot.data!.docs;

              //   return ListView.builder(
              //     itemCount: docs.length,
              //     itemBuilder: (context, index) {
              //       final order = OrderModel.fromMap(
              //         docs[index].data() as Map<String, dynamic>,
              //         docs[index].id,
              //       );
              //       return OrderCard(order: order);
              //     },
              //   );
              // },
              // ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final OrderModel order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Card(
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.primary.withOpacity(0.06),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(order.id.substring(0, 5),
                      style: const TextStyle(color: Colors.grey)),
                  Text(order.createdAt,
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
              const Divider(height: 25, thickness: 0.5),
              ...order.cartItems.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item['name'] ?? '',
                          style:
                              TextStyle(fontSize: 16, color: color.onSurface),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text("x${item['quantity']}",
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statusWidget(order.status, color),
                  Text(
                    "\$${order.total.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: order.status == 'Cancelled'
                          ? color.onSurface.withOpacity(0.5)
                          : color.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusWidget(String status, ColorScheme color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: status == "Pending"
            ? Colors.amber.withOpacity(0.2)
            : status == "Accepted"
                ? color.secondary.withOpacity(0.1)
                : color.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          status == "Pending"
              ? Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                      color: Colors.amber, shape: BoxShape.circle),
                )
              : const SizedBox.shrink(),
          const SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
                color: status == "Pending"
                    ? Colors.amber
                    : status == "Accepted"
                        ? color.secondary
                        : color.error,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
