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
        padding:
            const EdgeInsets.only(top: 12, left: 12, bottom: 20, right: 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "${widget.empregado.nome}",
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
                Container(
                  child: PopupMenuButton(
                    tooltip: "Opções",
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return EdicaoEmpregado(
                                empregado: widget.empregado,
                              );
                            }));
                          },
                          leading: Icon(Icons.edit),
                          title: Text('Editar'),
                        ),
                      ),
                      PopupMenuItem(
                        child: ListTile(
                          onTap: () {},
                          leading: Icon(Icons.history),
                          title: Text('Histórico de pontos'),
                        ),
                      ),
                      PopupMenuItem(
                        child: ListTile(
                          onTap: () {
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
                          leading: Icon(Icons.delete),
                          title: Text('Deletar'),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
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
                  padding: EdgeInsets.only(right: 20),
                  child: Column(
                    children: [
                      Text(
                        "Saldo atual",
                        // style: Theme.of(context).textTheme.body1,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        (widget.empregado.bancoHoras >= 0 ? "+" : "") +
                            "${widget.empregado.bancoHoras}h",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: widget.empregado.bancoHoras >= 0
                              ? Colors.green.shade500
                              : Colors.red.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
