import 'package:flutter/material.dart';
import 'package:tech_e_commerce/main_code/customer/cart_page.dart';
import 'package:tech_e_commerce/main_code/customer/orders_page.dart';
import 'package:tech_e_commerce/main_code/customer/profile_page.dart';
import 'home_page.dart';

class HomeScreenCustomer extends StatefulWidget {
  const HomeScreenCustomer({super.key});

  @override
  State<HomeScreenCustomer> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenCustomer> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const CartPage(),
    const OrdersPage(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: _pages[_selectedIndex],
        ),
      ),

      // >>>>>>>>>>>>>>>>>>>>>>> (Bottom Navigation) <<<<<<<<<<<<<<<<<<<<<<<<<<<
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFF673AB7),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF131313),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'CART'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'ORDERS'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'PROFILE'),
        ],
      ),
    );
  }
}
