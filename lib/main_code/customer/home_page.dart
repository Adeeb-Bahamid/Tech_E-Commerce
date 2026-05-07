import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/tech_store.png',
                width: 60,
                height: 60,
              ),
              const Expanded(
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Hello, User',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      subtitle: Text('Find your favorite products'),
                    ),
                  ],
                ),
              ),
              // IconButton(
              //     onPressed: () {},
              //     icon: const CircleAvatar(
              //         child: Icon(Icons.notifications)))
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
                Icon(Icons.search, color: color.onPrimary.withOpacity(0.5)),
            hintText: 'Search products...',
            filled: true,
            fillColor: color.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: color.primary,
                width: 1.5,
              ),
            ),
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
                      : color.onPrimary.withOpacity(0.5),
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
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  var data = docs[index].data() as Map<String, dynamic>;

                  return ProductCard(
                    productId: docs[index].id,
                    name: data['name'] ?? 'No Name',
                    price: '${data['price']}',
                    imageUrl: '${data['imageUrl']}',
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// >>>>>>>>>>>>>>>>> (Product Card) <<<<<<<<<<<<<<<<<<<<<
class ProductCard extends StatelessWidget {
  final String name, price;
  final String productId;
  final String? imageUrl;
  ProductCard({
    super.key,
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
  });
  final FirebaseHelper _firebaseHelper = FirebaseHelper();
  final int quantity = 0;

  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: color.onSecondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: imageUrl != null
                  ? Image.network(imageUrl!, fit: BoxFit.fill)
                  : const Icon(Icons.image, size: 50),
            ),
          ),
          const SizedBox(height: 10),
          Text(name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(price,
                  style: TextStyle(
                      color: color.secondary, fontWeight: FontWeight.bold)),
              const Spacer(),
              Container(
                width: 30,
                height: 30,
                // padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: color.primary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: const EdgeInsets.all(0),
                  constraints: const BoxConstraints(maxHeight: 5, maxWidth: 5),
                  onPressed: () async {
                    final userId = FirebaseAuth.instance.currentUser!.uid;
                    await _firebaseHelper.addToCart(
                      userId: userId,
                      productId: productId,
                      name: name,
                      imageUrl: imageUrl,
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
                      color: color.onSecondary.withOpacity(0.5), size: 16),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
