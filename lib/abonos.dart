import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'comum/widgets/menu_scaffold.dart';
import 'login.dart';

class Abonos extends StatefulWidget {
  static String rota = '/abonos';
  static String titulo = 'Pedidos de abonos';
  @override
  _AbonosState createState() => new _AbonosState();
}

class _AbonosState extends State<Abonos> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _checaUsuarioDeslogado();
  }

  void _checaUsuarioDeslogado() async {
    var box = await Hive.openBox('myBox');
    var token = box.get('token');
    if (token == null) {
      Navigator.of(context).pushNamed(Login.rota);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MenuScaffold(
      key: scaffoldKey,
      pageTitle: Abonos.titulo,
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 350,
          ),
          child: new Text("TELA DE ABONOS"),
        ),
      ),
    );
  }
}
