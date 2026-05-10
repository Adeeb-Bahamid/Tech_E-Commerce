import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrderModel {
  final String id;
  final String customerName;
  final String userId;
  final List<Map<String, dynamic>> cartItems;
  final double total;
  final String status;
  final dynamic createdAt;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.userId,
    required this.cartItems,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    Timestamp timestamp = map['createdAt'] ?? 'Today';
    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat.yMd().format(dateTime);
    return OrderModel(
      id: map['id'],
      customerName: map['Customer name'] ?? '',
      userId: map['userId'] ?? '',
      cartItems: (map['cartItems'] as List<dynamic>?)
              ?.map((item) => Map<String, dynamic>.from(item))
              .toList() ??
          [],
      total: (map['Total'] ?? 0).toDouble(),
      status: map['Status'] ?? 'Pending',
      createdAt: formattedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Customer name': customerName,
      'userId': userId,
      'cartItems': cartItems,
      'Total': total,
      'Status': status,
      'createdAt': createdAt,
    };
  }
}
