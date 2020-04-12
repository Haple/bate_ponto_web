import 'package:bate_ponto_web/modelos/indicador.dart';
import 'package:bate_ponto_web/modelos/resultado_indicador.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class CartaoIndicador extends StatefulWidget {
  final Indicador indicador;

  const CartaoIndicador({
    @required this.indicador,
  });

  @override
  State<StatefulWidget> createState() => _CartaoIndicadorState();
}

class _CartaoIndicadorState extends State<CartaoIndicador> {
  List<charts.Series<ResultadoIndicador, int>> _convertResultsToChartData(
      List<ResultadoIndicador> resultados) {
    return [
      new charts.Series<ResultadoIndicador, int>(
        id: 'Concordo',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (ResultadoIndicador r, _) => r.mes,
        measureFn: (ResultadoIndicador r, _) => r.concordo,
        data: resultados,
      ),
      new charts.Series<ResultadoIndicador, int>(
        id: 'Neutro',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (ResultadoIndicador r, _) => r.mes,
        measureFn: (ResultadoIndicador r, _) => r.neutro,
        data: resultados,
      ),
      new charts.Series<ResultadoIndicador, int>(
        id: 'Discordo',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (ResultadoIndicador r, _) => r.mes,
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
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //TOGGLE
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "${indicador.titulo}",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Text(
                    "\"${indicador.mensagem}\"",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  constraints: BoxConstraints(
                    maxHeight: 300,
                    maxWidth: 650,
                  ),
                  child: charts.LineChart(
                    _convertResultsToChartData(indicador.resultados),
                    defaultRenderer: new charts.LineRendererConfig(),
                    animate: true,
                  ),
                ),
                // SizedBox(
                //   height: 300,
                //   width: 800,
                //   child: charts.LineChart(
                //     _convertResultsToChartData(indicador.resultados),
                //     defaultRenderer: new charts.LineRendererConfig(),
                //     animate: true,
                //   ),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }
}