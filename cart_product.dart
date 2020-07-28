


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:suburbiodelivery/src/itempagamentos.dart';
import 'package:suburbiodelivery/src/products.dart';



class CartProduct extends ChangeNotifier {
  CartProduct.fromProduct(this._product) {
    productId = product.name;
    quantity = 1;
    pagamento = product.selectedPagamentos.name;



  }
  CartProduct.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    name = document.data['name'] as String;
    productId = document.data['productId'] as String;
    quantity = document.data['quantity'] as int;
    pagamento = document.data['pagamento'] as String;
    firestore.document('products/$productId').get().then((doc) {
      product = Products.fromDocument(doc);
    });
  }
  CartProduct.fromMap(Map<String, dynamic> map) {

    productId = map['productId'] as String;
    quantity = map['quantity'] as int;
    pagamento = map['pagamento'] as String;


    fixedPrice = map['fixedPrice'] as num;
    firestore.document('products/$productId').get().then((doc) {
      product = Products.fromDocument(doc);
    });
  }

  final Firestore firestore = Firestore.instance;
  List<String> images;
  num pricefixe;
  String name;
  String id;
  String productId;
  int quantity;
  String pagamento;
  num price;

  num fixedPrice;
  Products _product;
  Products get product => _product;
  set product(Products value) {
    _product = value;
    notifyListeners();
  }

  ItemPagamentos get itemPagamentos {
    if (product == null) return null;
    return product.findPagamentos(pagamento);
  }

  num get unitPrice {
    if (product == null) return 0;
    return itemPagamentos?.price ?? 0;
  }

  num get totalPrice => unitPrice * quantity;

  Map<String, dynamic> toCartItemMap() {
    return {
      'pagamento': pagamento,
      'quantity': quantity,
      'productId': productId,
      'price': totalPrice


    };
  }
  Map<String, dynamic> toOrderItemMap(){
    return {
      'pid': productId,
      'quantity': quantity,
      'pagamentos': pagamento,
      'fixedPrice': fixedPrice ?? unitPrice,
      'price': totalPrice

    };
  }



  bool stackable(Products product) {
    return product.id == productId &&
        product.selectedPagamentos.name == pagamento;
  }

  void increment() {
    quantity++;
    notifyListeners();
  }

  void decrement() {
    quantity--;
    notifyListeners();
  }

  bool get hasStock {
    final pagamento = itemPagamentos;
    if (pagamento == null) return false;
    return pagamento.stock >= quantity;
  }


}
