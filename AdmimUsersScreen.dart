import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:suburbiodelivery/src/AdminOrdersManager.dart';
import 'package:suburbiodelivery/src/admimUsersManager.dart';
import 'package:suburbiodelivery/src/paga_manager.dart';

class AdminUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários'),
        centerTitle: true,
      ),
      body: Consumer<AdminUsersManager>(
        builder: (_, adminUsersManager, __){
          return AlphabetListScrollView(
            itemBuilder: (_, index){
              return ListTile(
                title: Text(
                  adminUsersManager.users[index].name,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white
                  ),
                ),
                subtitle: Text(
                  adminUsersManager.users[index].email,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: (){
                  context.read<AdminOrdersManager>().setUserFilter(
                      adminUsersManager.users[index]
                  );
                  context.read<PageManager>().setPage(5);
                },

              );
            },
            highlightTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 20
            ),
            indexedHeight: (index) => 80,
            strList: adminUsersManager.names,
            showPreview: true,
          );
        },
      ),
    );
  }
}