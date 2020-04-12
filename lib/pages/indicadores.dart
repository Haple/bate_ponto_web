import 'dart:convert';

import 'package:bate_ponto_web/modelos/atraso.dart';
import 'package:bate_ponto_web/modelos/indicador.dart';
import 'package:bate_ponto_web/widgets/cartao_atraso.dart';
import 'package:bate_ponto_web/widgets/cartao_indicador.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/menu_scaffold.dart';
import '../funcoes/get_token.dart';

class Indicadores extends StatefulWidget {
  static String rota = '/indicadores';
  static String titulo = 'Indicadores';

  @override
  IndicadoresState createState() => new IndicadoresState();
}

class IndicadoresState extends State<Indicadores> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  Future<List<Indicador>> _buscaIndicadores() async {
    final token = await getToken();
    // final baseUrl = "https://bate-ponto-backend.herokuapp.com";
    final baseUrl =
        "https://5e8fbe83fe7f2a00165ef56d.mockapi.io/bate-ponto/api/v1";
    final url = "$baseUrl/indicadores";

    Map<String, String> headers = {
      // 'Authorization': token,
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return indicadoresFromJson(Utf8Decoder().convert(response.bodyBytes));
    } else {
      throw new Exception("Não foi possível buscar os indicadores");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MenuScaffold(
      key: scaffoldKey,
      pageTitle: Indicadores.titulo,
      body: SafeArea(
        child: FutureBuilder(
          future: _buscaIndicadores(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Indicador>> snapshot) {
            if (snapshot == null || snapshot.hasError) {
              print("ERRO: " + snapshot.toString());
              return Center(
                child: Text("Não foi possível buscar os indicadores"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              List<Indicador> indicadores = snapshot.data;
              Widget lista = _buildListaIndicadores(indicadores);
              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 0.0),
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
          },
        ),
      ),
    );
  }

  Widget _buildListaIndicadores(List<Indicador> indicadores) {
    return Center(
      child: Container(
        alignment: Alignment.centerRight,
        constraints: BoxConstraints(
          maxWidth: 1200,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CartaoIndicador(
                  indicador: indicadores[index],
                ),
              );
            },
            itemCount: indicadores.length,
          ),
        ),
      ),
    );
  }
}
