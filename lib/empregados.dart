import 'package:bate_ponto_web/cadastro_empregado.dart';
import 'package:bate_ponto_web/comum/modelos/empregado.dart';
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
  var token = "";

  @override
  void initState() {
    super.initState();
  }

  Future<List<Empregado>> buscaEmpregados() async {
    this.token = await getToken();
    final url = "https://bate-ponto-backend.herokuapp.com/empregados";
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

// exibeAlerta(
//           contexto: context,
//           titulo: "Opa",
//           mensagem: "Não foi possível buscar os empregados",
//           labelBotao: "Tentar novamente",
//           evento: () => Navigator.of(context).popAndPushNamed(Empregados.rota));

  @override
  Widget build(BuildContext context) {
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
          future: buscaEmpregados(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Empregado>> snapshot) {
            if (snapshot == null || snapshot.hasError) {
              return Center(
                child: Text("Não foi possível buscar os empregados"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              List<Empregado> empregados = snapshot.data;
              return _buildListaEmpregados(empregados);
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                // TODO: do something in here
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
