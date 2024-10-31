import 'package:bonjour/Model/Fakestore.dart';
import 'package:bonjour/data.dart';
import 'package:bonjour/drawer.dart';
import 'package:bonjour/service/fakestore.dart';
import 'package:flutter/material.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = ApiService().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: Text('Product List'),
        centerTitle: true,
      ),
      drawer: MainDrawer(),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found'));
          }

          List<Product> products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: EdgeInsets.only(bottom: 8, left: 20, right: 20, top: 8),
                child: ListTile(
                  leading: Container(
                      width: 70,
                      height: 70,
                      child: Image.network(product.image)),
                  title: Text(product.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  subtitle: Text('\$${product.price.toString()}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: primaryColor),),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
