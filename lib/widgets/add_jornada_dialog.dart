import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../funcoes/exibe_alerta.dart';
import '../funcoes/get_token.dart';
import '../modelos/jornada.dart';
import 'horario.dart';
import 'jornadas.dart';

class AddJornadaDialog extends StatefulWidget {
  final JornadasState jornadasState;
  const AddJornadaDialog({
    Key key,
    @required this.jornadasState,
  });

  @override
  State<StatefulWidget> createState() => _AddJornadaDialogState();
}

class _AddJornadaDialogState extends State<AddJornadaDialog> {
  final formKey = new GlobalKey<FormState>();
  final TextEditingController _nome = TextEditingController();
  final TextEditingController _entrada1 = TextEditingController();
  final TextEditingController _saida1 = TextEditingController();
  final TextEditingController _entrada2 = TextEditingController();
  final TextEditingController _saida2 = TextEditingController();

  void _salvar() async {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      Jornada jornada = new Jornada(
        nome: _nome.text,
        entrada1: _entrada1.text,
        saida1: _saida1.text,
        entrada2: _entrada2.text,
        saida2: _saida2.text,
      );
      await _criarJornada(jornada);
    }
  }

  Future _criarJornada(Jornada jornada) async {
    var token = await getToken();

    final url = "https://bate-ponto-backend.herokuapp.com/jornadas";
    Map<String, String> headers = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    final response = await http.post(
      url,
      headers: headers,
      body: jornadaToJson(jornada),
    );
    final responseJson = json.decode(response.body);
    if (response.statusCode == 201) {
      exibeAlerta(
        contexto: context,
        titulo: "Tudo certo!",
        mensagem: "A jornada foi cadastrada!",
        labelBotao: "Ok",
        evento: () {
          widget.jornadasState.setState(() {
            widget.jornadasState.codigoJornada = 0;
          });
          Navigator.of(context).pop();
        },
      );
    } else {
      if (responseJson['erro'] != null)
        exibeAlerta(
          contexto: context,
          titulo: "Opa!",
          mensagem: "${responseJson['erro']}",
          labelBotao: "Tentar novamente",
        );
      else if (responseJson['erros'] != null)
        exibeAlerta(
          contexto: context,
          titulo: "Opa!",
          mensagem: "${responseJson['erros'][0]['erro']}",
          labelBotao: "Tentar novamente",
        );
      else
        exibeAlerta(
          contexto: context,
          titulo: "Opa!",
          mensagem: "Não foi possível criar uma jornada!",
          labelBotao: "Tentar novamente",
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final titulo = new Center(
      child: new Text(
        "Nova Jornada",
        style: TextStyle(
          fontSize: 24.0,
        ),
      ),
    );

    var botaoCadastrar = new RaisedButton(
      child: new Text(
        "Cadastrar",
        style: new TextStyle(color: Colors.white),
      ),
      color: Colors.blue,
      onPressed: _salvar,
    );

    var formulario = new Form(
      key: formKey,
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        children: <Widget>[
          titulo,
          SizedBox(height: 28.0),
          TextFormField(
            controller: _nome,
            keyboardType: TextInputType.text,
            autofocus: false,
            validator: (valor) => valor.isEmpty ? 'Nome é obrigatório' : null,
            decoration: new InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Nome da jornada",
            ),
          ),
          SizedBox(height: 8.0),
          new Horario(
            controller: _entrada1,
            label: "Entrada 1",
          ),
          SizedBox(height: 8.0),
          new Horario(
            controller: _saida1,
            label: "Saída 1",
          ),
          SizedBox(height: 8.0),
          new Horario(
            controller: _entrada2,
            label: "Entrada 2",
          ),
          SizedBox(height: 8.0),
          new Horario(
            controller: _saida2,
            label: "Saída 2",
          ),
          SizedBox(height: 14.0),
          botaoCadastrar,
        ],
      ),
    );

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: 470.0,
        width: 400.0,
        padding: EdgeInsets.all(15.0),
        child: formulario,
      ),
    );
  }
}
