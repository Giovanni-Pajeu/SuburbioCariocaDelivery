
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suburbiodelivery/src/productor_manager.dart';
import 'package:suburbiodelivery/src/products.dart';
import 'package:suburbiodelivery/src/products_screen.dart';
import 'package:suburbiodelivery/src/user_manager.dart';


class FazerPedido extends StatefulWidget {
  @override
  _FazerPedido createState() => _FazerPedido();
}

class _FazerPedido extends State<FazerPedido> {

  Products product;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Consumer<UserManager>(builder: (_, userManager, __) {
        if (userManager.adminEnabled) {
          return Drawer(
            child: ListView(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.pages),
                    title: FlatButton(
                      child: Text('Meus Pedidos'),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/order_screen');
                      },

                    )),

                ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/cart_screen');
                    },
                    child: Text("Meu Carrinho"),
                  ),
                ),
                ListTile(

                  leading: Icon(Icons.view_list),
                  title: FlatButton(onPressed: (){
                    Navigator.of(context).pushNamed('/AdminOrdersScreen');
                  },
                    child: Text('Todos os Pedidos', style:
                    TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold,
                        color: Colors.amber
                    ),),)
                  ,
                ),
                ListTile(

                    leading: Icon(Icons.supervised_user_circle),
                    title: FlatButton(onPressed: (){
                      Navigator.of(context).pushNamed('/AdmimUsersScreen');
                    },
                      child: Text('Clientes Cadastrados',
                          style:
                          TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold,
                              color: Colors.amber
                          )),)
                )




              ],
            ),
          );
        } else {
          return ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.shopping_cart),
                title: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/cart_screen');
                  },
                  child: Text("Meu Carrinho"),
                ),
              ),
              ListTile(
                  leading: Icon(Icons.pages),
                  title: FlatButton(
                    child: Text('Meus Pedidos'),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/order_screen');
                    },

                  ))
            ],
          );
        }
      }),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Cardapio'),
      ),
      body: Consumer<ProductManager>(builder: (_, productManager, __) {
        return ListView.builder(
          padding: EdgeInsets.all(6),
          itemCount: productManager.allProducts.length,
          itemBuilder: (_, index) {
            return ProductListTile(productManager.allProducts[index]);
          },
        );
      }),
    );
  }
}
