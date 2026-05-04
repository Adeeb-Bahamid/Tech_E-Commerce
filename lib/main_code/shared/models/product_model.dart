import 'package:uuid/uuid.dart';

class ProductModel {
  final String? imageUrl;
  final String? imageId;
  final String id;
  final String name;
  final String category;
  final double price;
  final int quantity;

  ProductModel({
    String? id,
    required this.imageId,
    required this.imageUrl,
    required this.name,
    required this.category,
    required this.price,
    required this.quantity,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'imageId': imageId,
      'name': name,
      'category': category,
      'price': price,
      'quantity': quantity
    };
  }
}
