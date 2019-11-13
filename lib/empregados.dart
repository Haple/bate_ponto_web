import 'dart:convert';

import 'package:bate_ponto_web/cadastro_empregado.dart';
import 'package:bate_ponto_web/comum/funcoes/exibe_alerta.dart';
import 'package:bate_ponto_web/comum/modelos/empregado.dart';
import 'package:bate_ponto_web/comum/widgets/jornadas.dart';
import 'package:bate_ponto_web/edicao_empregado.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bate_ponto_web/comum/funcoes/get_token.dart';
import 'comum/widgets/menu_scaffold.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

class Empregados extends StatefulWidget {
  static String rota = '/empregados';
  static String titulo = 'Empregados';

  @override
  _EmpregadosState createState() => new _EmpregadosState();
}

class _EmpregadosState extends State<Empregados> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  final _jornadaKey = new GlobalKey<JornadasState>();
  final TextEditingController _pesquisa = TextEditingController();

  var token = "";
  var nome = "";
  var codJornada = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<List<Empregado>> buscaEmpregados({nome = '', codJornada = 0}) async {
    this.token = await getToken();
    final baseUrl = "https://bate-ponto-backend.herokuapp.com";
    final url = "$baseUrl/empregados?nome=$nome" +
        (codJornada > 0 ? "&cod_jornada=$codJornada" : "");

    Map<String, String> headers = {
      'Authorization': token,
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return empregadosFromJson(response.body);
    } else {
      throw new Exception("Não foi possível buscar os empregados");
    }
  }

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
    final pesquisa = TextField(
      controller: _pesquisa,
      decoration: InputDecoration(
        hintText: "Empregado",
        suffixIcon: FlatButton(
          child: Icon(Icons.search),
          onPressed: () {
            setState(() {
              this.nome = _pesquisa.text;
              this.codJornada = _jornadaKey.currentState.codigoJornada;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(25.0),
          ),
        ),
      ),
    );

    return MenuScaffold(
      key: scaffoldKey,
      pageTitle: Empregados.titulo,
      floatButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CadastroEmpregado();
          }));
        },
        child: Icon(Icons.person_add),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: buscaEmpregados(nome: this.nome, codJornada: this.codJornada),
          builder:
              (BuildContext context, AsyncSnapshot<List<Empregado>> snapshot) {
            if (snapshot == null || snapshot.hasError) {
              return Center(
                child: Text("Não foi possível buscar os empregados"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              List<Empregado> empregados = snapshot.data;
              Widget lista = _buildListaEmpregados(empregados);
              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                child: Column(
                  children: <Widget>[
                    pesquisa,
                    Center(
                      child: SizedBox(
                        width: 300,
                        child: Jornadas(
                          key: _jornadaKey,
                          valorInicial: this.codJornada,
                        ),
                      ),
                    ),
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
    );
  }

  Widget _buildListaEmpregados(List<Empregado> empregados) {
    return Center(
      child: Container(
        alignment: Alignment.centerRight,
        constraints: BoxConstraints(
          maxWidth: 800,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListView.builder(
            itemBuilder: (context, index) {
              Empregado empregado = empregados[index];
              empregado.cpf = CPFValidator.format(empregado.cpf);
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "${empregado.nome}",
                                    style: Theme.of(context).textTheme.title,
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    "CPF: ${empregado.cpf}",
                                    style: Theme.of(context).textTheme.body1,
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    "E-mail: ${empregado.email}",
                                    style: Theme.of(context).textTheme.body1,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
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
                                    (empregado.bancoHoras >= 0 ? "+" : "-") +
                                        "${empregado.bancoHoras}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: empregado.bancoHoras >= 0
                                          ? Colors.green
                                          : Colors.red.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                exibeConfirmacao(
                                  contexto: context,
                                  labelConfirmar: "Sim, quero deletar",
                                  labelCancelar: "Cancelar",
                                  titulo: "Opa",
                                  mensagem:
                                      "Quer mesmo deletar '${empregado.nome}'?",
                                  eventoConfirmar: () =>
                                      _deletarEmpregado(empregado.codigo),
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
                                    empregado: empregado,
                                  );
                                }));
                              },
                              child: Text(
                                "Editar",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: empregados.length,
          ),
        ),
      ),
    );
  }
}
