import 'dart:convert';

import 'package:bate_ponto_web/comum/funcoes/exibe_alerta.dart';
import 'package:bate_ponto_web/comum/funcoes/get_token.dart';
import 'package:bate_ponto_web/comum/modelos/empregado.dart';
import 'package:bate_ponto_web/edicao_empregado.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CartaoEmpregado extends StatefulWidget {
  final Empregado empregado;

  const CartaoEmpregado({
    @required this.empregado,
  });

  @override
  State<StatefulWidget> createState() => _CartaoEmpregadoState();
}

class _CartaoEmpregadoState extends State<CartaoEmpregado> {
  Future<void> _deletarEmpregado(int codigo) async {
    final url = "https://bate-ponto-backend.herokuapp.com/empregados/$codigo";
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
          mensagem: "Não foi possível deletar o empregado",
          labelBotao: "Tentar novamente",
        );
    } else {
      return setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          verticalDirection: VerticalDirection.down,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${widget.empregado.nome}",
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    "CPF: ${widget.empregado.cpf}",
                    style: Theme.of(context).textTheme.body1,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    "E-mail: ${widget.empregado.email}",
                    style: Theme.of(context).textTheme.body1,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Text(
                    "Saldo atual",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    (widget.empregado.bancoHoras >= 0 ? "+" : "") +
                        "${widget.empregado.bancoHoras}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: widget.empregado.bancoHoras >= 0
                          ? Colors.green.shade500
                          : Colors.red.shade500,
                    ),
                  ),
                  Row(
                    children: [
                      FlatButton(
                        onPressed: () {
                          exibeConfirmacao(
                            contexto: context,
                            labelConfirmar: "Sim, quero deletar",
                            labelCancelar: "Cancelar",
                            titulo: "Opa",
                            mensagem:
                                "Quer mesmo deletar '${widget.empregado.nome}'?",
                            eventoConfirmar: () =>
                                _deletarEmpregado(widget.empregado.codigo),
                          );
                        },
                        child: Text(
                          "Deletar",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return EdicaoEmpregado(
                              empregado: widget.empregado,
                            );
                          }));
                        },
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
