import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../funcoes/exibe_alerta.dart';
import '../funcoes/get_token.dart';
import '../modelos/abono.dart';
import '../pages/abonos.dart';

class AddAvaliacaoDialog extends StatefulWidget {
  final AbonosState abonosState;
  final bool aprovado;
  final int codAbono;

  const AddAvaliacaoDialog(
      {Key key,
      @required this.abonosState,
      @required this.aprovado,
      @required this.codAbono});

  @override
  State<StatefulWidget> createState() => _AddAvaliacaoDialogState();
}

class _AddAvaliacaoDialogState extends State<AddAvaliacaoDialog> {
  final formKey = new GlobalKey<FormState>();
  final TextEditingController _avaliacao = TextEditingController();

  void _salvar() async {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      Abono abono = new Abono(
          aprovado: widget.aprovado,
          avaliacao: _avaliacao.text,
          codigo: widget.codAbono);
      await _criarAvaliacao(abono);
    }
  }

  Future _criarAvaliacao(Abono abono) async {
    var token = await getToken();

    final url =
        "https://bate-ponto-backend.herokuapp.com/abonos/${abono.codigo}/avaliacoes";
    Map<String, String> headers = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    final response = await http.post(
      url,
      headers: headers,
      body: abonoToJson(abono),
    );
    final responseJson = json.decode(response.body);
    if (response.statusCode == 200) {
      exibeAlerta(
        contexto: context,
        titulo: "Tudo certo!",
        mensagem: "Abono avaliado com sucesso!",
        labelBotao: "Ok",
        evento: () {
          widget.abonosState.setState(() {});
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
      else
        exibeAlerta(
          contexto: context,
          titulo: "Opa!",
          mensagem: "Não foi possível avaliar o abono!",
          labelBotao: "Tentar novamente",
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final titulo = new Center(
      child: new Text(
        "Avaliação",
        style: TextStyle(
          fontSize: 24.0,
        ),
      ),
    );

    final avaliacao = new Center(
      child: new TextFormField(
        controller: _avaliacao,
        keyboardType: TextInputType.multiline,
        minLines: 3,
        maxLines: 8,
        autofocus: false,
        validator: (valor) => valor.isEmpty? "Avaliação obrigatória!": null,
        decoration: new InputDecoration(
          border: OutlineInputBorder(),
        ),
        
        style: TextStyle(
          fontSize: 24.0,
        ),
      ),
    );

    var botaoAvaliar = new RaisedButton(
      child: new Text(
        "Salvar",
        style: new TextStyle(color: Colors.white),
      ),
      color: Colors.green,
      onPressed: _salvar,
    );

    final formulario = new Form(
      key:  formKey,
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        children: <Widget>[
          titulo,
          SizedBox(height: 28.0,),
          avaliacao,
          SizedBox(height: 8.0,),
          botaoAvaliar
        ],
      ),
    );

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: 300.0,
        width: 600.0,
        padding: EdgeInsets.all(15.0),
        child: formulario,
      ),
    );
  }
}
