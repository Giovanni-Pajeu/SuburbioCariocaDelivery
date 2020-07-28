
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:provider/provider.dart';
import 'package:suburbiodelivery/src/user.dart';

import 'user_manager.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: unused_field
  final _firebase = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        leading: Icon(
          Icons.fastfood,
          size: 30,
        ),
        title: new Text(
          'Suburbio Carioca',
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
          child: (Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/hmb.jpg'),
          fit: BoxFit.cover,
        )),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
              ),
              ListTile(
                title: Text(
                  'Bem vindo ao Suburbio Carioca',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                subtitle: Image.asset(
                  'assets/foto.png',
                  width: 100,
                  height: 100,
                ),
              ),
              Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(10),
                  child: (TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: 'Digite seu E-mail',
                        hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                        suffixIcon: Icon(Icons.fastfood),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.white, width: 3))),
                    // ignore: missing_return
                    validator: (value) {
                      if (value.isEmpty) return ('Preencha o E-mail');
                    },
                  ))),
              Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: passController,
                    decoration: InputDecoration(
                        hintText: 'Senha',
                        hintStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.white, width: 3)),
                        suffixIcon: Icon(Icons.vpn_key)),
                    // ignore: missing_return
                    validator: (value) {
                      if (value.length < 6) return ('Senha Incorreta');
                    },
                    obscureText: true,
                  )),
              Container(
                margin: EdgeInsets.only(left: 70, right: 70),
                padding: EdgeInsets.all(10),
                child: RaisedButton(
                  child: Text(
                    'Entre na sua Conta',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      context.read<UserManager>().signIn(
                          user: User(
                              email: emailController.text,
                              password: passController.text),
                          onFail: (e) {
                            scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text('Falha ao entrar: $e'),
                              backgroundColor: Colors.red,
                            ));
                          },
                          onSuccess: () {
                            Navigator.pushNamed(context, '/fazerpedido');
                          });
                    }
                  },
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 80, right: 80),
                  child: (SignInButton(
                    Buttons.Facebook,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    text: 'Entre com o FaceBook',
                    onPressed: () {},
                  ))),
              Container(
                child: FlatButton(
                  child: Text(
                    'Não tem conta? Cadastre-se aqui',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                ),
              )
            ],
          ),
        ),
      ))),
    );
  }
}
