


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:suburbiodelivery/src/cart_manager.dart';
import 'package:suburbiodelivery/src/checkout_manager.dart';
import 'package:suburbiodelivery/src/price_card.dart';


class CheckoutScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) =>
      checkoutManager..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Pagamento'),
          centerTitle: true,
        ),
        body: Consumer<CheckoutManager>(
          builder: (_, checkoutManager, __){
    return ListView(
    children: <Widget>[
      PriceCard(
    buttonText: 'Finalizar Pedido',

    onPressed: (){
      checkoutManager.checkout();
      Navigator.pushNamed(context, '/confirmation_screen');


    },
    )
    ],
    );
    },
        ),
      ),
    );
  }

  // ignore: missing_return
  Function onStockFail() {
    const Text('Sem Estoque Para esse Produto');
  }
}