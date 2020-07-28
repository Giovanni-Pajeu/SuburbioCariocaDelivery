import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:suburbiodelivery/src/AdminOrdersManager.dart';
import 'package:suburbiodelivery/src/custom_icon_button.dart';
import 'package:suburbiodelivery/src/emptyCard.dart';
import 'package:suburbiodelivery/src/order.dart';
import 'package:suburbiodelivery/src/order_tile.dart';

class AdminOrdersScreen extends StatefulWidget {

  @override
  _AdminOrdersScreenState createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final PanelController panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos os Pedidos'),
        centerTitle: true,
      ),
      body: Consumer<AdminOrdersManager>(
        builder: (_, ordersManager, __){
          final filteredOrders = ordersManager.filteredOrders;
          return SlidingUpPanel(
            controller: panelController,
            body: Column(
              children: <Widget>[
                if(ordersManager.userFilter != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Pedidos de ${ordersManager.userFilter.name}',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        CustomIconButton(
                          iconData: Icons.close,
                          color: Colors.white,
                          onTap: (){
                            ordersManager.setUserFilter(null);
                          },
                        )
                      ],
                    ),
                  ),
                if(filteredOrders.isEmpty)
                  Expanded(
                    child: EmptyCard(
                      title: 'Nenhuma venda realizada!',
                      iconData: Icons.border_clear,
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                        itemCount: filteredOrders.length,
                        itemBuilder: (_, index){
                          return OrderTile(
                            filteredOrders[index],
                            showControls: true,
                          );
                        }
                    ),
                  ),
                const SizedBox(height: 120,),
              ],
            ),
            minHeight: 40,
            maxHeight: 250,
            panel: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    if(panelController.isPanelClosed){
                      panelController.open();
                    } else {
                      panelController.close();
                    }
                  },
                  child: Container(
                    height: 10,

                    color: Colors.amber,
                    alignment: Alignment.center,

                  ),
                ),
                Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: Status.values.map((s){
                    return CheckboxListTile(

                      title: Text(Order.getStatusText(s), style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,

                      ),),
                      dense: true,
                      activeColor: Colors.green,
                      value: ordersManager.statusFilter.contains(s),
                      onChanged: (v){
                        ordersManager.setStatusFilter(
                            status: s,
                            enabled: v
                        );

                      },
                    );    }).toList(),
                ),
                ) ],
            ),
          );
        },
      ),
    );
  }
}