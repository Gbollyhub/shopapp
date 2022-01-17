import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/widgets/drawer.dart';

import '../providers/products.dart';
import '../screens/add_products_screen.dart';
import '../widgets/drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static final routeName = '/user-products';

  Future<void> _refreshproducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AddScreen.routeName);
              })
        ],
      ),
      drawer: MainDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshproducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
              itemCount: productData.items.length,
              itemBuilder: (_, i) => Column(
                    children: [
                      UserProductitem(
                          productData.items[i].id,
                          productData.items[i].title,
                          productData.items[i].imageUrl),
                      Divider()
                    ],
                  )),
        ),
      ),
    );
  }
}
