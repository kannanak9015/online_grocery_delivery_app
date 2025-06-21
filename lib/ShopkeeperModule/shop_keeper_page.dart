import 'package:flutter/material.dart';
import 'package:grocery_deliverys/ShopkeeperModule/add_product_page.dart';
import 'package:grocery_deliverys/ShopkeeperModule/order_handle_page.dart';
import 'package:grocery_deliverys/ShopkeeperModule/products_managements.dart';

class ShopkeeperScreen extends StatelessWidget {
  const ShopkeeperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddProductPage()));
      },child: Icon(Icons.add),),
      appBar: AppBar(title: Text('Shopkeeper Module')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductManagementScreen()));
            }, child: Text("Product Management")),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderHandlingScreen()));
            }, child: Text("Orders Management")),
          ],
        ),
      ),
    );
  }
}
