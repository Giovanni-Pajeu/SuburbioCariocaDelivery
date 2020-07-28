import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'itempagamentos.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class Products extends ChangeNotifier {
  Products(
      {this.id,

        this.name,
        this.description,
        this.images,
        this.pagamentos,
        this.deleted = false}) {
    images = images ?? [];
    pagamentos = pagamentos ?? [];
  }


  Products.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    pricefixe = document['pricefixe'] as num;
    name = document['name'] as String;
    description = document['description'] as String;
    images = List<String>.from(document.data['images'] as List<dynamic>);
    deleted = (document.data['deleted'] ?? false) as bool;
    pagamentos = (document.data['pagamentos'] as List<dynamic>).map(
            (p) => ItemPagamentos.fromMap(p as Map<String, dynamic>)).toList();
  }


  String id;
  num price;
  num pricefixe;
  String name;
  String description;
  List<String> images;
  List<ItemPagamentos> pagamentos;
  List<dynamic> newImages;
  bool deleted;


  ItemPagamentos _selectedPagamentos;
  ItemPagamentos get selectedPagamentos => _selectedPagamentos;
  set selectedPagamentos(ItemPagamentos value) {
    _selectedPagamentos = value;
    notifyListeners();
  }

  num get basePrice {
    num lowest = double.infinity;
    for (final pagamentos in pagamentos) {
      if (pagamentos.price < lowest && pagamentos.hasStock)
        lowest = pagamentos.price;
    }
    return lowest;
  }

  int get totalStock {
    int stock = 0;
    for (final pagamento in pagamentos) {
      stock += pagamento.stock;
    }
    return stock;
  }

  bool get hasStock {
    return totalStock > 0 && deleted;
  }

  ItemPagamentos findPagamentos(String name) {
    try {
      return pagamentos.firstWhere((p) => p.name == name);
    } catch (e) {
      return null;
    }
  }
  List<Map<String, dynamic>> exportPagamentosList(){
    return pagamentos.map((size) => size.toMap()).toList();
  }


  // TODO NOVO

  DocumentReference get firestoreRef => firestore.document('products/$id');
  StorageReference get storageRef => storage.ref().child('products').child(id);
  final Firestore firestore = Firestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  Future<void> save() async {


    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'pagamentos': exportPagamentosList,
      'deleted': deleted

    };

    if(id == null){
      final doc = await firestore.collection('products').add(data);
      id = doc.documentID;
    } else {
      await firestoreRef.updateData(data);
    }

    final List<String> updateImages = [];

    for(final newImage in newImages){
      if(images.contains(newImage)){
        updateImages.add(newImage as String);
      } else {
        final StorageUploadTask task = storageRef.child(Uuid().v1()).putFile(newImage as File);
        final StorageTaskSnapshot snapshot = await task.onComplete;
        final String url = await snapshot.ref.getDownloadURL() as String;
        updateImages.add(url);
      }
    }

    for(final image in images){
      if(!newImages.contains(image) && image.contains('firebase')){
        try {
          final ref = await storage.getReferenceFromUrl(image);
          await ref.delete();
        } catch (e){
          debugPrint('Falha ao deletar $image');
        }
      }
    }

    await firestoreRef.updateData({'images': updateImages});

    images = updateImages;

  }

  void delete(){
    firestoreRef.updateData({'deleted': true});
  }

  Products clone(){
    return Products(
      id: id,
      name: name,
      description: description,
      images: List.from(images),
      pagamentos: pagamentos.map((size) => size.clone()).toList(),
      deleted: deleted,
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, description: $description, images: $images, pagamentos: $pagamentos, newImages: $newImages}';
  }
}





