
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suburbiodelivery/src/cart_manager.dart';
import 'package:suburbiodelivery/src/itempagamentos.dart';

import 'package:suburbiodelivery/src/products.dart';

import 'package:suburbiodelivery/src/user_manager.dart';



class ProductScreen extends StatelessWidget {
  final Products product;

  const ProductScreen(this.product);


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(

        appBar: AppBar(
          title: Text(product.name),
          centerTitle: true,
          actions: <Widget>[
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images: product.images.map((url) {
                  return NetworkImage(url);
                }).toList(),
                dotSize: 4,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                autoplay: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    product.name,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'A partir de',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Text(
                    'R\$ ${product.pricefixe.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Descrição:',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Pagamentos:',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.pagamentos.map((p) {
                      return PagamentosWidget(pagamentos: p);
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Consumer2<UserManager, Products>(
                    builder: (_, userManager, product, __) {
                      return SizedBox(
                        height: 44,
                        child: RaisedButton(
                            onPressed: product.selectedPagamentos != null
                                ? () {
                              context.read<CartManager>().addToCart(product);
                              Navigator.of(context).pushNamed('/cart_screen');
                                                       }
                                : null,
                            color: Colors.blue,
                            textColor: Colors.white,
                            child: Text('Adicionar ao Carrinho',
                                style: TextStyle(color: Colors.white))),
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
