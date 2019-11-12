import 'dart:convert';

import 'package:bate_ponto_web/comum/modelos/empregado.dart';
import 'package:bate_ponto_web/comum/widgets/celular.dart';
import 'package:bate_ponto_web/comum/widgets/cpf.dart';
import 'package:bate_ponto_web/comum/widgets/jornadas.dart';
import 'package:bate_ponto_web/comum/widgets/nome_completo.dart';
import 'package:bate_ponto_web/empregados.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'comum/funcoes/exibe_alerta.dart';
import 'comum/funcoes/get_token.dart';
import 'comum/widgets/email.dart';
import 'comum/widgets/menu_scaffold.dart';

class EdicaoEmpregado extends StatefulWidget {
  final Empregado empregado;

  const EdicaoEmpregado({
    Key key,
    @required this.empregado,
  }) : super(key: key);

  @override
  _EdicaoEmpregadoState createState() => new _EdicaoEmpregadoState();
}

class _EdicaoEmpregadoState extends State<EdicaoEmpregado> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  final jornadaKey = new GlobalKey<JornadasState>();

  final TextEditingController _nome = TextEditingController();
  final TextEditingController _cpf = TextEditingController();
  final TextEditingController _celular = TextEditingController();
  final TextEditingController _email = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nome.text = widget.empregado.nome;
    _cpf.text = widget.empregado.cpf;
    _celular.text = widget.empregado.celular;
    _email.text = widget.empregado.email;
  }

  void _salvar() async {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      Empregado empregado = new Empregado(
        codigo: widget.empregado.codigo,
        nome: _nome.text,
        cpf: _cpf.text,
        celular: _celular.text,
        email: _email.text,
        codJornada: jornadaKey.currentState.codigoJornada,
      );
      _editarEmpregado(empregado);
    }
  }

  void _editarEmpregado(Empregado empregado) async {
    var token = await getToken();

    final url =
        "https://bate-ponto-backend.herokuapp.com/empregados/${empregado.codigo}";
    Map<String, String> headers = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    final response = await http.put(
      url,
      headers: headers,
      body: empregadoToJson(empregado),
    );
    final responseJson = json.decode(response.body);
    if (response.statusCode == 200) {
      exibeAlerta(
        contexto: context,
        titulo: "Tudo certo",
        mensagem: "Empregado editado!",
        labelBotao: "Ok",
        evento: () => Navigator.of(context).pushNamed(Empregados.rota),
      );
    } else {
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
          mensagem: "Não foi possível editar o empregado",
          labelBotao: "Tentar novamente",
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    var titulo = new Center(
      child: new Text(
        "Editar empregado",
        style: TextStyle(
          fontSize: 24.0,
        ),
      ),
    );

    var botaoCadastrar = new RaisedButton(
      child: new Text(
        "Salvar",
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
          new Cpf(
            controller: _cpf,
            habilitado: false,
          ),
          SizedBox(height: 8.0),
          new NomeCompleto(controller: _nome),
          SizedBox(height: 8.0),
          new Celular(controller: _celular),
          SizedBox(height: 8.0),
          new Email(controller: _email),
          SizedBox(height: 8.0),
          Jornadas(
            key: jornadaKey,
            valorInicial: widget.empregado.codJornada,
          ),
          SizedBox(height: 14.0),
          botaoCadastrar,
        ],
      ),
    );

    return MenuScaffold(
      key: scaffoldKey,
      pageTitle: Empregados.titulo,
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 700,
          ),
          child: formulario,
        ),
      ),
    );
  }
}
