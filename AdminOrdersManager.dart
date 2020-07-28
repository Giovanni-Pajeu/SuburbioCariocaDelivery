import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:suburbiodelivery/src/order.dart';
import 'package:suburbiodelivery/src/user.dart';


class AdminOrdersManager extends ChangeNotifier {

  final List<Order> _orders = [];

  User userFilter;
  List<Status> statusFilter = [Status.preparing];

  final Firestore firestore = Firestore.instance;

  StreamSubscription _subscription;

  void updateAdmin({bool adminEnabled}){
    _orders.clear();

    _subscription?.cancel();
    if(adminEnabled){
      _listenToOrders();
    }
  }

  void _listenToOrders(){
    _subscription = firestore.collection('orders').snapshots().listen(
            (event) {
          _orders.clear();
          for(final doc in event.documents){
            _orders.add(Order.fromDocument(doc));
          }
          notifyListeners();

        });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  List<Order> get filteredOrders {
    List<Order> output = _orders.reversed.toList();

    if(userFilter != null){
      output = output.where((o) => o.userId == userFilter.id).toList();
    }

    return output.where((o) => statusFilter.contains(o.status)).toList();
  }
  void setUserFilter(User user){
    userFilter = user;
    notifyListeners();
  }

  void setStatusFilter({Status status, bool enabled}){
    if(enabled){
      statusFilter.add(status);
    } else {
      statusFilter.remove(status);
    }
    notifyListeners();
  }


}