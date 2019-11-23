import 'package:bate_ponto_web/comum/funcoes/get_token.dart';
import 'package:bate_ponto_web/comum/modelos/empregado.dart';
import 'package:bate_ponto_web/comum/modelos/ponto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PontosDialog extends StatefulWidget {
  final Empregado empregado;

  const PontosDialog({
    Key key,
    this.empregado,
  });

  @override
  State<StatefulWidget> createState() => _PontosDialogState();
}

class _PontosDialogState extends State<PontosDialog> {
  @override
  Widget build(BuildContext context) {
    final titulo = new Center(
      child: new Text(
        widget.empregado.nome,
        style: TextStyle(
          fontSize: 24.0,
        ),
      ),
    );

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: 800.0,
        width: 500.0,
        padding: EdgeInsets.all(15.0),
        child: SafeArea(
          child: FutureBuilder(
            future: _buscarPontos(widget.empregado.codigo),
            builder:
                (BuildContext context, AsyncSnapshot<List<Ponto>> snapshot) {
              if (snapshot == null || snapshot.hasError) {
                return Center(
                  child: Text("Não foi possível buscar os pontos"),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                List<Ponto> pontos = snapshot.data;
                final lista = _buildListaPontos(pontos);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                  child: Column(
                    children: <Widget>[
                      titulo,
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
      ),
    );
  }

  Widget _buildListaPontos(List<Ponto> pontos) {
    Widget lista = ListView.builder(
      itemBuilder: (context, index) {
        Ponto ponto = pontos[index];
        ponto.criadoEm = new DateFormat("dd/MM/yyyy - HH:mm")
            .format(DateTime.parse(ponto.criadoEm));
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, left: 12, bottom: 20, right: 12),
              child: Column(
                children: [
                  Text(
                    "${ponto.criadoEm}",
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    // alignment: Alignment.center,
                    width: 300,
                    child: Text(
                      "${ponto.localizacao}",
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      itemCount: pontos.length,
    );

    if (pontos.length == 0) lista = Text("Nenhum ponto registrado");

    return Center(
      child: Container(
        alignment: Alignment.center,
        constraints: BoxConstraints(
          maxWidth: 800,
        ),
        child: lista,
      ),
    );
  }

  Future<List<Ponto>> _buscarPontos(int codEmpregado) async {
    final baseUrl = "https://bate-ponto-backend.herokuapp.com";
    final url = "$baseUrl/empregados/$codEmpregado/pontos";
    var token = await getToken();
    Map<String, String> headers = {
      'Authorization': token,
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return pontosFromJson(response.body);
    } else {
      throw new Exception("Não foi possível buscar os pontos");
    }
  }
}
