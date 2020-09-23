import 'package:flutter/material.dart';
import 'package:my_app/objects/financia.dart';

class CardFinancia extends StatelessWidget {
  final Financia financia;

  const CardFinancia({@required this.financia});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 40,
              color: Financia.colorFromCategoria(financia.categoria),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  financia.descricao,
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  financia.data,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            Spacer(),
            Text(
              "R\$ ${financia.valor.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 18,
                color: financia.tipo == 1 ? Colors.green : Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
