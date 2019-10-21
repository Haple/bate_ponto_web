import 'package:flutter/material.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

class Cpf extends StatefulWidget {
  final TextEditingController controller;

  const Cpf({
    Key key,
    @required this.controller,
  })  : assert(controller != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _CpfState();
}

class _CpfState extends State<Cpf> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      validator: (valor) =>
          CPFValidator.isValid(valor) ? null : 'CNPJ inválido',
      decoration: new InputDecoration(
        labelText: "CPF",
        hintText: "000.000.000-00",
      ),
    );
  }
}
