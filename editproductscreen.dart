
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suburbiodelivery/src/pagamentos_form.dart';
import 'package:suburbiodelivery/src/products.dart';
import 'images_form.dart';

class EditProductScreen extends StatelessWidget {
  EditProductScreen(Products p) :
        editing = p != null,
        product = p != null ? p.clone() : Products();

  final Products product;
  final bool editing;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          title: Text(editing ? 'Editar Produto' : 'Criar Produto'),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              ImagesForm(product),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      initialValue: product.name,
                      decoration: const InputDecoration(
                        hintText: 'Título',
                        border: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      validator: (name) {
                        if (name.length < 6) return 'Título muito curto';
                        return null;
                      },
                      onSaved: (name) => product.name = name,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'A partir de',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      'R\$ ${product.price.toString()}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Descrição',
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    TextFormField(
                      initialValue: product.description,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                          hintText: 'Descrição', border: InputBorder.none),
                      maxLines: null,
                      validator: (desc) {
                        if (desc.length < 10) return 'Descrição muito curta';
                        return null;
                      },
                      onSaved: (desc) => product.description = desc,

                    ),
                    PagamentosForm(product),
                const SizedBox(height: 20,),
                SizedBox(
                  height: 44,
                  child:   Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextFormField(
                          initialValue: product.name,
                          decoration: const InputDecoration(
                            hintText: 'Título',
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600
                          ),
                          validator: (name){
                            if(name.length < 6)
                              return 'Título muito curto';
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'A partir de',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Text(
                          'R\$ ...',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            'Descrição',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        TextFormField(
                          initialValue: product.description,
                          style: const TextStyle(
                              fontSize: 16
                          ),
                          decoration: const InputDecoration(
                              hintText: 'Descrição',
                              border: InputBorder.none
                          ),
                          maxLines: null,
                          validator: (desc){
                            if(desc.length < 10)
                              return 'Descrição muito curta';
                            return null;
                          },
                        ),
                        RaisedButton(
                          onPressed: (){
                            if(formKey.currentState.validate()){
                              formKey.currentState.save();

                              product.save();
                            }
                          },
                          child: const Text('Salvar'),
                        ),
                      ],
                    ),
                  )
                )],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
