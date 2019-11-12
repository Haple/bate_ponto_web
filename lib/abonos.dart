import 'package:flutter/material.dart';

import 'comum/widgets/menu_scaffold.dart';

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
