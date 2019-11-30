import 'dart:convert';
import 'dart:html' as html;
import 'dart:ui';

import 'package:bate_ponto_web/comum/funcoes/get_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'comum/modelos/abono.dart';
import 'comum/widgets/add_avaliacao_dialog.dart';
import 'comum/widgets/menu_scaffold.dart';

class Abonos extends StatefulWidget {
  static String rota = '/abonos';
  static String titulo = 'Pedidos de abonos';
  @override
  AbonosState createState() => new AbonosState();
}

class AbonosState extends State<Abonos> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  Future<List<Abono>> _buscaAbonos() async {
    final url =
        "https://bate-ponto-backend.herokuapp.com/abonos?buscarTudo=true&status=pendente";

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

  Future _downloadAnexo(int codAbono) async {
    final url =
        "https://bate-ponto-backend.herokuapp.com/abonos/$codAbono/anexos";

    Map<String, String> headers = {
      'Authorization': await getToken(),
    };

    final response = await http.get(url, headers: headers);
    print(response.body);
    final jsonResponse = json.decode(response.body);
    final anexoUrl = jsonResponse["url"];
    final nomeOriginal = jsonResponse["anexo_original"];
    if (response.statusCode == 200) {
      print("$anexoUrl");
      print("$nomeOriginal");
      // html.window.open(anexoUrl, nomeOriginal);
      html.window.location.replace(anexoUrl);
    } else {
      throw new Exception("Não foi possível baixar anexo");
    }

    // html.Element a = html.document.createElement("a");
    // a.setAttribute("href", anexo);
    // a.setAttribute("download", "anexoOOO.jpeg");
    // a.click();
  }

  Widget _buildListaAbonos(List<Abono> abonos) {
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
              Abono abono = abonos[index];
              abono.dataAbonada = new DateFormat("dd/MM/yyyy")
                  .format(DateTime.parse(abono.dataAbonada));
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "${abono.nome}",
                              style: Theme.of(context).textTheme.title,
                            ),
                            IconButton(
                              icon: abono.anexo == null
                                  ? Icon(Icons.cloud_off)
                                  : Icon(Icons.cloud_download),
                              onPressed: abono.anexo == null
                                  ? () {}
                                  : () async {
                                      await _downloadAnexo(abono.codigo);
                                    },
                            )
                          ],
                        ),
                        Row(children: <Widget>[
                          Text(
                            "Descrição: ${abono.motivo}",
                            style: Theme.of(context).textTheme.body1,
                          ),
                        ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  "Data solicitada: ${abono.dataAbonada}",
                                  style: Theme.of(context).textTheme.body1,
                                ),
                              ],
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FlatButton(
                                    color: Colors.green,
                                    textColor: Colors.white,
                                    disabledColor: Colors.grey,
                                    disabledTextColor: Colors.black,
                                    padding: EdgeInsets.all(2.0),
                                    splashColor: Colors.blueAccent,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          var addAvaliacaoDialog =
                                              AddAvaliacaoDialog(
                                            abonosState: this,
                                            aprovado: true,
                                            codAbono: abono.codigo,
                                          );
                                          var addJornadaDialog =
                                              addAvaliacaoDialog;
                                          return addJornadaDialog;
                                        },
                                      );
                                    },
                                    child: Text(
                                      "Aprovado",
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                  ),
                                  FlatButton(
                                    color: Colors.red,
                                    textColor: Colors.white,
                                    disabledColor: Colors.grey,
                                    disabledTextColor: Colors.black,
                                    padding: EdgeInsets.all(2.0),
                                    splashColor: Colors.blueAccent,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          var addAvaliacaoDialog =
                                              AddAvaliacaoDialog(
                                            abonosState: this,
                                            aprovado: false,
                                            codAbono: abono.codigo,
                                          );
                                          var addJornadaDialog =
                                              addAvaliacaoDialog;
                                          return addJornadaDialog;
                                        },
                                      );
                                    },
                                    child: Text(
                                      "Recusado",
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ])
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: abonos.length,
          ),
        ),
      ),
    );
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
