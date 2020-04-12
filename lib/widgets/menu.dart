import 'package:bate_ponto_web/pages/indicadores.dart';
import 'package:bate_ponto_web/pages/relatorios.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../funcoes/get_token.dart';
import '../pages/abonos.dart';
import '../pages/atrasos.dart';
import '../pages/empregados.dart';
import '../pages/login.dart';
import 'app_route_observer.dart';

class Menu extends StatefulWidget {
  const Menu({@required this.permanentlyDisplay, Key key}) : super(key: key);

  final bool permanentlyDisplay;

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> with RouteAware {
  String _rotaSelecionada;
  AppRouteObserver _routeObserver;

  @override
  void initState() {
    super.initState();
    _buscaToken();
    _routeObserver = AppRouteObserver();
  }

  void _buscaToken() async {
    if ((await getToken()) == null) {
      await _navigateTo(context, Login.rota);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    _routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _updateSelectedRoute();
  }

  @override
  void didPop() {
    _updateSelectedRoute();
  }

  @override
  Widget build(BuildContext context) {
    final logo = Image(
      image: AssetImage("assets/logo.png"),
      height: 100,
    );

    Widget _buildItemMenu(IconData icone, String titulo, String rota) {
      return ListTile(
        leading: Icon(icone),
        title: Text(titulo),
        onTap: () async {
          await _navigateTo(context, rota);
        },
        selected: _rotaSelecionada == rota,
      );
    }

    return Drawer(
      child: Row(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              // padding: EdgeInsets.all(10),
              children: [
                logo,
                _buildItemMenu(
                    Icons.people, Empregados.titulo, Empregados.rota),
                _buildItemMenu(
                    Icons.question_answer, Abonos.titulo, Abonos.rota),
                _buildItemMenu(Icons.trending_up, Indicadores.titulo, Indicadores.rota),
                _buildItemMenu(Icons.alarm, Atrasos.titulo, Atrasos.rota),
                _buildItemMenu(Icons.assignment, Relatorios.titulo, Relatorios.rota),
                const Divider(),
                ListTile(
                    leading: const Icon(Icons.power_settings_new),
                    title: Text("Sair"),
                    onTap: () async {
                      var box = await Hive.openBox('myBox');
                      box.delete('token');
                      await _navigateTo(context, Login.rota);
                    }),
              ],
            ),
          ),
          if (widget.permanentlyDisplay)
            const VerticalDivider(
              width: 1,
            )
        ],
      ),
    );
  }

  Future<void> _navigateTo(BuildContext context, String rota) async {
    if (widget.permanentlyDisplay) {
      Navigator.pop(context);
    }
    await Navigator.pushReplacementNamed(context, rota);
  }

  void _updateSelectedRoute() {
    setState(() {
      _rotaSelecionada = ModalRoute.of(context).settings.name;
    });
  }
}
