import 'package:flutter/material.dart';
import 'package:tech_e_commerce/main_code/admin/dashboard.dart';
import 'package:tech_e_commerce/main_code/admin/orders.dart';
import 'package:tech_e_commerce/main_code/admin/products.dart';
import '../shared/services/firebase_helper.dart';

class HomeScreenAdmin extends StatefulWidget {
  const HomeScreenAdmin({super.key});

  @override
  State<HomeScreenAdmin> createState() => _HomeScreenAdminState();
}

class _HomeScreenAdminState extends State<HomeScreenAdmin> {
  String selectedMenu = 'Dashboard';
  List<Widget> pages = [
    const Dashboard(),
    const Products(
      title: 'Products',
      subTitle: 'Manage your store products',
    ),
    const Orders(
      title: 'Orders',
      subTitle: 'Manage customer requests',
    ),
  ];
  final FirebaseHelper _firebaseHelper = FirebaseHelper();
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: [
          // >>>>>>>>>>>>>>>>(Sidebar)<<<<<<<<<<<<<<<<<<<<<<<<
          Container(
            width: 250,
            color: color.surface,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // >>>>>>>>>>>>>>>>Header Admin<<<<<<<<<<<<<<
                Row(
                  children: [
                    Image.asset(
                      'assets/images/tech_store.png',
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Admin Panel',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: color.onPrimary),
                        ),
                        Text(
                          'Tech Store',
                          style: TextStyle(
                            fontSize: 12,
                            color: color.onPrimary.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 50),

                // >>>>>>>>>>>>>>>>>>>>>MenuItem<<<<<<<<<<<<<<<
                _buildMenuItem(context, Icons.grid_view_rounded, 'Dashboard',
                    index: 0),
                const SizedBox(height: 10),
                _buildMenuItem(context, Icons.shopping_bag_rounded, 'Products',
                    index: 1),
                const SizedBox(height: 10),
                _buildMenuItem(context, Icons.shopping_cart_rounded, 'Orders',
                    index: 2),

                const Spacer(),

                _buildMenuItem(context, Icons.logout_rounded, 'Logout',
                    isSelected: false),
              ],
            ),
          ),

          Expanded(child: pages[selectedIndex]),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title,
      {int index = 0, bool isSelected = false}) {
    ColorScheme color = Theme.of(context).colorScheme;

    final effectiveIsSelected = selectedMenu == title;
    return GestureDetector(
      onTap: title == 'Logout'
          ? _firebaseHelper.signOutWeb
          : () {
              setState(() {
                selectedIndex = index;
                selectedMenu = title;
              });
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: effectiveIsSelected
              ? color.primary.withOpacity(0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: effectiveIsSelected
                    ? color.primary
                    : color.onPrimary.withOpacity(0.5),
                size: 20),
            const SizedBox(width: 15),
            Text(title,
                style: TextStyle(
                    color: effectiveIsSelected
                        ? color.onPrimary
                        : color.onPrimary.withOpacity(0.5),
                    fontWeight: effectiveIsSelected
                        ? FontWeight.w600
                        : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}
