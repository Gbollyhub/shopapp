import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  void goToDetail(BuildContext ctx, String id) {
    // Navigator.of(ctx).push(MaterialPageRoute(
    //     builder: (ctx) => ProductDetailScreen(title)));
    Navigator.of(ctx).pushNamed(ProductDetailScreen.routeName, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Product>(
      context,
      listen: false,
    );
    final cart = Provider.of<Cart>(context, listen: false);
    //ClipRReact
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: () {
              goToDetail(context, productData.id);
            },
            child: Hero(
              tag: productData.id,
              child: FadeInImage(
                placeholder:
                    AssetImage('assets/images/product-placeholder.png'),
                image: NetworkImage(productData.imageUrl),
                fit: BoxFit.cover,
              ),
            )),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          //using provider.of.context rebuild the app
          //for performance reason, u can use consumer,
          //you only want to affect a small part in the app
          leading: Consumer<Product>(
            builder: (ctx, productData, child) => IconButton(
              icon: Icon(productData.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border),
              onPressed: () {
                productData.toggleFavorite();
              },
            ),
          ),
          title: Text(productData.title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white)),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addToCart(
                  productData.id, productData.title, productData.price);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Added to Cart'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cart.undo(productData.id);
                  },
                ),
              ));
            },
          ),
        ),
      ),
    );
  }
}
