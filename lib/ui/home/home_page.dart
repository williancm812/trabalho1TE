import 'package:flutter/material.dart';
import 'package:my_app/objects/financia.dart';
import 'package:my_app/ui/home/components/card_financia.dart';
import 'package:my_app/ui/home/components/new_finance.dart';
import 'package:my_app/ui/home/utils/show_graffic.dart';
import 'package:my_app/user_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("App Financias"),
        backgroundColor: Colors.black87,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            if (context.read<UserModel>().financias.length > 2)
              showGraffic(context);
            else
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 2),
                  elevation: 2,
                  backgroundColor: Colors.red,
                  content: Container(
                    height: 40,
                    child: Center(child: Text("Poucas finâncias para montar as estatísticas")),
                  ),
                ),
              );
          },
          color: Colors.white,
          icon: Icon(Icons.category),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _addNewFinance();
            },
            icon: Icon(Icons.add),
            color: Colors.white,
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Consumer<UserModel>(builder: (_, userModel, __) {
        return Column(
          children: [
            Expanded(
              child: userModel.loading
                  ? Center(child: CircularProgressIndicator())
                  : userModel.financias.length == 0
                      ? Center(
                          child: Container(
                            child: Text(
                              "Não existem Financia no momento",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(10.0),
                          shrinkWrap: true,
                          itemCount: userModel.financias.length,
                          itemBuilder: (_, index) {
                            return CardFinancia(
                              financia: userModel.financias[index],
                            );
                          },
                        ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black87,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(1, 0),
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  line(
                    descricao: "Receitas",
                    value: "R\$ ${userModel.receitas.toStringAsFixed(2)}",
                    color: Colors.green,
                  ),
                  line(
                    descricao: "Despesas",
                    value: "R\$ ${userModel.despesas.toStringAsFixed(2)}",
                    color: Colors.red,
                  ),
                  line(
                    descricao: "Balanço Geral",
                    value: "R\$ ${userModel.balanco.toStringAsFixed(2)}",
                    color: Colors.blue,
                    fontSize: 22,
                  ),
                ],
              ),
            )
          ],
        );
      }),
    );
  }

  Widget line({
    @required String descricao,
    @required String value,
    @required Color color,
    double fontSize = 18,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              descricao,
              style: TextStyle(fontSize: fontSize, color: Colors.white),
            ),
            Spacer(),
            Text(
              value,
              style: TextStyle(fontSize: fontSize, color: color),
            ),
          ],
        ),
        Divider(color: Colors.white),
        const SizedBox(height: 8),
      ],
    );
  }

  _addNewFinance() {
    Color color = Financia.colorFromTipo(0);
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      duration: Duration(days: 1),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      backgroundColor: color,
      content: NewFinance(
        onCancel: () => _scaffoldKey.currentState.hideCurrentSnackBar(),
        changeTipo: (tipo) => setState(() {
          color = Financia.colorFromTipo(tipo);
          print(color.toString());
          print(tipo);
        }),
        onSave: (financia) async {
          await context.read<UserModel>().saveFinancia(financia);
          _scaffoldKey.currentState.hideCurrentSnackBar();
        },
      ),
    ));
  }
}
