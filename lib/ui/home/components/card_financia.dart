import 'package:flutter/material.dart';
import 'package:my_app/helpers/progressDialog.dart';
import 'package:my_app/objects/financia.dart';
import 'package:provider/provider.dart';

import '../../../user_model.dart';

class CardFinancia extends StatelessWidget {
  final Financia financia;
  final VoidCallback onTap;

  const CardFinancia({@required this.financia,@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(financia.id),
      onDismissed: (a) async {
        progressDialog(context);
        await context.read<UserModel>().deleteFinancia(financia);
        Navigator.pop(context);
      },
      child: InkWell(
        onTap: onTap,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(
                      financia.image,
                    ),
                  ),
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
                    Text(
                      context
                          .watch<UserModel>()
                          .categorias
                          .firstWhere((element) => element.id == financia.categoria)
                          .descricao,
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
        ),
      ),
    );
  }
}
