import 'package:flutter/material.dart';
import 'package:tech_e_commerce/main_code/shared/services/firebase_helper.dart';
import 'package:tech_e_commerce/main_code/shared/services/images_services.dart';

import '../shared/models/product_model.dart';

class Products extends StatefulWidget {
  final String title;
  final String subTitle;
  const Products({super.key, required this.title, required this.subTitle});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final ImagesServices _imagesServices = ImagesServices();
  final FirebaseHelper _firebaseHelper = FirebaseHelper();
  String? imageUrl;
  List<String> categories = [
    'All',
    'Phones',
    'Laptops',
    'Tablets'
  ]; // تحسين التسمية لتبدأ بحرف صغير
  String? selectedCategory = 'All';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

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
                  color: color.onPrimary,
                ),
              ),
              Text(
                widget.subTitle,
                style: TextStyle(
                  fontSize: 14,
                  color: color.onPrimary.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .stretch, // جعل العناصر تمتد للعرض بالكامل
                  children: [
                    const SizedBox(height: 30),

                    // >>> Tool Bar <<<
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search,
                                  color: color.onPrimary.withOpacity(0.5)),
                              hintText: 'Search products...',
                              filled: true,
                              fillColor: color.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: color.surface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButton<String>(
                            underline: const SizedBox.shrink(),
                            value: selectedCategory,
                            items: categories
                                .map((item) => DropdownMenuItem(
                                    value: item, child: Text(item)))
                                .toList(),
                            onChanged: (value) =>
                                setState(() => selectedCategory = value),
                          ),
                        ),
                        const SizedBox(width: 15),
                        ElevatedButton.icon(
                          onPressed: () => _showAddProductDialog(context),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add Product'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color.primary,
                            foregroundColor: color.onPrimary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 18),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: color.surface,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    minWidth: constraints.maxWidth - 100),
                                child: StreamBuilder(
                                  stream: _firebaseHelper
                                      .getCollection(
                                          collection: 'Product',
                                          selectedCategory: selectedCategory)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }

                                    var docs = snapshot.data?.docs ?? [];

                                    return DataTable(
                                      columnSpacing:
                                          (constraints.maxWidth / 10),
                                      headingRowColor: WidgetStateProperty.all(
                                          color.secondary.withOpacity(0.1)),
                                      columns: const [
                                        DataColumn(label: Text('PRODUCT')),
                                        DataColumn(label: Text('CATEGORY')),
                                        DataColumn(label: Text('PRICE')),
                                        DataColumn(label: Text('QUANTITY')),
                                        DataColumn(label: Text('ACTIONS')),
                                      ],
                                      rows: docs.map((doc) {
                                        final data = doc.data();
                                        return dataRow(
                                          context,
                                          imageUrl: data['imageUrl'],
                                          name: data['name'] ?? 'N/A',
                                          category: data['category'] ?? 'N/A',
                                          price: '\$${data['price'] ?? 0}',
                                          quantity:
                                              '${data['quantity'] ?? 0} units',
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showAddProductDialog(BuildContext context) async {
    List<String> Categories = ['Phones', 'Laptops', 'Tablets'];
    final color = Theme.of(context).colorScheme;
    String? category = 'Phones';
    showDialog(
      context: context,
      barrierColor: color.onSecondary.withOpacity(0.7),
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          backgroundColor: color.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFF2E3035), width: 1),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add New Product",
                style: TextStyle(
                  color: color.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Enter product details below",
                style: TextStyle(
                    color: color.onPrimary.withOpacity(0.5),
                    fontSize: 13,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCustomField(
                    controller: _nameController,
                    label: "Product Name",
                    icon: Icons.shopping_bag_outlined,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: _buildCustomField(
                              controller: _priceController,
                              label: "Price",
                              icon: Icons.attach_money,
                              hint: "0.00")),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildCustomField(
                              controller: _quantityController,
                              label: "Quantity",
                              icon: Icons.inventory_2_outlined,
                              hint: "0")),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                              color: const Color(0xFF0F1113),
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            underline: const SizedBox.shrink(),
                            hint: Text(category.toString()),
                            items: Categories.map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                category = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () async {
                              imageUrl = await _imagesServices.uploadImage();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color.primary.withOpacity(0.3),
                              foregroundColor: color.onPrimary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: const Text('Selected Image')),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.all(20),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel",
                  style: TextStyle(
                      color: color.onPrimary.withOpacity(0.5),
                      fontWeight: FontWeight.w600)),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color.primary,
                foregroundColor: color.onPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              onPressed: () {
                ProductModel product = ProductModel(
                  name: _nameController.text,
                  imageUrl: imageUrl,
                  category: category!,
                  price: double.parse(_priceController.text),
                  quantity: int.parse(_quantityController.text),
                );
                _firebaseHelper.setProduct(
                    collection: 'Product', product: product.toMap());
                _nameController.clear();
                _priceController.clear();
                _quantityController.clear();
                Navigator.pop(context);
              },
              child: const Text("Add Product",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCustomField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
  }) {
    final color = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: color.onPrimary.withOpacity(0.7),
                fontSize: 13,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
                color: color.onPrimary.withOpacity(0.5), fontSize: 14),
            prefixIcon:
                Icon(icon, color: color.onPrimary.withOpacity(0.7), size: 20),
            filled: true,
            fillColor: const Color(0xFF0F1113),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2E3035)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: color.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  DataRow dataRow(
    BuildContext context, {
    required String name,
    required String category,
    required String price,
    required String quantity,
    required String? imageUrl,
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
                child: imageUrl != null
                    ? Image.network(imageUrl, fit: BoxFit.contain)
                    : const Icon(Icons.image, size: 18, color: Colors.grey),
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
        DataCell(Text(quantity, style: TextStyle(color: color.onSurface))),

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
