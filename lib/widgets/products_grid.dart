import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import 'product_item.dart';

class ProductGrid extends StatelessWidget {
  bool showOnlyFav;

  ProductGrid(this.showOnlyFav);
  @override
  Widget build(BuildContext context) {
    //import data from your provider
    final productsData = Provider.of<Products>(context);
    final products = showOnlyFav ? productsData.favItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      //you can use changenotififer.value instead of create
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          // create: (c) => products[i],
          value: products[i],
          child: ProductItem()),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
