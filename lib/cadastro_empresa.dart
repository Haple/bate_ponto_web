// import 'package:bate_ponto_web/comum/celular.dart';
// import 'package:bate_ponto_web/comum/nome_completo.dart';
// import 'package:bate_ponto_web/comum/razao_social.dart';
// import 'package:flutter/material.dart';
// import 'package:bate_ponto_web/comum/cnpj.dart';
// import 'package:bate_ponto_web/comum/cpf.dart';
// import 'package:bate_ponto_web/comum/senha.dart';
// import 'package:bate_ponto_web/comum/email.dart';

// class CadastroEmpresa extends StatefulWidget {
//   static String tag = 'cadastro-empresa';
//   @override
//   _CadastroEmpresaState createState() => new _CadastroEmpresaState();
// }

// class _CadastroEmpresaState extends State<CadastroEmpresa> {
//   final scaffoldKey = new GlobalKey<ScaffoldState>();
//   final formKey = new GlobalKey<FormState>();
//   // Detalhes da empresa
//   final TextEditingController _cnpj = TextEditingController();
//   final TextEditingController _razaoSocial = TextEditingController();
//   // Detalhes da pessoa física
//   final TextEditingController _cpf = TextEditingController();
//   final TextEditingController _nomeCompleto = TextEditingController();
//   final TextEditingController _celular = TextEditingController();
//   // Dados de acesso
//   final TextEditingController _email = TextEditingController();
//   final TextEditingController _senha = TextEditingController();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }

//   void _submit() {
//     final form = formKey.currentState;
//     if (form.validate()) {
//       form.save();
//       performLogin();
//     }
//   }

//   void performLogin() {
//     final snackbar = new SnackBar(
//       content: new Text(
//         "E-mail: ${_email.text}, senha: ${_senha.text}",
//       ),
//     );
//     scaffoldKey.currentState.showSnackBar(snackbar);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final titulo = new Text(
//       "Cadastrar empresa",
//       textAlign: TextAlign.center,
//       style: new TextStyle(
//         fontWeight: FontWeight.w500,
//         fontSize: 25.0,
//       ),
//     );

//     final cadastrar = new RaisedButton(
//       child: new Text(
//         "Cadastrar",
//         style: new TextStyle(color: Colors.white),
//       ),
//       color: Colors.blue,
//       onPressed: _submit,
//     );

//     final formulario = new Form(
//       key: formKey,
//       child: new ListView(
//         children: <Widget>[
//           titulo,
//           new Padding(
//             padding: const EdgeInsets.only(
//               top: 50.0,
//             ),
//           ),
//           new Cnpj(controller: _cnpj),
//           new RazaoSocial(controller: _razaoSocial),
//           new Cpf(controller: _cpf),
//           new NomeCompleto(controller: _nomeCompleto),
//           new Celular(controller: _celular),
//           new Email(controller: _email),
//           new Senha(controller: _senha),
//           new Padding(
//             padding: const EdgeInsets.only(
//               top: 20.0,
//             ),
//           ),
//           cadastrar
//         ],
//       ),
//     );

//     return new Scaffold(
//       key: scaffoldKey,
//       body: new Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Center(
//           child: Container(
//             constraints: BoxConstraints(maxWidth: 350),
//             child: formulario,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:bate_ponto_web/comum/celular.dart';
import 'package:bate_ponto_web/comum/nome_completo.dart';
import 'package:bate_ponto_web/comum/razao_social.dart';
import 'package:flutter/material.dart';
import 'package:bate_ponto_web/comum/cnpj.dart';
import 'package:bate_ponto_web/comum/cpf.dart';
import 'package:bate_ponto_web/comum/senha.dart';
import 'package:bate_ponto_web/comum/email.dart';

class CadastroEmpresa extends StatefulWidget {
  static String tag = 'cadastro-empresa';
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

  final int NUMERO_PASSOS = 3;
  int _currentStep = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

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
      performLogin();
    }
  }

  void performLogin() {
    final snackbar = new SnackBar(
      content: new Text(
        "E-mail: ${_email.text}, senha: ${_senha.text}",
      ),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    Widget _controlsBuilder(BuildContext context,
        {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
      return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
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
          constraints: BoxConstraints(maxWidth: largura),
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
          constraints: BoxConstraints(maxWidth: 600),
          child: new Padding(
            padding: const EdgeInsets.all(20.0),
            child: stepper,
          ),
        ),
      ),
    );
  }
}
