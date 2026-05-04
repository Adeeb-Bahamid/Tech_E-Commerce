import 'package:cloud_firestore/cloud_firestore.dart';
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
  Map<String, String>? image;
  List<String> categories = ['All', 'Phones', 'Laptops', 'Tablets'];
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          onPressed: () => _showAddProductDialog(context, null),
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
                                          id: data['id'],
                                          publicId: data['imageId'],
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

  Future<void> _showAddProductDialog(BuildContext context, String? id,
      {bool isUpdate = false}) async {
    List<String> categories = ['Phones', 'Laptops', 'Tablets'];
    final color = Theme.of(context).colorScheme;

    String? selectedCategory = 'Phones';
    bool isSelectImage = false;

    if (isUpdate && id != null) {
      var doc =
          await FirebaseFirestore.instance.collection('Product').doc(id).get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        _nameController.text = data['name']?.toString() ?? "";
        _priceController.text = data['price']?.toString() ?? "";
        _quantityController.text = data['quantity']?.toString() ?? "";
        selectedCategory = data['category']?.toString() ?? 'Phones';
        image = {
          'secure_url': data['imageUrl'] ?? "",
          'public_id': data['imageId'] ?? ""
        };
        isSelectImage = (image!['secure_url'] as String).isNotEmpty;
      }
    } else {
      _nameController.clear();
      _priceController.clear();
      _quantityController.clear();
      image = null;
      isSelectImage = false;
      selectedCategory = 'Phones';
    }

    if (!context.mounted) return;

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
          title: Text(
            isUpdate ? "Update Product" : "Add New Product",
            style:
                TextStyle(color: color.onPrimary, fontWeight: FontWeight.bold),
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
                              icon: Icons.attach_money)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildCustomField(
                              controller: _quantityController,
                              label: "Quantity",
                              icon: Icons.inventory_2_outlined)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                              color: const Color(0xFF0F1113),
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButton<String>(
                            value: selectedCategory,
                            isExpanded: true,
                            underline: const SizedBox.shrink(),
                            items: categories.map((item) {
                              return DropdownMenuItem(
                                  value: item, child: Text(item));
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => selectedCategory = value),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: isSelectImage && image != null
                            ? Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image:
                                            NetworkImage(image!['secure_url']!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => setState(() {
                                      isSelectImage = false;
                                      image = null;
                                    }),
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle),
                                      child: const Icon(Icons.close,
                                          size: 16, color: Colors.white),
                                    ),
                                  )
                                ],
                              )
                            : ElevatedButton.icon(
                                icon: const Icon(Icons.image),
                                label: const Text("Image"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      color.primary.withOpacity(0.1),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: () async {
                                  var pickedImage =
                                      await _imagesServices.uploadImage();
                                  if (pickedImage != null) {
                                    setState(() {
                                      image = pickedImage;
                                      isSelectImage = true;
                                    });
                                  }
                                },
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (image == null || _nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('Please fill all fields and add an image')));
                  return;
                }

                ProductModel product = ProductModel(
                  id: isUpdate ? id : null,
                  name: _nameController.text,
                  imageUrl: image!['secure_url'],
                  imageId: image!['public_id'],
                  category: selectedCategory!,
                  price: double.tryParse(_priceController.text) ?? 0.0,
                  quantity: int.tryParse(_quantityController.text) ?? 0,
                );

                if (isUpdate && id != null) {
                  await _firebaseHelper.updateCollection(
                      id: id, collection: 'Product', product: product.toMap());
                } else {
                  await _firebaseHelper.setCollection(
                      collection: 'Product', product: product.toMap());
                }

                if (context.mounted) Navigator.pop(context);
              },
              child: Text(isUpdate ? "Update" : "Add Product"),
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
    required String id,
    required String name,
    required String category,
    required String price,
    required String quantity,
    required String? publicId,
  }) {
    final color = Theme.of(context).colorScheme;

    return DataRow(
      cells: [
        //  Product (Image + Name) Cell
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
                child: publicId != null
                    ? Image.network(
                        _imagesServices.image(publicId),
                      )
                    : const Icon(Icons.image, size: 18, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Text(name,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: color.onSurface)),
            ],
          ),
        ),

        //  Category Cell
        DataCell(Text(category,
            style: TextStyle(color: color.onSurface.withOpacity(0.5)))),

        //  Price Cell
        DataCell(Text(price,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: color.onSurface))),

        //  Quantity Cell
        DataCell(Text(quantity, style: TextStyle(color: color.onSurface))),

        //  Actions Cell
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  _showAddProductDialog(context, id, isUpdate: true);
                },
                icon: Icon(Icons.edit_outlined,
                    size: 20, color: color.onSurface.withOpacity(0.5)),
              ),
              IconButton(
                onPressed: () {
                  _firebaseHelper.deletedDoc(collection: 'Product', id: id);
                },
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
