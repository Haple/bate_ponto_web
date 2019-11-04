import 'package:bate_ponto_web/comum/widgets/app_route_observer.dart';
import 'package:bate_ponto_web/empregados.dart';
import 'package:flutter/material.dart';
import 'abonos.dart';
import 'login.dart';
import 'cadastro_empresa.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final rotas = <String, WidgetBuilder>{
    Login.rota: (context) => Login(),
    CadastroEmpresa.rota: (context) => CadastroEmpresa(),
    Empregados.rota: (context) => Empregados(),
    Abonos.rota: (context) => Abonos(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        backgroundColor: Colors.white,
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Arial',
      ),
      home: Login(),
      navigatorObservers: [AppRouteObserver()],
      initialRoute: Login.rota,
      routes: rotas,
      title: 'Bate Ponto',
    );
  }
}
