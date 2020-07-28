
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suburbiodelivery/src/AdmimUsersScreen.dart';
import 'package:suburbiodelivery/src/AdminOrdersManager.dart';
import 'package:suburbiodelivery/src/AdminOrdersScreen.dart';
import 'package:suburbiodelivery/src/address_screen.dart';
import 'package:suburbiodelivery/src/admimUsersManager.dart';

import 'package:suburbiodelivery/src/cart_screen.dart';
import 'package:suburbiodelivery/src/cep_aberto.dart';
import 'package:suburbiodelivery/src/checkout_screen.dart';
import 'package:suburbiodelivery/src/confirmation_screen.dart';
import 'package:suburbiodelivery/src/editproductscreen.dart';
import 'package:suburbiodelivery/src/home.dart';

import 'package:suburbiodelivery/src/order_screen.dart';
import 'package:suburbiodelivery/src/orders_manager.dart';


import 'package:suburbiodelivery/src/productor_manager.dart';
import 'package:suburbiodelivery/src/products.dart';
import 'package:suburbiodelivery/src/register.dart';
import 'package:suburbiodelivery/src/teladeproduto.dart';
import 'package:suburbiodelivery/src/user_manager.dart';

import 'fazerpedido.dart';
import 'src/cart_manager.dart';




void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);

  };
  runApp(MyApp());

  CepAbertoService().getAddressFromCep('048-21-160');
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return
      ChangeNotifierProvider(
        create: (_) => UserManager(),
        child: ChangeNotifierProvider(
            create: (_) => ProductManager(),
            lazy: false,
            child: ChangeNotifierProxyProvider<UserManager, CartManager>(
                create: (_) => CartManager(),
                lazy: false,
                update: (_, userManager, cartManager) =>
                    cartManager..updateUser(userManager),

                    child:  ChangeNotifierProxyProvider<UserManager, OrdersManager>(
                      create: (_) => OrdersManager(),
                      lazy: false,
                      update: (_, userManager, ordersManager) =>
                      ordersManager..updateUser(userManager.user),


                      child:(
                      ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
                      create: (_) => AdminUsersManager(),
                      lazy: false,
                      update: (_, userManager, adminUsersManager) =>
                      adminUsersManager..updateUser(userManager),
                             child:(

                      ChangeNotifierProxyProvider<UserManager, AdminOrdersManager>(
                      create: (_) => AdminOrdersManager(),
                      lazy: false,
                      update: (_, userManager, adminOrdersManager) =>
                      adminOrdersManager..updateAdmin(
                        adminEnabled: userManager.adminEnabled
                      ),
                                               child:(


                             (MaterialApp(
                      theme: ThemeData(brightness: Brightness.dark),
                      routes: {
                        '/home': (context) => HomePage(),
                        '/register': (context) => CadastroPage(),
                        '/fazerpedido': (context) => FazerPedido(),

                      },
                      // ignore: missing_return
                      onGenerateRoute: (settings) {
                        switch (settings.name) {
                          case '/teladeproduto':
                            return MaterialPageRoute(
                                builder: (_) => ProductScreen(
                                    settings.arguments as Products));
                          case '/cart_screen':
                            return MaterialPageRoute(
                                builder: (_) => CartScreen(),
                            settings: settings);
                          case '/address':
                            return MaterialPageRoute(
                                builder: (_) => AddressScreen());

                          case '/confirmation_screen':
                            return MaterialPageRoute(
                                builder: (_) => Confirmation(
                                    ));

                          case '/checkout':
                            return MaterialPageRoute(
                              builder: (_) => CheckoutScreen(),
                            );
                          case '/order_screen':
                            return MaterialPageRoute(
                              builder: (_) => OrdersScreen(),
                            );
                          case '/AdmimUsersScreen':
                            return MaterialPageRoute(
                              builder: (_) => AdminUsersScreen(),
                            );
                          case '/AdminOrdersScreen':
                          return MaterialPageRoute(
                            builder: (_) => AdminOrdersScreen(),
                          );
                          case '/editproductscreen':
                            return MaterialPageRoute(
                              builder: (_) => EditProductScreen(settings as Products),
                            );


                        }
                      },
                      initialRoute: '/home',
                    ))),
    )) )
    )))));
  }
}
