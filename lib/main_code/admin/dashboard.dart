import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../shared/services/firebase_helper.dart';

class Dashboard extends StatefulWidget {
  final String title;
  final String subTitle;
  const Dashboard({super.key, required this.title, required this.subTitle});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // ================= DYNAMIC DATA =================
  // لاحقاً تقدر تربطها مع API أو Firebase
  final FirebaseHelper _firebaseHelper = FirebaseHelper();
  int totalProducts = 0;
  int acceptedOrders = 0;
  int cancelledOrders = 0;

  @override
  void initState() {
    super.initState();

    getDashboardStats();
  }

  Future<void> getDashboardStats() async {
    final products =
        await FirebaseFirestore.instance.collection('Product').count().get();

    final accepted = await FirebaseFirestore.instance
        .collection('orders')
        .where('Status', isEqualTo: 'Accepted')
        .count()
        .get();

    final pending = await FirebaseFirestore.instance
        .collection('orders')
        .where('Status', isEqualTo: 'Cancelled')
        .count()
        .get();

    setState(() {
      totalProducts = products.count ?? 0;
      acceptedOrders = accepted.count ?? 0;
      cancelledOrders = pending.count ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color.primary,
                ),
              ),
              Text(
                widget.subTitle,
                style: TextStyle(
                  fontSize: 14,
                  color: color.primary.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              // ================= MAIN CONTENT =================

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ================= RESPONSIVE CARDS =================

                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: constraints.maxWidth > 1000
                            ? 3
                            : constraints.maxWidth > 500
                                ? 2
                                : 1,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1.8,
                        children: [
                          dashboardCard(
                            title: "TOTAL PRODUCTS",
                            value: totalProducts.toString(),
                            icon: Icons.inventory_2_outlined,
                            iconColor: color.primary,
                          ),
                          dashboardCard(
                            title: "ACCEPTED ORDERS",
                            value: acceptedOrders.toString(),
                            icon: Icons.check_circle_outline,
                            iconColor: color.secondary,
                          ),
                          dashboardCard(
                            title: "CANCELLED ORDERS",
                            value: cancelledOrders.toString(),
                            icon: Icons.cancel_outlined,
                            iconColor: color.error,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ================= DASHBOARD CARD =================

  Widget dashboardCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    ColorScheme color = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 30,
          ),
          const Spacer(),
          Text(
            title,
            style: TextStyle(
              color: color.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 46,
              fontWeight: FontWeight.bold,
              color: color.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  // ================= ACTION BUTTON =================

  Widget actionButton({
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 22,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

