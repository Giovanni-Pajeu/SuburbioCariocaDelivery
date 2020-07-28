import 'package:flutter/material.dart';
import 'package:suburbiodelivery/src/custom_icon_button.dart';
import 'package:suburbiodelivery/src/edit_item_pagamento.dart';
import 'package:suburbiodelivery/src/itempagamentos.dart';
import 'package:suburbiodelivery/src/products.dart';


class PagamentosForm extends StatelessWidget {

  const PagamentosForm(this.product);

  final Products product;

  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemPagamentos>>(
      initialValue: product.pagamentos,
      validator: (sizes){
        if(sizes.isEmpty)
          return 'Insira um Pagamento';
        return null;
      },
      builder: (state){
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Tamanhos',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                CustomIconButton(
                  iconData: Icons.add,
                  color: Colors.black,
                  onTap: (){
                    state.value.add(ItemPagamentos());
                    state.didChange(state.value);
                  },
                )
              ],
            ),
            Column(
              children: state.value.map((size){
                return EditItemPagamentos(
                  key: ObjectKey(size),
                  pagamentos: size,
                  onRemove: (){
                    state.value.remove(size);
                    state.didChange(state.value);
                  },
                  onMoveUp: size != state.value.first ? (){
                    final index = state.value.indexOf(size);
                    state.value.remove(size);
                    state.value.insert(index-1, size);
                    state.didChange(state.value);
                  } : null,
                  onMoveDown: size != state.value.last ? (){
                    final index = state.value.indexOf(size);
                    state.value.remove(size);
                    state.value.insert(index+1, size);
                    state.didChange(state.value);
                  } : null,
                );
              }).toList(),
            ),
            if(state.hasError)
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}