import 'dart:js';

import 'package:flutter/material.dart';
import 'login.dart';
import 'cadastro_empresa.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    Login.tag: (context) => Login(),
    CadastroEmpresa.tag: (context) => CadastroEmpresa(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bate Ponto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.white,
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Arial',
      ),
      home: Login(),
      routes: routes,
    );
  }
}
