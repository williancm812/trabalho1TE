import 'package:flutter/material.dart';
import 'package:my_app/objects/categoria.dart';
import 'package:my_app/objects/financia.dart';
import 'package:provider/provider.dart';
import 'package:supercharged/supercharged.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../user_model.dart';

void showGraffic(BuildContext context) {
  List<Financia> valores = context.read<UserModel>().financias.where((element) => element.tipo == 1).toList();
  List<Categoria> categorias = context.read<UserModel>().categorias;
  int tipoSelected = 1;
  showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(builder: (context, setState) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.9,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tipoSelected == 1 ? "Receitas por Categoria" : "Despesas por Categoria",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 24
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: tipoSelected == 1
                                ? null
                                : () {
                                    setState(() {
                                      valores = context
                                          .read<UserModel>()
                                          .financias
                                          .where((element) => element.tipo == 1)
                                          .toList();
                                      tipoSelected = 1;
                                    });
                                  },
                            child: Row(
                              children: [
                                Icon(tipoSelected == 1 ? Icons.radio_button_checked : Icons.radio_button_unchecked),
                                const SizedBox(width: 16),
                                Text(
                                  "Receita",
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: tipoSelected == 2
                                ? null
                                : () {
                                    setState(() {
                                      valores = context
                                          .read<UserModel>()
                                          .financias
                                          .where((element) => element.tipo == 2)
                                          .toList();
                                      tipoSelected = 2;
                                    });
                                  },
                            child: Row(
                              children: [
                                Icon(tipoSelected == 2 ? Icons.radio_button_checked : Icons.radio_button_unchecked),
                                const SizedBox(width: 16),
                                Text(
                                  "Despesa",
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: SfCircularChart(
                          tooltipBehavior: TooltipBehavior(enable: true, format: 'point.x: point.y%'),
                          legend: Legend(
                            backgroundColor: Color.fromARGB(255, 242, 242, 242),
                            isVisible: true,
                            isResponsive: true,
                            position: LegendPosition.top,
                            overflowMode: LegendItemOverflowMode.wrap,
                          ),
                          series: categorias
                              .map(
                                (e) => PieSeries<Categoria, String>(
                                  explode: true,
                                  animationDuration: 1500,
                                  explodeIndex: 0,
                                  explodeOffset: '10%',
                                  enableTooltip: true,
                                  dataSource: categorias,
                                  enableSmartLabels: true,
                                  xValueMapper: (Categoria data, _) => data.descricao,
                                  yValueMapper: (Categoria data, _) => (valores
                                              .where((element) => element.categoria == data.id)
                                              .toList()
                                              .sumByDouble((a) => a.valor) /
                                          valores.sumByDouble((a) => a.valor) *
                                          100)
                                      .toStringAsFixed(2)
                                      .toDouble(),
                                  dataLabelSettings: DataLabelSettings(
                                    labelPosition: ChartDataLabelPosition.outside,
                                    alignment: ChartAlignment.far,
                                    isVisible: false,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: RaisedButton(
                          onPressed: () => Navigator.pop(context),
                          textColor: Colors.white,
                          color: Colors.blue,
                          child: Text("Voltar"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      });
}
