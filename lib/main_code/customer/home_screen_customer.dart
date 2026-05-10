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
    ColorScheme color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          const SizedBox(width: 20),
          Image.asset(
            'assets/images/tech.png',
            width: 60,
            height: 50,
          ),
          const SizedBox(width: 15),
          Text(
            'Tech',
            style: TextStyle(color: color.primary, fontSize: 26),
          ),
          Text(
            'Store',
            style: TextStyle(
                color: color.secondary.withOpacity(0.6), fontSize: 20),
          ),
        ],
      )),
      body: SafeArea(
        child: _pages[_selectedIndex],
      ),

      // >>>>>>>>>>>>>>>>>>>>>>> (Bottom Navigation) <<<<<<<<<<<<<<<<<<<<<<<<<<<
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: color.primary,
        unselectedItemColor: color.onSecondary.withOpacity(0.3),
        type: BottomNavigationBarType.fixed,
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
