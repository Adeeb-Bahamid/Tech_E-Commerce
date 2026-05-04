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
      subTitle: 'subTitle',
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
                    // const Icon(Icons.dashboard_customize_outlined, color: Color(0xFFB580D1), size: 30),
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

          // 2. محتوى الصفحة الرئيسي (Main Content)
          // Expanded(
          //   child: SingleChildScrollView(
          //     padding: const EdgeInsets.all(32.0),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         // ترويسة الصفحة
          //         const Text('Products',
          //             style: TextStyle(
          //                 fontSize: 28,
          //                 fontWeight: FontWeight.bold,
          //                 color: Colors.white)),
          //         const Text('Manage your store products',
          //             style: TextStyle(fontSize: 14, color: Colors.grey)),
          //         const SizedBox(height: 30),

          //         // شريط الأدوات (البحث، الفلترة، زر الإضافة)
          //         Row(
          //           children: [
          //             // حقل البحث
          //             Expanded(
          //               child: TextField(
          //                 decoration: InputDecoration(
          //                   prefixIcon:
          //                       const Icon(Icons.search, color: Colors.grey),
          //                   hintText: 'Search products...',
          //                   hintStyle: const TextStyle(color: Colors.grey),
          //                   filled: true,
          //                   fillColor: const Color(0xFF1E1F23),
          //                   contentPadding:
          //                       const EdgeInsets.symmetric(vertical: 16),
          //                   border: OutlineInputBorder(
          //                     borderRadius: BorderRadius.circular(10),
          //                     borderSide: BorderSide.none,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             const SizedBox(width: 15),
          //             // قائمة التصنيفات
          //             Container(
          //               padding: const EdgeInsets.symmetric(
          //                   horizontal: 16, vertical: 12),
          //               decoration: BoxDecoration(
          //                 color: const Color(0xFF1E1F23),
          //                 borderRadius: BorderRadius.circular(10),
          //               ),
          //               child: Row(
          //                 children: const [
          //                   Text('All Categories',
          //                       style: TextStyle(color: Colors.white)),
          //                   SizedBox(width: 40),
          //                   Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          //                 ],
          //               ),
          //             ),
          //             const SizedBox(width: 15),
          //             // زر إضافة منتج
          //             ElevatedButton.icon(
          //               onPressed: () {},
          //               icon: const Icon(Icons.add, size: 18),
          //               label: const Text('Add Product'),
          //               style: ElevatedButton.styleFrom(
          //                 backgroundColor: const Color(0xFF6C3CD1),
          //                 foregroundColor: Colors.white,
          //                 padding: const EdgeInsets.symmetric(
          //                     horizontal: 24, vertical: 18),
          //                 // shape: RoundedRectangleWith(context),borderRadius: BorderRadius.circular(10),
          //               ),
          //             ),
          //           ],
          //         ),
          //         const SizedBox(height: 30),

          //         // جدول المنتجات (في حاوية ببطاقة)
          //         Container(
          //           decoration: BoxDecoration(
          //             color: const Color(0xFF1E1F23),
          //             borderRadius: BorderRadius.circular(15),
          //           ),
          //           child: Padding(
          //             padding: const EdgeInsets.all(20.0),
          //             child: Column(
          //               children: [
          //                 // ترويسة الجدول
          //                 Padding(
          //                   padding: const EdgeInsets.symmetric(
          //                       horizontal: 12, vertical: 8),
          //                   child: Row(
          //                     children: [
          //                       _buildTableHeader('PRODUCT', width: 280),
          //                       _buildTableHeader('CATEGORY', width: 120),
          //                       _buildTableHeader('PRICE', width: 120),
          //                       _buildTableHeader('QUANTITY', width: 120),
          //                       _buildTableHeader('STATUS', width: 120),
          //                       _buildTableHeader('ACTIONS', width: 100),
          //                     ],
          //                   ),
          //                 ),
          //                 const Divider(color: Color(0xFF2E3035)),

          //                 // صفوف المنتجات
          //                 ProductRow(
          //                   // imageUrl: 'assets/iphone.png',
          //                   name: 'iPhone 15 Pro Max',
          //                   sku: 'SKU: IPH-15-PM-512',
          //                   category: 'Phones',
          //                   price: '\$1,199.00',
          //                   quantity: '42 units',
          //                   status: 'IN STOCK',
          //                   statusColor: const Color(0xFF1ED760),
          //                 ),
          //                 ProductRow(
          //                   // imageUrl: 'assets/macbook.png',
          //                   name: 'MacBook Pro 16" M3',
          //                   sku: 'SKU: LAP-MBP-16-M3',
          //                   category: 'Laptops',
          //                   price: '\$2,499.00',
          //                   quantity: '8 units',
          //                   status: 'LOW STOCK',
          //                   statusColor: const Color(0xFFFF9F43), // برتقالي
          //                   statusBackgroundColor: const Color(0xFF3B2E24),
          //                 ),
          //                 ProductRow(
          //                   // imageUrl: 'assets/ipad.png',
          //                   name: 'iPad Air 5th Gen',
          //                   sku: 'SKU: TAB-IPA-59',
          //                   category: 'Accessories',
          //                   price: '\$599.00',
          //                   quantity: '0 units',
          //                   status: 'OUT OF STOCK',
          //                   statusColor: const Color(0xFFFF5E5E), // أحمر
          //                   statusBackgroundColor: const Color(0xFF3B2424),
          //                 ),
          //                 ProductRow(
          //                   // imageUrl: 'assets/sony_headphones.png',
          //                   name: 'Sony WH-1000XM5',
          //                   sku: 'SKU: ACC-SON-XM5',
          //                   category: 'Accessories',
          //                   price: '\$349.00',
          //                   quantity: '124 units',
          //                   status: 'IN STOCK',
          //                   statusColor: const Color(0xFF1ED760),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // // ويدجت مساعدة لبناء ترويسة الجدول
  // Widget _buildTableHeader(String text, {double width = 100}) {
  //   return Container(
  //     width: width,
  //     alignment: Alignment.centerLeft,
  //     child: Text(text,
  //         style: const TextStyle(
  //             fontSize: 11,
  //             color: Colors.grey,
  //             fontWeight: FontWeight.bold,
  //             letterSpacing: 1)),
  //   );
  // }

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



// class ProductRow extends StatelessWidget {
//   // final String imageUrl;
//   final String name;
//   final String sku;
//   final String category;
//   final String price;
//   final String quantity;
//   final String status;
//   final Color statusColor;
//   final Color? statusBackgroundColor;

//   const ProductRow({
//     super.key,
//     // required this.imageUrl,
//     required this.name,
//     required this.sku,
//     required this.category,
//     required this.price,
//     required this.quantity,
//     required this.status,
//     required this.statusColor,
//     this.statusBackgroundColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // تحديد لون خلفية البادج بناءً على الحالة إذا لم يحدد
//     final effectiveStatusBgColor =
//         statusBackgroundColor ?? statusColor.withOpacity(0.1);

//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//           child: Row(
//             children: [
//               // عمود المنتج (صورة + اسم + SKU)
//               SizedBox(
//                 width: 280,
//                 child: Row(
//                   children: [
//                     // حاوية الصورة
//                     Container(
//                       width: 50,
//                       height: 50,
//                       padding: const EdgeInsets.all(4),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF0F1113),
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: const Color(0xFF2E3035)),
//                       ),
//                       // child: Image.asset(imageUrl, fit: BoxFit.contain, errorBuilder: (c,e,s) => const Icon(Icons.image, color: Colors.grey)), // Handle missing assets
//                     ),
//                     const SizedBox(width: 15),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(name,
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.white)),
//                           Text(sku,
//                               style: const TextStyle(
//                                   fontSize: 11, color: Colors.grey)),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // الفئة
//               SizedBox(
//                   width: 120,
//                   child: Text(category,
//                       style: const TextStyle(color: Colors.white70))),
//               // السعر
//               SizedBox(
//                   width: 120,
//                   child: Text(price,
//                       style: const TextStyle(
//                           fontWeight: FontWeight.bold, color: Colors.white))),
//               // الكمية
//               SizedBox(
//                   width: 120,
//                   child: Text(quantity,
//                       style: const TextStyle(color: Colors.white70))),
//               // الحالة (Badge)
//               SizedBox(
//                 width: 120,
//                 child: IntrinsicWidth(
//                   child: Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: effectiveStatusBgColor,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           width: 6,
//                           height: 6,
//                           decoration: BoxDecoration(
//                               color: statusColor, shape: BoxShape.circle),
//                         ),
//                         const SizedBox(width: 6),
//                         Text(status,
//                             style: TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.bold,
//                                 color: statusColor,
//                                 letterSpacing: 0.5)),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               // الإجراءات
//               SizedBox(
//                 width: 100,
//                 child: Row(
//                   children: [
//                     IconButton(
//                         onPressed: () {},
//                         icon: const Icon(Icons.edit_outlined,
//                             size: 20, color: Colors.grey)),
//                     IconButton(
//                         onPressed: () {},
//                         icon: const Icon(Icons.delete_outline,
//                             size: 20, color: Colors.grey)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const Divider(
//             color: Color(0xFF2E3035), height: 1), // خط فاصل بين الصفوف
//       ],
//     );
//   }
// }
