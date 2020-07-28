
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:suburbiodelivery/src/address.dart';
import 'package:suburbiodelivery/src/cart_manager.dart';
import 'package:suburbiodelivery/src/cart_product.dart';




enum Status { canceled, agurada, preparing, transporting, delivered }

class Order {


   Order.fromDocument(DocumentSnapshot doc){
     orderId = doc.documentID;
     items = (doc.data['items']as List<dynamic>).map((e){
       return CartProduct.fromMap(e as Map<String, dynamic>);
     }).toList();
      price = doc.data['price'] as num;
     userId = doc.data['user'] as String;
     address = Address.fromMap(doc.data['address'] as Map<String, dynamic>);
     date = doc.data['date'] as Timestamp;
     status = Status.values[doc.data['status'] as int];




   }

  Order.fromCartManager(CartManager cartManager ){
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user.id;
    address = cartManager.address;
    status = Status.agurada;


  }

final Firestore firestore = Firestore.instance;
   DocumentReference get firestoreRef =>
       firestore.collection('orders').document(orderId);

   void updateFromDocument(DocumentSnapshot doc){
     status = Status.values[doc.data['status'] as int];
   }

   Future<void> save()async{
     firestore.collection('orders').document(orderId).setData(
         {
           'items': items.map((e) => e.toOrderItemMap()).toList(),
           'price': price,
           'user': userId,
           'address': address.toMap(),
           'status': status.index,
           'date': Timestamp.now(),




         }
     );

   }
   Function() get back {
     return status.index >= Status.transporting.index ?
         (){
       status = Status.values[status.index - 1];
       firestoreRef.updateData({'status': status.index});

     } : null;
   }

   Function() get advance {
     return status.index <= Status.transporting.index ?
         (){
       status = Status.values[status.index + 1];
       firestoreRef.updateData({'status': status.index});

     } : null;
   }

   void cancel(){
     status = Status.canceled;
     firestoreRef.updateData({'status': status.index});
   }
  List<CartProduct> items;

  String name;
  num totalPrice;
  num price;
  String orderId;
  String userId;
  Address address;
  Timestamp date;
  String id;
  String productId;
  int quantity;
  String pagamento;
   Status status;



   @override
   String toString() {
     return 'Order{firestore: $firestore, orderId: $orderId, items: $items, price: $price, userId: $userId, address: $address, date: $date}';
   }

   String get formattedId => '#${orderId.padLeft(6, '0')}';
   String get statusText => getStatusText(status);

   static String getStatusText(Status status) {
     switch(status){
       case Status.canceled:
         return 'Cancelado';
       case Status.preparing:
         return 'Em preparação';
       case Status.transporting:
         return 'Em transporte';
       case Status.delivered:
         return 'Entregue';
       case Status.agurada:
         return 'Pedido em Análise';
       default:
         return '';
     }
   }

}

