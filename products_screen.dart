
import 'package:flutter/material.dart';
import 'package:suburbiodelivery/src/products.dart';

class ProductListTile extends StatelessWidget {
  ProductListTile(this.product);
  final Products product;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: GestureDetector(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            height: 100,
            padding: EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(product.images.first),
                ),
                const SizedBox(
                  width: 40,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        product.name,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          'A partir de:',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                            top: 10,
                          ),
                          child: Text(
                            'R\$ ${product.pricefixe.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 18, color: Colors.green),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: () {
          Navigator.of(context).pushNamed('/teladeproduto', arguments: product);
        },
      ),
    );
  }
}
