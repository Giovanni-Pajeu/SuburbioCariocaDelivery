

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suburbiodelivery/src/address_card.dart';
import 'package:suburbiodelivery/src/cart_manager.dart';
import 'package:suburbiodelivery/src/price_card.dart';

class AddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrega'),
        centerTitle: true,
      ),
      body: ListView(children: <Widget>[
        AddressCard(),
        Consumer<CartManager>(
          builder: (_, cartManager, __) {
            return Column(
              children: <Widget>[

                PriceCard(
                  buttonText: 'Continuar para o Pagamento',
                  onPressed: cartManager.isAddressValid
                      ? () {
                          Navigator.of(context).pushNamed('/checkout');
                        }
                      : null,
                ),
              ],
            );
          },
        ),
      ]),
    );
  }
}
