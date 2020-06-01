import 'dart:developer';

import 'package:bate_ponto_web/modelos/atraso.dart';
import 'package:bate_ponto_web/widgets/cartao_atraso.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    super.initState();
  }

  Future<List<Atraso>> _buscaAtrasos() async {
    final token = await getToken();
    final baseUrl = "https://bate-ponto-backend.herokuapp.com";
    final url = "$baseUrl/atrasos";

    Map<String, String> headers = {
      'Authorization': token,
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return atrasosFromJson(response.body);
    } else {
      throw new Exception("Não foi possível buscar os atrasos!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MenuScaffold(
      key: scaffoldKey,
      pageTitle: Atrasos.titulo,
      body: SafeArea(
        child: FutureBuilder(
          future: _buscaAtrasos(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Atraso>> snapshot) {
            if (snapshot == null || snapshot.hasError) {
              log("ERRO: " + snapshot.toString());
              print("ERRRRRO: " + snapshot.toString());
              return Center(
                child: Text("Não foi possível buscar os atrasos!"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              List<Atraso> atrasos = snapshot.data;
              Widget lista = _buildListaAtrasos(atrasos);
              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 200.0),
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
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CartaoAtraso(
                  atraso: atrasos[index],
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
