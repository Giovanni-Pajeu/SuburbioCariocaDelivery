import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:suburbiodelivery/src/ExportAddressDialog.dart';
import 'package:suburbiodelivery/src/cancelorderdialog.dart';
import 'package:suburbiodelivery/src/order.dart';
import 'package:suburbiodelivery/src/order_product_tile.dart';

class OrderTile extends StatelessWidget {
  const OrderTile(this.order, {this.showControls = false});

  final Order order;
  final bool showControls;

  @override
  Widget build(BuildContext context) {


    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    order.formattedId,
                    style: TextStyle(
                      wordSpacing: 10,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top:10, left: 10),
                  child: Text(
                    'R\$ ${order.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Text(
                order.statusText,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: order.status == Status.canceled ?
                  Colors.red : Colors.amber,
                  fontSize: 18
              ),
            ),


          ],
        ),
        children: <Widget>[
          Column(children: order.items.map((e){
            return OrderProductTile(e);
    }).toList()
          ),
          if(showControls && order.status != Status.canceled)
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  FlatButton(
                    onPressed: (){
                      showDialog(context: context,
                          builder: (_) => CancelOrderDialog(order)
                      );
                    },
                    textColor: Colors.red,
                    child: const Text('Cancelar'),
                  ),
                  FlatButton(
                    onPressed: order.back,
                    child: const Text('Recuar'),
                  ),
                  FlatButton(
                    onPressed: order.advance,
                    child: const Text('Avançar'),
                  ),
                  FlatButton(
                    onPressed: (){
                      showDialog(context: context,
                          builder: (_) => ExportAddressDialog(order.address)
                      );
                    },
                    textColor: Colors.amber,
                    child: const Text('Endereço'),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}