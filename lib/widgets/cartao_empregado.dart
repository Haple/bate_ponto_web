import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../funcoes/exibe_alerta.dart';
import '../funcoes/get_token.dart';
import '../pages/edicao_empregado.dart';
import '../pages/empregados.dart';
import '../modelos/empregado.dart';
import 'pontos_dialog.dart';

class CartaoEmpregado extends StatefulWidget {
  final Empregado empregado;
  final EmpregadosState empregadosState;

  const CartaoEmpregado({
    @required this.empregado,
    @required this.empregadosState,
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
          titulo: "Opa!",
          mensagem: "${responseJson['erro']}",
          labelBotao: "Tentar novamente",
        );
      else
        exibeAlerta(
          contexto: context,
          titulo: "Opa!",
          mensagem: "Não foi possível deletar o empregado!",
          labelBotao: "Tentar novamente",
        );
    } else {
      widget.empregadosState.setState(() {});
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
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return PontosDialog(
                                  empregado: widget.empregado,
                                );
                              },
                            );
                          },
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
                              titulo: "Opa!",
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
                        "Saldo Atual",
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
