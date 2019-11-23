import 'package:bate_ponto_web/comum/funcoes/get_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'comum/modelos/abono.dart';
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

    Future<List<Abono>> _buscaAbonos() async {
    final url = "https://bate-ponto-backend.herokuapp.com/abonos?buscarTudo=true";

    Map<String, String> headers = {
      'Authorization': await getToken(),
    };
    final response = await http.get(url, headers: headers);
    print(response.body);
    if (response.statusCode == 200) {
      return abonosFromJson(response.body);
    } else {
      throw new Exception("Não foi possível buscar os abonos");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MenuScaffold(
        key: scaffoldKey,
        pageTitle: Abonos.titulo,
        body: SafeArea(
          child: FutureBuilder(
            future: _buscaAbonos(),
            builder:
              (BuildContext context, AsyncSnapshot<List<Abono>> snapshot) {
            if (snapshot == null || snapshot.hasError) {
              return Center(
                child: Text("Não foi possível buscar os abonos"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              List<Abono> abonos = snapshot.data;
              Widget lista = _buildListaAbonos(abonos);
              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: lista,
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ));
  }
}

Widget _buildListaAbonos(List<Abono> abonos) {
  return Center(
    child: Container(
      constraints: BoxConstraints(
        maxWidth: 350,
      ),
      child: new Text(abonos.toString()),
    ),
  );
}
