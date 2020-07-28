


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:suburbiodelivery/src/cart_manager.dart';
import 'package:suburbiodelivery/src/order.dart';
import 'package:suburbiodelivery/src/products.dart';

class CheckoutManager extends ChangeNotifier {

CartManager cartManager;
bool _loading = false;
bool get loading => _loading;
set loading(bool value){
  _loading = value;
  notifyListeners();
}

final Firestore firestore = Firestore.instance;
// ignore: use_setters_to_change_properties
void updateCart(CartManager cartManager){
  this.cartManager = cartManager;
}
  Future<void> checkout() async {


    // TODO: PROCESSAR PAGAMENTO

    final orderId = await _getOrderId();

    final order = Order.fromCartManager(cartManager);
    order.orderId = orderId.toString();

    await order.save();

  }


  Future<int> _getOrderId() async {
    final ref = firestore.document('aux/ordercounter');

try {
  final result = await firestore.runTransaction((tx) async {
    final doc = await tx.get(ref);
    final orderId = doc.data['current'] as int;
    await tx.update(ref, {'current': orderId + 1});
    return {'orderId': orderId};
  });
  return result['orderId'] as int;
} catch(e) {
  debugPrint(e.toString());
  return Future.error('Falha ao Gerar Pedido');

}
  }
      // ignore: unused_element
      Future<void> _decrementStock(){

   return firestore.runTransaction((tx) async{
      final List<Products> productsToUpdate = [];
      final List<Products> productsWithOutStock = [];

      for(final cartProduct in cartManager.items){
        Products product;
        if(productsToUpdate.any((p) => p.id == cartProduct.productId)){
          product = productsToUpdate.firstWhere((p) => p.id == cartProduct.productId);
        } else  {
           // ignore: unused_local_variable
           final doc = await tx.get(
             firestore.document('products/${cartProduct.productId}')
           );

        }
        final pagamentos = product.findPagamentos(cartProduct.pagamento);
        if(pagamentos.stock - cartProduct.quantity <0){
          //FALAHAR
          productsWithOutStock.add(product);
        } else{
          pagamentos.stock -= cartProduct.quantity;
          productsToUpdate.add(product);
        }

      }


      if(productsWithOutStock.isNotEmpty){
        return Future.error('${productsWithOutStock.length} produtos sem estoque');
      }
                for(final product in productsToUpdate){
                  tx.update(firestore.document('products/${product.id}'),
                  {'pagamentos': product.exportPagamentosList()});
                }
    });

       }



}