
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_deliverys/ShopkeeperModule/shopkeeper_services.dart';

class PaymentsEarningsScreen extends StatelessWidget {
  final PaymentService _paymentService = PaymentService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payments & Earnings')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _paymentService.getTransactions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          var transactions = snapshot.data!.docs;
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              var transaction = transactions[index];
              return ListTile(
                title: Text('Transaction ID: ${transaction.id}'),
                subtitle: Text('Amount: \$${transaction['amount']}'),
              );
            },
          );
        },
      ),
    );
  }
}