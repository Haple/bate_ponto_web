import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'comum/widgets/menu_scaffold.dart';
import 'login.dart';

class Empregados extends StatefulWidget {
  static String rota = '/empregados';
  static String titulo = 'Empregados';

  @override
  _EmpregadosState createState() => new _EmpregadosState();
}

class _EmpregadosState extends State<Empregados> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  _EmpregadosState(){
    _checaUsuarioDeslogado();
  }

  @override
  void initState() {
    super.initState();
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
      pageTitle: Empregados.titulo,
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 350,
          ),
          child: new Text("TELA DE EMPREGADOS"),
        ),
      ),
    );
  }
}
