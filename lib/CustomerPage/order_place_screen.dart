import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartDetailsScreen extends StatefulWidget {
  const CartDetailsScreen({super.key});

  @override
  State<CartDetailsScreen> createState() => _CartDetailsScreenState();
}

class _CartDetailsScreenState extends State<CartDetailsScreen> {
  void _placeOrder() async {
    final cartItems = await FirebaseFirestore.instance.collection('cart').get();
    if (cartItems.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cart is empty')),
      );
      return;
    }

    final order = {
      'items': cartItems.docs.map((doc) => doc.data()).toList(),
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'pending', // Ensure the status field is added
    };

    await FirebaseFirestore.instance.collection('orders').add(order);

    // Clear the cart
    for (var doc in cartItems.docs) {
      await doc.reference.delete();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order placed successfully')),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('cart').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final cartItems = snapshot.data!.docs;
          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final cartItem = cartItems[index];
              return ListTile(
                title: Text(cartItem['name']),
                subtitle: Text('₹ ${cartItem['price']} x ${cartItem['quantity']}'),
                trailing: Text('Total: ₹ ${cartItem['price'] * cartItem['quantity']}'),
              );
            },
          );
        },
      ),
            floatingActionButton: FloatingActionButton(
              onPressed: _placeOrder,
              child: Icon(Icons.check),
             tooltip: 'Place Order',
          ),
    );
  }
}

