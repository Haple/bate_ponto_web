import 'dart:convert';

import 'package:bate_ponto_web/comum/funcoes/exibe_alerta.dart';
import 'package:bate_ponto_web/comum/funcoes/get_token.dart';
import 'package:bate_ponto_web/comum/modelos/jornada.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'add_jornada_dialog.dart';

class Jornadas extends StatefulWidget {
  final int valorInicial;
  const Jornadas({Key key, this.valorInicial = 0}) : super(key: key);

  @override
  State<StatefulWidget> createState() => JornadasState();
}

class JornadasState extends State<Jornadas> {
  int codigoJornada = 0;

  @override
  void initState() {
    super.initState();
    codigoJornada = widget.valorInicial;
  }

  Future<List<Jornada>> _buscarJornadas() async {
    final url = "https://bate-ponto-backend.herokuapp.com/jornadas";
    var token = await getToken();
    Map<String, String> headers = {
      'Authorization': token,
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return jornadasFromJson(response.body);
    } else {
      throw new Exception("Não foi possível buscar as jornadas");
    }
  }

  Future<void> _deletarJornada(int codigo) async {
    final url = "https://bate-ponto-backend.herokuapp.com/jornadas/$codigo";
    var token = await getToken();
    Map<String, String> headers = {
      'Authorization': token,
    };
    final response = await http.delete(url, headers: headers);
    if (response.statusCode != 200) {
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
          mensagem: "Não foi possível deletar a jornada",
          labelBotao: "Tentar novamente",
        );
    } else {
      return setState(() {
        codigoJornada = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final botaoAddJornada = new MaterialButton(
      child: Row(
        children: [
          Icon(Icons.add),
          Text("Nova jornada"),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AddJornadaDialog(
              jornadasState: this,
            );
          },
        );
      },
    );

    DropdownMenuItem<int> itemJornada({nome, codigo}) => new DropdownMenuItem(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              new Text(nome),
              new MaterialButton(
                child: Icon(Icons.delete),
                onPressed: () => {
                  exibeConfirmacao(
                    contexto: context,
                    titulo: "Opa",
                    mensagem: "Que realmente deletar essa jornada?",
                    labelConfirmar: "Sim, quero deletar",
                    eventoConfirmar: () async {
                      await _deletarJornada(codigo);
                    },
                    labelCancelar: "Cancelar",
                  )
                },
              )
            ],
          ),
          value: codigo,
        );

    Widget _buildListaJornadas(List<Jornada> jornadas) {
      List<DropdownMenuItem<int>> items = [];
      jornadas.forEach((jornada) => {
            items.add(
              itemJornada(
                nome: jornada.nome,
                codigo: jornada.codigo,
              ),
            )
          });
      items.add(new DropdownMenuItem(
        child: botaoAddJornada,
        value: 0,
      ));

      return DropdownButtonFormField(
        decoration: new InputDecoration(
          labelText: "Jornada",
          hintText: "Selecione a jornada",
        ),
        items: items,
        value: codigoJornada,
        validator: (value) =>
            codigoJornada == 0 ? 'Jornada é obrigatória' : null,
        onChanged: (value) {
          setState(() {
            codigoJornada = value;
          });
        },
        isExpanded: false,
      );
    }

    return new SafeArea(
      child: FutureBuilder(
        future: _buscarJornadas(),
        builder: (BuildContext context, AsyncSnapshot<List<Jornada>> snapshot) {
          if (snapshot == null || snapshot.hasError) {
            return Center(
              child: Text("Não foi possível buscar as jornadas"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Jornada> jornadas = snapshot.data;
            return _buildListaJornadas(jornadas);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
