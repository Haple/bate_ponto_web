import 'package:flutter/material.dart';

_evento() {}

void exibeAlerta({
  BuildContext contexto,
  String titulo,
  String mensagem,
  String labelBotao,
  Function evento = _evento,
}) {
  showDialog(
    context: contexto,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text(titulo),
        content: new Text(mensagem),
        actions: <Widget>[
          new FlatButton(
            child: new Text(labelBotao),
            onPressed: () {
              Navigator.of(context).pop();
              evento();
            },
          ),
        ],
      );
    },
  );
}
