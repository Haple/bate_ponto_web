import 'dart:convert';

import 'package:bate_ponto_web/funcoes/exibe_alerta.dart';
import 'package:bate_ponto_web/funcoes/get_token.dart';
import 'package:bate_ponto_web/modelos/indicador.dart';
import 'package:bate_ponto_web/modelos/resultado_indicador.dart';
import 'package:bate_ponto_web/pages/indicadores.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

class CartaoIndicador extends StatefulWidget {
  final Indicador indicador;

  const CartaoIndicador({
    @required this.indicador,
  });

  @override
  State<StatefulWidget> createState() => _CartaoIndicadorState();
}

class _CartaoIndicadorState extends State<CartaoIndicador> {
  var _ativado;

  @override
  void initState() {
    super.initState();
    _ativado = widget.indicador.ativado;
  }

  void _configurarIndicador(bool ativado) async {
    final token = await getToken();
    final baseUrl = "https://bate-ponto-backend.herokuapp.com";
    final url = "$baseUrl/indicadores/${widget.indicador.codigoIndicador}";

    Map<String, String> headers = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    try {
      final response =
          await http.patch(url, headers: headers, body: '{"ativado": $ativado}');
      if (response.statusCode == 200) {
        exibeAlerta(
          contexto: context,
          titulo: "Tudo certo",
          mensagem: "Indicador configurado com sucesso!",
          labelBotao: "Ok",
        );
      } else {
        final responseJson = json.decode(response.body);
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
            mensagem: "Não foi possível configurar o indicador.",
            labelBotao: "Tentar novamente",
          );
      }
    } catch (e) {
      print("ERROR: " + e.toString());
    }
  }

  List<charts.Series<ResultadoIndicador, DateTime>> _convertResultsToChartData(
      List<ResultadoIndicador> resultados) {
    return [
      new charts.Series<ResultadoIndicador, DateTime>(
        id: 'Concordo',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (ResultadoIndicador r, _) => DateTime.parse(r.periodo),
        measureFn: (ResultadoIndicador r, _) => r.concordo,
        data: resultados,
      ),
      new charts.Series<ResultadoIndicador, DateTime>(
        id: 'Neutro',
        colorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault,
        domainFn: (ResultadoIndicador r, _) => DateTime.parse(r.periodo),
        measureFn: (ResultadoIndicador r, _) => r.neutro,
        data: resultados,
      ),
      new charts.Series<ResultadoIndicador, DateTime>(
        id: 'Discordo',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (ResultadoIndicador r, _) => DateTime.parse(r.periodo),
        measureFn: (ResultadoIndicador r, _) => r.discordo,
        data: resultados,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var indicador = widget.indicador;

    return Card(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 12, left: 12, bottom: 20, right: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //TOGGLE

                  Switch(
                    value: _ativado,
                    onChanged: (value) {
                      _configurarIndicador(value);
                      this.setState(() {
                        _ativado = value;
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),

                  Container(
                    // padding: EdgeInsets.only(left: 20),
                    child: Text("${indicador.titulo}",
                        style: Theme.of(context).textTheme.headline5),
                  ),
                  Text(
                    "\"${indicador.mensagem}\"",
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      // color: Colors.grey
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  constraints: BoxConstraints(
                    maxHeight: 300,
                    maxWidth: 650,
                  ),
                  child: charts.TimeSeriesChart(
                    _convertResultsToChartData(indicador.resultados),
                    defaultRenderer: new charts.LineRendererConfig(),
                    animate: true,
                    behaviors: [new charts.SeriesLegend()],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
