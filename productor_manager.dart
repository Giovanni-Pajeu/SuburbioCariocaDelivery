
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:suburbiodelivery/src/products.dart';

class ProductManager extends ChangeNotifier{

  ProductManager() {
    _loadAllProducts();
  }
  final Firestore firestore = Firestore.instance;
  List<Products> allProducts = [];

  Future<void> _loadAllProducts() async {
    final QuerySnapshot snapProducts =
    await firestore.collection('products').getDocuments();
    allProducts =
        snapProducts.documents.map((d) => Products.fromDocument(d)).toList();

    notifyListeners(); }

  String _search = '';

  String get search => _search;
  set search(String value){
    _search = value;
    notifyListeners();
  }

  List<Products> get filteredProducts {
    final List<Products> filteredProducts = [];

    if(search.isEmpty){
      filteredProducts.addAll(allProducts);
    } else {
      filteredProducts.addAll(
          allProducts.where(
                  (p) => p.name.toLowerCase().contains(search.toLowerCase())
          )
      );
    }

    return filteredProducts;
  }


  Products findProductById(String id){
    try {
      return allProducts.firstWhere((p) => p.id == id);
    } catch (e){
      return null;
    }
  }

  void update(Products product){
    allProducts.removeWhere((p) => p.id == product.id);
    allProducts.add(product);
    notifyListeners();
  }

  void delete(Products product){
    product.delete();
    allProducts.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }
}













/*ProductManager() {
    _loadAllProducts();
  }
  final Firestore firestore = Firestore.instance;
  List<Products> allProducts = [];

  Future<void> _loadAllProducts() async {
    final QuerySnapshot snapProducts =
    await firestore.collection('products').getDocuments();
    allProducts =
        snapProducts.documents.map((d) => Products.fromDocument(d)).toList();

    notifyListeners();
  }*/