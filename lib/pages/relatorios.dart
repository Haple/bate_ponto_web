import 'dart:convert';

import 'package:bate_ponto_web/funcoes/exibe_alerta.dart';
import 'package:bate_ponto_web/modelos/relatorio.dart';
import 'package:bate_ponto_web/widgets/cartao_relatorio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

import '../widgets/jornadas.dart';
import '../widgets/menu_scaffold.dart';
import '../funcoes/get_token.dart';

class Relatorios extends StatefulWidget {
  static String rota = '/relatorios';
  static String titulo = 'Relatórios';

  @override
  RelatoriosState createState() => new RelatoriosState();
}

class RelatoriosState extends State<Relatorios> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  final _jornadaKey = new GlobalKey<JornadasState>();
  DateTime _data;
  final TextEditingController _pesquisa = TextEditingController();

  var nome = "";
  var codJornada = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<List<Relatorio>> _buscaRelatorios() async {
    final token = await getToken();
    // final baseUrl = "https://bate-ponto-backend.herokuapp.com";
    final baseUrl =
        "https://5e8fbe83fe7f2a00165ef56d.mockapi.io/bate-ponto/api/v1";
    final url = "$baseUrl/relatorios";

    Map<String, String> headers = {
      // 'Authorization': token,
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return relatoriosFromJson(response.body);
    } else {
      throw new Exception("Não foi possível buscar os relatórios");
    }
  }

  void _solicitarRelatorio() async {
    print("Data: " + _data.toString());
    final token = await getToken();
    // final baseUrl = "https://bate-ponto-backend.herokuapp.com";
    final baseUrl =
        "https://5e8fbe83fe7f2a00165ef56d.mockapi.io/bate-ponto/api/v1";
    final url = "$baseUrl/relatorios";

    Map<String, String> headers = {
      // 'Authorization': token,
    };
    final response = await http.post(url, headers: headers, body: {
      "data": _data.toString(),
    });
    final responseJson = json.decode(response.body);

    if (response.statusCode == 201) {
      exibeAlerta(
        contexto: context,
        titulo: "Tudo certo",
        mensagem: "Relatório solicitado com sucesso! Agora é só aguardar ;)",
        labelBotao: "Ok",
        evento: () => Navigator.of(context).pushNamed(Relatorios.rota),
      );
    } else {
      if (responseJson['erro'] != null)
        exibeAlerta(
          contexto: context,
          titulo: "Opa",
          mensagem: "${responseJson['erro']}",
          labelBotao: "Tentar novamente",
        );
      else
        exibeAlerta(
          contexto: context,
          titulo: "Opa",
          mensagem: "Não foi possível solicitar o relatório",
          labelBotao: "Tentar novamente",
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formSolicitarRelatorio = SizedBox(
      width: 700,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            width: 200,
            child: DateTimeField(
              format: DateFormat("MM/yyyy"),
              decoration: InputDecoration(labelText: 'Mês do relatório'),
              onChanged: (dt) => _data = dt,
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
              },
            ),
          ),
          SizedBox(
            width: 100,
            child: new RaisedButton(
              child: new Text(
                "Solicitar",
                style: new TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
              onPressed: _solicitarRelatorio,
            ),
          )
        ],
      ),
    );

    return MenuScaffold(
      key: scaffoldKey,
      pageTitle: Relatorios.titulo,
      body: SafeArea(
        child: FutureBuilder(
          future: _buscaRelatorios(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Relatorio>> snapshot) {
            if (snapshot == null || snapshot.hasError) {
              return Center(
                child: Text("Não foi possível buscar os relatórios"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              List<Relatorio> relatorios = snapshot.data;
              Widget lista = _buildListaRelatorios(relatorios);
              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                child: Column(
                  children: <Widget>[
                    formSolicitarRelatorio,
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

  Widget _buildListaRelatorios(List<Relatorio> relatorios) {
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
              Relatorio relatorio = relatorios[index];
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CartaoRelatorio(relatorio: relatorio),
              );
            },
            itemCount: relatorios.length,
          ),
        ),
      ),
    );
  }
}
