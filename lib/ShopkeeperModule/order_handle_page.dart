
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_deliverys/ShopkeeperModule/shopkeeper_services.dart';

class OrderHandlingScreen extends StatelessWidget {
  final OrderService _orderService = OrderService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Handling')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _orderService.getOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          var orders = snapshot.data!.docs;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];
              return ListTile(
                title: Text('Order ID: ${order.id}'),
                subtitle: Text('Status: ${order['status']}'),
                 trailing: DropdownButton<String>(
                  value: ['Pending', 'Processing', 'Completed'].contains(order['status']) ? order['status'] : null,
                  items: ['Pending', 'Processing', 'Completed']
                      .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ))
                      .toList(),
                  onChanged: (newStatus) {
                    _orderService.updateOrderStatus(order.id, newStatus!);
                  },
                ),              );
            },
          );
        },
      ),
    );
  }
}