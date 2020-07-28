
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:suburbiodelivery/src/user.dart';

import 'user_manager.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPage createState() => _CadastroPage();
}

class _CadastroPage extends State<CadastroPage> {

  final _formKey = GlobalKey<FormState>();

  final User user = User();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController emailController1 = TextEditingController();
  final TextEditingController passController1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var textFormField = Container(
        margin: EdgeInsets.all(10),
        child: TextFormField(
            controller: passController1,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Cadastre sua Senha',
              hintStyle: TextStyle(color: Colors.white, fontSize: 20),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white, width: 3)),
              suffixIcon: Icon(Icons.vpn_key),
            ),
            validator: (value) {
              if (value.length < 8) return ('Senha muito Curta');
              return null;
            },
          onSaved: (password) => user.password = password,
         ));
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Suburbio Carioca'),
          leading: new Icon(Icons.fastfood),
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/hmb.jpg'),
              fit: BoxFit.cover,
            )),
            child: (Form(
              key: _formKey,
              child: ListView(children: <Widget>[
                Container(
                  width: 50,
                  height: 20,
                ),
                ListTile(
                  title: Text(
                    'Cadastre-se',
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
                    margin: EdgeInsets.all(10),
                    child: TextFormField(
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'Qual seu nome?',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 3)),
                          suffixIcon: Icon(Icons.person),
                        ),

                        // ignore: missing_return
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Preencha os campos';
                          }
                          return null;
                        },
                        onSaved:(name) => user.name = name)),
                Container(
                    margin: EdgeInsets.all(10),
                    child: TextFormField(
                        controller: emailController1,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'Qual seu E-mail?',
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 20),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 3)),
                          suffixIcon: Icon(Icons.mail),
                        ),

                        // ignore: missing_return
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Preencha os campos';
                          }
                          return null;
                        },
                        onSaved: (email) => user.email = email)),
                textFormField,
                Container(
                    margin: EdgeInsets.only(left: 80, right: 80),
                    padding: EdgeInsets.all(10),
                    child: (RaisedButton(
                      child: Text(
                        'Registrar-se',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                        }
                        context.read<UserManager>().signUp(
                            user: user,
                            onFail: (e) {
                              scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text('Falha ao Cadastrar: $e'),
                                backgroundColor: Colors.red,
                              ));
                            },
                            onSuccess: () {
                              Navigator.pushNamed(context, '/fazerpedido');
                            });
                      },
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ))),
                FlatButton(
                    child: Text("Volte para fazer login",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    })
              ]),
            ))));
  }
}
