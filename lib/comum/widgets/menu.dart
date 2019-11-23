import 'package:bate_ponto_web/abonos.dart';
import 'package:bate_ponto_web/comum/funcoes/get_token.dart';
import 'package:bate_ponto_web/empregados.dart';
import 'package:bate_ponto_web/login.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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

    return Drawer(
      child: Row(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              // padding: EdgeInsets.all(10),
              children: [
                logo,
                ListTile(
                  leading: const Icon(Icons.people),
                  title: Text(Empregados.titulo),
                  onTap: () async {
                    await _navigateTo(context, Empregados.rota);
                  },
                  selected: _rotaSelecionada == Empregados.rota,
                ),
                ListTile(
                  leading: const Icon(Icons.question_answer),
                  title: Text(Abonos.titulo),
                  onTap: () async {
                    await _navigateTo(context, Abonos.rota);
                  },
                  selected: _rotaSelecionada == Abonos.rota,
                ),
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
