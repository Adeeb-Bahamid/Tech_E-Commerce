import 'package:flutter/material.dart';

import '../shared/services/firebase_helper.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    final FirebaseHelper _firebaseHelper = FirebaseHelper();
    ColorScheme color = Theme.of(context).colorScheme;
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(children: [
                // >>>>>>>>>>>>>>>>>>>>>>Tabel Header<<<<<<<<<<<<<<<<<<<<
                SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: 900,
                      child: StreamBuilder(
                        stream: _firebaseHelper
                            .getCollection(
                              collection: 'Orders',
                            )
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return const Center(
                                child: Text("Something went wrong"));
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Center(
                                child: Text("No products found"));
                          }

                          var docs = snapshot.data!.docs;

                          return DataTable(
                            columnSpacing: 20,
                            headingRowColor: WidgetStateProperty.all(
                              color.secondary.withOpacity(0.1),
                            ),
                            columns: const [
                              DataColumn(label: Text('PRODUCT')),
                              DataColumn(label: Text('CUSTMER NAME')),
                              DataColumn(
                                  label: Expanded(child: Text('TOTATL'))),
                              DataColumn(label: Text('STATUS/ACTIONS')),
                            ],
                            rows: docs.map((doc) {
                              final data = doc.data();
                              return dataRow(
                                context,
                                name: data['name'] ?? 'N/A',
                                category: data['category'] ?? 'N/A',
                                price: '\$${data['price'] ?? 0}',
                                quantity: '${data['quantity'] ?? 0} units',
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  DataRow dataRow(
    BuildContext context, {
    required String name,
    required String category,
    required String price,
    required String quantity,
    // String? imageUrl,
  }) {
    final color = Theme.of(context).colorScheme;

    return DataRow(
      cells: [
        // 1. ID Cell
        // DataCell(Text(id.toString(), style: TextStyle(color: color.onSurface))),

        // 2. Product (Image + Name) Cell
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F1113),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF2E3035)),
                ),
                // child: imageUrl != null
                //     ? Image.asset(imageUrl, fit: BoxFit.contain)
                //     : const Icon(Icons.image, size: 18, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Text(name,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: color.onSurface)),
            ],
          ),
        ),

        // 3. Category Cell
        DataCell(Text(category,
            style: TextStyle(color: color.onSurface.withOpacity(0.5)))),

        // 4. Price Cell
        DataCell(Text(price,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: color.onSurface))),

        // 5. Quantity Cell
        // DataCell(Text(quantity, style: TextStyle(color: color.onSurface))),

        // 6. Actions Cell
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.edit_outlined,
                    size: 20, color: color.onSurface.withOpacity(0.5)),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.delete_outline,
                    size: 20, color: color.onSurface.withOpacity(0.5)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
