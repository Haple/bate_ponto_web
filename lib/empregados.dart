import 'package:bate_ponto_web/cadastro_empregado.dart';
import 'package:bate_ponto_web/comum/modelos/empregado.dart';
import 'package:bate_ponto_web/comum/widgets/cartao_empregado.dart';
import 'package:bate_ponto_web/comum/widgets/jornadas.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bate_ponto_web/comum/funcoes/get_token.dart';
import 'comum/widgets/menu_scaffold.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

class Empregados extends StatefulWidget {
  static String rota = '/empregados';
  static String titulo = 'Empregados';

  @override
  EmpregadosState createState() => new EmpregadosState();
}

class EmpregadosState extends State<Empregados> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  final _jornadaKey = new GlobalKey<JornadasState>();
  final TextEditingController _pesquisa = TextEditingController();

  var nome = "";
  var codJornada = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<List<Empregado>> buscaEmpregados({nome = '', codJornada = 0}) async {
    final token = await getToken();
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

  @override
  Widget build(BuildContext context) {
    final pesquisa = SizedBox(
      width: 700,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            width: 200,
            child: Jornadas(
              key: _jornadaKey,
              valorInicial: this.codJornada,
              widgetCompleto: false,
            ),
          ),
          SizedBox(
            width: 450,
            child: TextField(
              controller: _pesquisa,
              decoration: InputDecoration(
                hintText: "Pesquisar empregado",
                suffixIcon: FlatButton(
                  child: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      this.nome = _pesquisa.text;
                      this.codJornada = _jornadaKey.currentState.codigoJornada;
                    });
                  },
                ),
              ),
            ),
          )
        ],
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
              empregado.bancoHoras =
                  new Duration(minutes: empregado.bancoHoras).inHours;
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CartaoEmpregado(
                  empregado: empregado,
                  empregadosState: this,
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
