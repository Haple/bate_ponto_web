import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:html' as html;

import 'package:bate_ponto_web/funcoes/get_token.dart';
import 'package:bate_ponto_web/modelos/relatorio.dart';

class CartaoRelatorio extends StatefulWidget {
  final Relatorio relatorio;

  const CartaoRelatorio({
    @required this.relatorio,
  });

  @override
  State<StatefulWidget> createState() => _CartaoRelatorioState();
}

class _CartaoRelatorioState extends State<CartaoRelatorio> {
  Future _downloadRelatorio(int codRelatorio) async {
    // final baseUrl = "https://bate-ponto-backend.herokuapp.com";
    final baseUrl =
        "https://5e8fbe83fe7f2a00165ef56d.mockapi.io/bate-ponto/api/v1";
    final url = "$baseUrl/relatorios/$codRelatorio";

    Map<String, String> headers = {
      // 'Authorization': await getToken(),
    };

    final response = await http.get(url, headers: headers);
    final jsonResponse = json.decode(response.body);
    final relatorioUrl = jsonResponse["url"];
    if (response.statusCode == 200) {
      html.window.location.replace(relatorioUrl);
    } else {
      throw new Exception("Não foi possível baixar relatório");
    }
  }

  @override
  Widget build(BuildContext context) {
    var relatorio = widget.relatorio;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Período: ${relatorio.periodo}",
                  style: Theme.of(context).textTheme.headline6,
                ),
                IconButton(
                  icon: relatorio.estado == "PENDENTE"
                      ? Icon(Icons.cloud_off)
                      : relatorio.estado == "ERRO"
                          ? Icon(Icons.error)
                          : Icon(Icons.cloud_download),
                  onPressed: relatorio.estado == "PRONTO"
                      ? () async {
                          await _downloadRelatorio(relatorio.codigo);
                        }
                      : () {},
                )
              ],
            ),
            Row(children: <Widget>[
              Text(
                "Estado: ${relatorio.estado}",
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
