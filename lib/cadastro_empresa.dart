import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'comum/widgets/celular.dart';
import 'comum/widgets/nome_completo.dart';
import 'comum/widgets/razao_social.dart';
import 'comum/widgets/cnpj.dart';
import 'comum/widgets/cpf.dart';
import 'comum/widgets/senha.dart';
import 'comum/widgets/email.dart';

import 'comum/funcoes/exibe_alerta.dart';
import 'login.dart';

class CadastroEmpresa extends StatefulWidget {
  static String rota = '/cadastro-empresa';
  @override
  _CadastroEmpresaState createState() => new _CadastroEmpresaState();
}

class _CadastroEmpresaState extends State<CadastroEmpresa> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  // Detalhes da empresa
  final TextEditingController _cnpj = TextEditingController();
  final TextEditingController _razaoSocial = TextEditingController();
  // Detalhes da pessoa física
  final TextEditingController _cpf = TextEditingController();
  final TextEditingController _nomeCompleto = TextEditingController();
  final TextEditingController _celular = TextEditingController();
  // Dados de acesso
  final TextEditingController _email = TextEditingController();
  final TextEditingController _senha = TextEditingController();

  static const int NUMERO_PASSOS = 3;
  int _currentStep = 0;

  void _proximoPasso() {
    final form = formKey.currentState;
    if (_currentStep < NUMERO_PASSOS - 1 && form.validate()) {
      setState(() {
        _currentStep++;
      });
    }
  }

  StepState _estadoAtual(int i) {
    if (_currentStep == i)
      return StepState.editing;
    else if (_currentStep > i)
      return StepState.complete;
    else
      return StepState.disabled;
  }

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      _cadastrarEmpresa();
    }
  }

  void _cadastrarEmpresa() async {
    final url = "https://bate-ponto-backend.herokuapp.com/empresas";

    Map<String, String> body = {
      'cnpj': _cnpj.text,
      'razao_social': _razaoSocial.text,
      'cpf': _cpf.text,
      'nome': _nomeCompleto.text,
      'email': _email.text,
      'senha': _senha.text,
      'celular': _celular.text
    };

    final response = await http.post(
      url,
      body: body,
    );
    final responseJson = json.decode(response.body);
    if (response.statusCode == 201) {
      exibeAlerta(
        contexto: context,
        titulo: "Tudo certo",
        mensagem:
            "A empresa foi cadastrada! Não esqueça de conferir seu e-mail.",
        labelBotao: "Fazer login",
        evento: () => Navigator.of(context).pushNamed(Login.rota),
      );
    } else {
      exibeAlerta(
        contexto: context,
        titulo: "Opa",
        mensagem: responseJson["erro"],
        labelBotao: "Tentar novamente",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _controlsBuilder(BuildContext context,
        {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
      return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.navigate_before),
              label: const Text('VOLTAR'),
              onPressed: onStepCancel,
            ),
            _currentStep == NUMERO_PASSOS - 1 // this is the last step
                ? RaisedButton.icon(
                    icon: Icon(Icons.create),
                    onPressed: _submit,
                    label: Text('CADASTRAR'),
                    color: Colors.blue,
                  )
                : RaisedButton.icon(
                    icon: Icon(Icons.navigate_next),
                    onPressed: onStepContinue,
                    label: Text('CONTINUAR'),
                    color: Colors.lightBlue,
                  )
          ],
        ),
      );
    }

    Widget _formulario(List<Widget> campos, double largura) {
      return new Center(
        child: new Container(
          // constraints: BoxConstraints(maxWidth: largura),
          child: new Form(
            key: formKey,
            child: new Column(
              children: campos,
            ),
          ),
        ),
      );
    }

    Widget _passo1() {
      return _formulario(
        <Widget>[
          new Cnpj(controller: _cnpj),
          new RazaoSocial(controller: _razaoSocial),
        ],
        350,
      );
    }

    Widget _passo2() {
      return _formulario(
        <Widget>[
          new Cpf(controller: _cpf),
          new NomeCompleto(controller: _nomeCompleto),
          new Celular(controller: _celular),
        ],
        350,
      );
    }

    Widget _passo3() {
      return _formulario(
        <Widget>[
          new Email(controller: _email),
          new Senha(controller: _senha),
        ],
        350,
      );
    }

    final stepper = new Stepper(
      type: StepperType.horizontal,
      currentStep: _currentStep,
      onStepTapped: (int step) => setState(() => _currentStep = step),
      onStepContinue: _proximoPasso,
      onStepCancel:
          _currentStep > 0 ? () => setState(() => _currentStep -= 1) : null,
      steps: <Step>[
        new Step(
          title: new Text('Empresa'),
          content: _passo1(),
          isActive: _currentStep >= 0,
          state: _estadoAtual(0),
        ),
        new Step(
          title: new Text('Detalhes'),
          content: _passo2(),
          isActive: _currentStep >= 0,
          state: _estadoAtual(1),
        ),
        new Step(
          title: new Text('Acesso'),
          content: _passo3(),
          isActive: _currentStep >= 0,
          state: _estadoAtual(2),
        ),
      ],
      controlsBuilder: _controlsBuilder,
    );

    return new Scaffold(
      key: scaffoldKey,
      body: new Center(
        child: new Container(
          constraints: BoxConstraints(maxWidth: 700),
          child: new Padding(
            padding: const EdgeInsets.all(20.0),
            child: stepper,
          ),
        ),
      ),
    );
  }
}
