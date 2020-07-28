

import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suburbiodelivery/src/products.dart';


class ItemPagamentos {
  ItemPagamentos({this.name, this.price, this.stock});
  ItemPagamentos.fromMap(Map<String, dynamic> map) {
    name = map['name'] as String;
    price = map['price'] as num;
    stock = map['stock'] as int;
    id = map['id'] as String;
  }
  String id;
  String name;
  num price;
  int stock;

  bool get hasStock => stock > 0;
  ItemPagamentos clone(){
    return ItemPagamentos(
      name: name,
      price: price,
      stock: stock,
    );
  }
  ItemPagamentos clonne(){
    return ItemPagamentos(
      name: name,
      price: price,
      stock: stock,
    );
  }
  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'price': price,
      'stock': stock,
    };
  }
  @override
  String toString() {
    return 'ItemPagamentos{name: $name, prices: $price, stock: $stock}';
  }
}

class PagamentosWidget extends StatelessWidget {
  const PagamentosWidget({this.pagamentos});
  final ItemPagamentos pagamentos;
  @override
  Widget build(BuildContext context) {
    final product = context.watch<Products>();
    final selected = pagamentos == product.selectedPagamentos;
    Color color;
    if (!pagamentos.hasStock)
      color = Colors.red.withAlpha(50);
    else if (selected)
      color = Theme.of(context).primaryColor;
    else
      color = Colors.green;
    return GestureDetector(
      onTap: () {
        if (pagamentos.hasStock) {
          product.selectedPagamentos = pagamentos;
        }
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: !pagamentos.hasStock
                    ? Colors.red.withAlpha(50)
                    : Colors.green)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              color: color,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                pagamentos.name,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              color: color,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('R\$ ${pagamentos.price.toStringAsFixed(2)}'),
            )
          ],
        ),
      ),
    );
  }
}
