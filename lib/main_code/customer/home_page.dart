import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tech_e_commerce/main_code/shared/services/images_services.dart';

import '../shared/services/firebase_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedFilterIndex = 0;
  String searchQuery = "";
  final List<String> _filters = ['All', 'Phones', 'Laptops', 'Tablets'];
  final FirebaseHelper _firebaseHelper = FirebaseHelper();
  final String user = FirebaseAuth.instance.currentUser!.displayName!;
  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Hello, $user',
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        subtitle: const Text('Find your favorite products'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // >>>>>>>>>>>>>>>>>>>>>>>>>>>>> Search Bar <<<<<<<<<<<<<<<<<<<<<<<<<
          TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value.trim().toLowerCase();
              });
            },
            decoration: InputDecoration(
              prefixIcon:
                  Icon(Icons.search, color: color.onSecondary.withOpacity(0.5)),
              hintText: 'Search products...',
              filled: true,
              fillColor: color.surface,
            ),
          ),
          const SizedBox(height: 10),
          // >>>>>>>>>>>>>>>>>>>>>>>>>>>>> Filter Bar <<<<<<<<<<<<<<<<<<<<<<<<<
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: 14),
                child: FilterChip(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  showCheckmark: false,
                  side: BorderSide.none,
                  label: Text(_filters[index]),
                  selected: _selectedFilterIndex == index,
                  onSelected: (val) =>
                      setState(() => _selectedFilterIndex = index),
                  backgroundColor: color.surface,
                  selectedColor: color.primary,
                  labelStyle: TextStyle(
                    color: _selectedFilterIndex == index
                        ? color.onPrimary
                        : color.onSecondary.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // >>>>>>>>>>>>>>>>>>>>>>>>>> Data <<<<<<<<<<<<<<<<<<<<<<<<<<
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firebaseHelper
                  .getCollection(
                      collection: 'Product',
                      selectedCategory: _filters[_selectedFilterIndex])
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                var docs = snapshot.data!.docs.where((doc) {
                  var name = (doc.data() as Map<String, dynamic>)['name']
                      .toString()
                      .toLowerCase();
                  return name.contains(searchQuery.toLowerCase());
                }).toList();
                return GridView.builder(
                  // padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.5,
                  ),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var data = docs[index].data() as Map<String, dynamic>;

                    return ProductCard(
                      productId: docs[index].id,
                      name: data['name'] ?? 'No Name',
                      price: '${data['price']}',
                      publicId: '${data['imageId']}',
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// >>>>>>>>>>>>>>>>> (Product Card) <<<<<<<<<<<<<<<<<<<<<
class ProductCard extends StatelessWidget {
  final String name, price;
  final String productId;
  final String? publicId;
  ProductCard({
    super.key,
    required this.productId,
    required this.name,
    required this.price,
    required this.publicId,
  });
  final FirebaseHelper _firebaseHelper = FirebaseHelper();
  final ImagesServices _imagesServices = ImagesServices();
  final int quantity = 0;

  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 220,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: color.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: publicId != null
                ? Image.network(
                    _imagesServices.image(publicId!),
                    fit: BoxFit.fill,
                  )
                : const Icon(Icons.image, size: 50),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text('\$$price',
                          style: TextStyle(
                              fontSize: 16,
                              color: color.secondary,
                              fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: color.primary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          padding: const EdgeInsets.all(0),
                          constraints:
                              const BoxConstraints(maxHeight: 8, maxWidth: 8),
                          onPressed: () async {
                            final userId =
                                FirebaseAuth.instance.currentUser!.uid;
                            await _firebaseHelper.addToCart(
                              userId: userId,
                              productId: productId,
                              name: name,
                              publicId: publicId,
                              price: double.parse(price),
                            );

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Add To Cart'),
                                  backgroundColor: color.secondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                ),
                              );
                            }
                          },
                          icon: Icon(Icons.shopping_cart_checkout,
                              color: color.onPrimary, size: 20),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
