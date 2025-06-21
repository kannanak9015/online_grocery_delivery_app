
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_deliverys/ShopkeeperModule/shopkeeper_services.dart';

class ProductManagementScreen extends StatelessWidget {
  final ProductService _productService = ProductService();

  ProductManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Management')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _productService.getProducts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          var products = snapshot.data!.docs;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index];
              return ListTile(
                title: Text(product['name']),
                leading: Image.network(product['image']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text("₹ ${product['price'].toString()}"),
                  Text(product['description']),
                ],),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                     showDialog(
                       context: context,
                       builder: (BuildContext context) {
                         final _editNameController = TextEditingController(text: product['name']);
                         final _editPriceController = TextEditingController(text: product['price'].toString());
                         final _editDescriptionController = TextEditingController(text: product['description']);
                         final _editImageLinkController = TextEditingController(text: product['image']);

                         return AlertDialog(
                           title: Text('Edit Product'),
                           content: Column(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               TextField(
                                 controller: _editNameController,
                                 decoration: InputDecoration(labelText: 'Product Name'),
                               ),
                               TextField(
                                 controller: _editPriceController,
                                 decoration: InputDecoration(labelText: 'Price'),
                                 keyboardType: TextInputType.number,
                               ),
                               TextField(
                                 controller: _editDescriptionController,
                                 decoration: InputDecoration(labelText: 'Description'),
                               ),
                               TextField(
                                 controller: _editImageLinkController,
                                 decoration: InputDecoration(labelText: 'Product Image Link'),
                               ),
                             ],
                           ),
                           actions: [
                             TextButton(
                               onPressed: () {
                                 Navigator.of(context).pop();
                               },
                               child: Text('Cancel'),
                             ),
                             TextButton(
                               onPressed: () {
                                 final updatedProductData = {
                                   'name': _editNameController.text,
                                   'price': double.parse(_editPriceController.text),
                                   'description': _editDescriptionController.text,
                                   'image': _editImageLinkController.text,
                                 };
                                 _productService.updateProduct(product.id, updatedProductData).then((_) {
                                   ScaffoldMessenger.of(context).showSnackBar(
                                     SnackBar(content: Text('Product updated successfully')),
                                   );
                                   Navigator.of(context).pop();
                                 }).catchError((error) {
                                   ScaffoldMessenger.of(context).showSnackBar(
                                     SnackBar(content: Text('Failed to update product: $error')),
                                   );
                                 });
                               },
                               child: Text('Save'),
                             ),
                           ],
                         );
                       },
                     );
                   },
                ),
              );
            },
          );
        },
      ),
    );
  }
}