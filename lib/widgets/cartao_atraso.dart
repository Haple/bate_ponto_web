import 'package:bate_ponto_web/modelos/atraso.dart';
import 'package:flutter/material.dart';


class CartaoAtraso extends StatefulWidget {
  final Atraso atraso;

  const CartaoAtraso({
    @required this.atraso,
  });

  @override
  State<StatefulWidget> createState() => _CartaoAtrasoState();
}

class _CartaoAtrasoState extends State<CartaoAtraso> {
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
                    "${widget.atraso.nome}",
                    style: Theme.of(context).textTheme.headline6,
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
                        "E-mail: ${widget.atraso.email}",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        "Jornada: ${widget.atraso.jornada}",
                        style: Theme.of(context).textTheme.bodyText2,
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
                        "Hora da Entrada",
                        // style: Theme.of(context).textTheme.body1,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(widget.atraso.dataHoraAtraso,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.red.shade500,
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
