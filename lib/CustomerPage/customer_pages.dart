import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'order_place_screen.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _products = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    QuerySnapshot querySnapshot = await _firestore.collection('products').get();
    setState(() {
      _products = querySnapshot.docs;
    });
  }

void _addToCart(DocumentSnapshot product) {
  _firestore.collection('cart').add({
    'productId': product.id,
    'name': product['name'],
    'price': product['price'],
    'quantity': 1, // Default quantity
  }).then((value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product['name']} added to cart')),
    );
  }).catchError((error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to add to cart: $error')),
    );
  });
}

  @override
  Widget build(BuildContext context) {
    List<DocumentSnapshot> filteredProducts = _products.where((product) {
      return product['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Module'),
               actions: [
              IconButton(
                icon: Icon(Icons.search),
                 onPressed: () {
                 showSearch(
                 context: context,
                  delegate: ProductSearchDelegate(_products, _addToCart),
              );
            },
         ),
         IconButton(
            icon: Icon(Icons.shopping_cart),
              onPressed: () {
              Navigator.push(
                context,
                  MaterialPageRoute(builder: (context) => CartDetailsScreen()),
                );
                },
            ),
           ],
      ),
      body: ListView.builder(
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          DocumentSnapshot product = filteredProducts[index];
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
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () => _addToCart(product),
            ),
          );
        },
      ),
    );
  }
}

class ProductSearchDelegate extends SearchDelegate {
  final List<DocumentSnapshot> products;
  final Function(DocumentSnapshot) onAddToCart;

  ProductSearchDelegate(this.products, this.onAddToCart);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<DocumentSnapshot> filteredProducts = products.where((product) {
      return product['name'].toString().toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        DocumentSnapshot product = filteredProducts[index];
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
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () => onAddToCart(product),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<DocumentSnapshot> filteredProducts = products.where((product) {
      return product['name'].toString().toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        DocumentSnapshot product = filteredProducts[index];
        return ListTile(
          title: Text(product['name']),
          leading: Image.network(product['image']),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("₹ ${product['price'].toString()}"),
              Text(product['description']),
            ],),
        );
      },
    );
  }
}


