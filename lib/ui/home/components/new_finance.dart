import 'package:flutter/material.dart';
import 'package:my_app/helpers/acresZero.dart';
import 'package:my_app/helpers/categoryList.dart';
import 'package:my_app/helpers/validators.dart';
import 'package:my_app/objects/categoria.dart';
import 'package:my_app/objects/financia.dart';

// ignore: must_be_immutable
class NewFinance extends StatefulWidget {
  VoidCallback onCancel;
  Function changeTipo;
  Function onSave;

  NewFinance({@required this.onCancel, @required this.changeTipo, @required this.onSave});

  @override
  _NewFinanceState createState() => _NewFinanceState();
}

class _NewFinanceState extends State<NewFinance> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Financia financia = Financia();

  DateTime selectedDate = DateTime.now();

  TextEditingController dataController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nova Financia",
                      style: TextStyle(fontSize: 28),
                    ),
                    Divider(color: Colors.white),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Descrição", labelStyle: TextStyle(color: Colors.white)),
                      validator: (a) {
                        if (a.length < 3) return 'Texto muito curto';
                        return null;
                      },
                      onSaved: (a) => financia.descricao = a,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Valor", labelStyle: TextStyle(color: Colors.white)),
                      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                      validator: (a) {
                        if (!validNumber(a)) return 'Valor inválido !!!';
                        return null;
                      },
                      onSaved: (a) => financia.valor = double.parse(a),
                    ),
                    InkWell(
                      onTap: () async => await _selectDate(context),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Data", labelStyle: TextStyle(color: Colors.white)),
                        controller: dataController,
                        enabled: false,
                        validator: (a) => validDate(a),
                        onSaved: (a) => financia.data = a,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            widget.changeTipo(1);
                            setState(() {
                              financia.tipo = 1;
                            });
                          },
                          child: Row(
                            children: [
                              Icon(financia.tipo == 1 ? Icons.radio_button_checked : Icons.radio_button_unchecked),
                              const SizedBox(width: 16),
                              Text(
                                "Receita",
                                style: TextStyle(fontSize: 24),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            widget.changeTipo(2);
                            setState(() {
                              financia.tipo = 2;
                            });
                          },
                          child: Row(
                            children: [
                              Icon(financia.tipo == 2 ? Icons.radio_button_checked : Icons.radio_button_unchecked),
                              const SizedBox(width: 16),
                              Text(
                                "Despesa",
                                style: TextStyle(fontSize: 24),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text("Categoria", style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 20),
                        DropdownButton(
                          hint: Text("Escolher: "),
                          items: categorias
                              .map((item) => DropdownMenuItem(
                                    child: Row(
                                      children: [
                                        Container(height: 15,width: 15, color: item.color),
                                        const SizedBox(width: 8),
                                        Text(item.descricao, style: TextStyle(fontSize: 20)),
                                      ],
                                    ),
                                    value: item,
                                  ))
                              .toList(),
                          onChanged: (Categoria newVal) async {
                            setState(() {
                              financia.categoria = newVal.id;
                            });
                            FocusScope.of(context).unfocus();
                          },
                          value: categorias.firstWhere((element) => element.id == financia.categoria),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: RaisedButton(
                  onPressed: widget.onCancel,
                  color: Colors.red,
                  child: Text("Cancelar"),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      if (financia.tipo != 0) {
                        _formKey.currentState.save();
                        await widget.onSave(financia);
                      }
                    }
                  },
                  child: Text("Salvar"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context, initialDate: selectedDate, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      dataController.text = acresZero(picked.day) + "/" + acresZero(picked.month) + "/" + picked.year.toString();
    selectedDate = picked;
  }
}
