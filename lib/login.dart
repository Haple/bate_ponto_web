import 'package:bate_ponto_web/comum/email.dart';
import 'package:bate_ponto_web/comum/senha.dart';
import 'package:flutter/material.dart';
import 'cadastro_empresa.dart';

class Login extends StatefulWidget {
  static String tag = 'login';
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _senha = TextEditingController();

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      performLogin();
    }
  }

  void performLogin() {
    final snackbar = new SnackBar(
      content: new Text("Email : ${_email.text}, password : ${_senha.text}"),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'logo',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 80.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    var botaoEntrar = new RaisedButton(
      child: new Text(
        "Entrar",
        style: new TextStyle(color: Colors.white),
      ),
      color: Colors.blue,
      onPressed: _submit,
    );

    final labelCadastrar = FlatButton(
      child: Text(
        'Ainda não é cadastrado?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(CadastroEmpresa.tag);
      },
    );

    var formulario = new Form(
      key: formKey,
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        children: <Widget>[
          logo,
          SizedBox(height: 48.0),
          new Email(controller: _email),
          SizedBox(height: 8.0),
          new Senha(controller: _senha),
          SizedBox(height: 24.0),
          botaoEntrar,
          labelCadastrar,
        ],
      ),
    );

    return Scaffold(
      key: scaffoldKey,
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 350,
          ),
          child: formulario,
        ),
      ),
    );
  }
}
