import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addProduct(Map<String, dynamic> productData) async {
    await _firestore.collection('products').add(productData);
  }

  Future<void> updateProduct(String productId, Map<String, dynamic> productData) async {
    await _firestore.collection('products').doc(productId).update(productData);
  }

  Future<void> deleteProduct(String productId) async {
    await _firestore.collection('products').doc(productId).delete();
  }

  Stream<QuerySnapshot> getProducts() {
    return _firestore.collection('products').snapshots();
  }
}

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _firestore.collection('orders').doc(orderId).update({'status': status});
  }

  Stream<QuerySnapshot> getOrders() {
    return _firestore.collection('orders').snapshots();
  }
}

class PaymentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getTransactions() {
    return _firestore.collection('transactions').snapshots();
  }
}

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendNotification(String userId, String message) async {
    await _firestore.collection('notifications').add({
      'userId': userId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getNotifications(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }
}