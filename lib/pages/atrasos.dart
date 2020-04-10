import 'package:bate_ponto_web/modelos/atraso.dart';
import 'package:bate_ponto_web/widgets/cartao_atraso.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../widgets/menu_scaffold.dart';
import '../funcoes/get_token.dart';

class Atrasos extends StatefulWidget {
  static String rota = '/atrasos';
  static String titulo = 'Atrasos';

  @override
  AtrasosState createState() => new AtrasosState();
}

class AtrasosState extends State<Atrasos> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _dataInicial = TextEditingController();
  final TextEditingController _dataFinal = TextEditingController();

  var dataInicial = "";
  var dataFinal = "";

  @override
  void initState() {
    super.initState();
  }

  Future<List<Atraso>> buscaAtrasos({dataInicial, dataFinal}) async {
    final token = await getToken();
    // final baseUrl = "https://bate-ponto-backend.herokuapp.com";
    final baseUrl = "https://5e8fbe83fe7f2a00165ef56d.mockapi.io/bate-ponto/api/v1";
    final url =
        "$baseUrl/atrasos?dataInicial=$dataInicial&dataFinal=$dataFinal";

    Map<String, String> headers = {
      // 'Authorization': token,
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return atrasosFromJson(response.body);
    } else {
      throw new Exception("Não foi possível buscar os atrasos");
    }
  }

  @override
  Widget build(BuildContext context) {
    final pesquisa = SizedBox(
      width: 700,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            width: 100,
            child: TextField(
              controller: _dataInicial,
              decoration: InputDecoration(
                hintText: "Data Inicial",
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: TextField(
              controller: _dataFinal,
              decoration: InputDecoration(
                hintText: "Data Final",
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: FlatButton(
              child: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  this.dataInicial = _dataInicial.text;
                  this.dataFinal = _dataFinal.text;
                });
              },
            ),
          )
        ],
      ),
    );

    return MenuScaffold(
      key: scaffoldKey,
      pageTitle: Atrasos.titulo,
      body: SafeArea(
        child: FutureBuilder(
          future: buscaAtrasos(
              dataInicial: this.dataInicial, dataFinal: this.dataFinal),
          builder:
              (BuildContext context, AsyncSnapshot<List<Atraso>> snapshot) {
            if (snapshot == null || snapshot.hasError) {
              return Center(
                child: Text("Não foi possível buscar os atrasos"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              List<Atraso> atrasos = snapshot.data;
              Widget lista = _buildListaAtrasos(atrasos);
              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                child: Column(
                  children: <Widget>[
                    pesquisa,
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
          },
        ),
      ),
    );
  }

  Widget _buildListaAtrasos(List<Atraso> atrasos) {
    return Center(
      child: Container(
        alignment: Alignment.centerRight,
        constraints: BoxConstraints(
          maxWidth: 800,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListView.builder(
            itemBuilder: (context, index) {
              Atraso atraso = atrasos[index];
              atraso.dataHoraAtraso = new DateFormat("dd/MM/yyyy HH'h'mm")
                  .format(DateTime.parse(atraso.dataHoraAtraso));
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CartaoAtraso(
                  atraso: atraso,
                ),
              );
            },
            itemCount: atrasos.length,
          ),
        ),
      ),
    );
  }
}
