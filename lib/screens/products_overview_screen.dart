import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/cart_screen.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';
import '../widgets/drawer.dart';
import '../widgets/products_grid.dart';

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool showOnlyFav = false;
  var _isInit = true;
  var _isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    // Future.delayed(Duration.zero).then((value) {
    //   Provider.of<Products>(context).fetchProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).fetchProducts().then((_) => {
            setState(() {
              _isLoading = false;
            })
          });
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Shopz"),
          actions: [
            PopupMenuButton(
              onSelected: (int val) {
                setState(() {
                  if (val == 0) {
                    showOnlyFav = true;
                  } else {
                    showOnlyFav = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Only Favs'),
                  value: 0,
                ),
                PopupMenuItem(
                  child: Text('All'),
                  value: 1,
                )
              ],
            ),
            Consumer<Cart>(
              builder: (ctx, cartData, ch) => Badge(
                child: ch,
                value: cartData.cartCount.toString(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            )
          ],
        ),
        drawer: MainDrawer(),
        body: _isLoading
            ? Center(
                child: SizedBox(
                    height: 30, width: 30, child: CircularProgressIndicator()),
              )
            : ProductGrid(showOnlyFav));
  }
}
