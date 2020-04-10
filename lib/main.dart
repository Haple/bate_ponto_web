import 'pages/atrasos.dart';
import 'widgets/app_route_observer.dart';
import 'pages/empregados.dart';
import 'package:flutter/material.dart';
import 'pages/abonos.dart';
import 'pages/login.dart';
import 'pages/cadastro_empresa.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final rotas = <String, WidgetBuilder>{
    Login.rota: (context) => Login(),
    CadastroEmpresa.rota: (context) => CadastroEmpresa(),
    Empregados.rota: (context) => Empregados(),
    Abonos.rota: (context) => Abonos(),
    Atrasos.rota: (context) => Atrasos(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
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
