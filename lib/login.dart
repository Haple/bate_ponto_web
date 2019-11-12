import 'dart:convert';
import 'package:bate_ponto_web/comum/funcoes/parse_jwt.dart';
import 'package:flutter/material.dart';
import 'package:bate_ponto_web/empregados.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'comum/funcoes/exibe_alerta.dart';
import 'comum/widgets/email.dart';
import 'comum/widgets/senha.dart';
import 'cadastro_empresa.dart';

class Login extends StatefulWidget {
  static String rota = '/login';
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _senha = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checaUsuarioLogado();
  }

  void _checaUsuarioLogado() async {
    var box = await Hive.openBox('myBox');
    var token = box.get('token');
    if (token != null) {
      Navigator.of(context).pushNamed(Empregados.rota);
    }
  }

  void _entrar() async {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      _login();
    }
  }

  void _login() async {
    final url = "https://bate-ponto-backend.herokuapp.com/sessoes";

    Map<String, String> body = {
      'email': _email.text,
      'senha': _senha.text,
    };

    final response = await http.post(
      url,
      body: body,
    );
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      var token = responseJson["token"];
      var payload = parseJwt(token);
      if (payload["admin"] == true) {
        var box = await Hive.openBox('myBox');
        box.put('token', token);
        Navigator.of(context).popAndPushNamed(Empregados.rota);
        return;
      }
    }
    exibeAlerta(
      contexto: context,
      titulo: "Opa",
      mensagem: "Credenciais inválidas",
      labelBotao: "Tentar novamente",
    );
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
      onPressed: _entrar,
    );

    final labelCadastrar = FlatButton(
      child: Text(
        'Ainda não é cadastrado?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(CadastroEmpresa.rota);
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
