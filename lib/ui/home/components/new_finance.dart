import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/helpers/CustomIconButton.dart';
import 'package:my_app/helpers/acresZero.dart';
import 'package:my_app/helpers/progressDialog.dart';
import 'package:my_app/helpers/validators.dart';
import 'package:my_app/objects/categoria.dart';
import 'package:my_app/objects/financia.dart';
import 'package:provider/provider.dart';

import '../../../user_model.dart';

// ignore: must_be_immutable
class NewFinance extends StatefulWidget {
  VoidCallback onCancel;
  Function changeTipo;
  Function onSave;
  Financia financia;

  NewFinance({@required this.onCancel, @required this.changeTipo, @required this.onSave, this.financia});

  @override
  _NewFinanceState createState() => _NewFinanceState();
}

class _NewFinanceState extends State<NewFinance> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Financia financia = Financia();

  DateTime selectedDate = DateTime.now();

  TextEditingController dataController = TextEditingController();
  String getImage = "";

  @override
  void initState() {
    super.initState();
    dataController..text = widget.financia != null ? widget.financia.data : '';
    if (widget.financia != null) {
      financia = widget.financia;
      getImage = financia.image;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      "Nova Financia",
                      style: TextStyle(fontSize: 28),
                    ),
                    Divider(color: Colors.white),
                    Container(
                      height: 100,
                      width: 100,
                      child: Stack(
                        children: [
                          Container(
                            height: 90,
                            width: 90,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: widget.financia != null
                                  ? NetworkImage(widget.financia.image)
                                  : getImage.isEmpty
                                      ? NetworkImage(
                                          "https://static.wikia.nocookie.net/beekeepers21/images/c/c8/NotFound.png/revision/latest?cb=20200523132136",
                                        )
                                      : FileImage(
                                          File(getImage),
                                        ),
                            ),
                          ),
                          Positioned(
                            bottom: 2,
                            left: 50,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: Colors.black,
                              ),
                              child: CustomIconButton(
                                icon: Icons.camera_alt,
                                color: Colors.white,
                                onTap: widget.financia != null
                                    ? null
                                    : () async {
                                        PickedFile image = await ImagePicker().getImage(source: ImageSource.gallery);

                                        setState(() {
                                          getImage = image.path;
                                        });
                                      },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Descrição", labelStyle: TextStyle(color: Colors.white)),
                      enabled: widget.financia == null,
                      initialValue: widget.financia?.descricao ?? '',
                      validator: (a) {
                        if (a.length < 3) return 'Texto muito curto';
                        return null;
                      },
                      onSaved: (a) => financia.descricao = a,
                    ),
                    TextFormField(
                      initialValue: widget.financia != null ? widget.financia.valor.toString() : '',
                      enabled: widget.financia == null,
                      decoration: InputDecoration(labelText: "Valor", labelStyle: TextStyle(color: Colors.white)),
                      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                      validator: (a) {
                        if (!validNumber(a)) return 'Valor inválido !!!';
                        return null;
                      },
                      onSaved: (a) => financia.valor = double.parse(a),
                    ),
                    InkWell(
                      onTap: widget.financia != null ? null : () async => await _selectDate(context),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Data", labelStyle: TextStyle(color: Colors.white)),
                        controller: dataController,
                        enabled: false,
                        validator: (a) => validDate(a),
                        onSaved: (a) => financia.data = a,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FormField(
                      builder: (_) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: widget.financia != null
                                  ? null
                                  : () {
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
                              onTap: widget.financia != null
                                  ? null
                                  : () {
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
                        );
                      },
                      validator: (a) {
                        if (financia.tipo == null) return 'Selececiona um tipo de Financia';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text("Categoria", style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 20),
                        widget.financia != null
                            ? Row(
                                children: [
                                  Container(
                                      height: 15,
                                      width: 15,
                                      color: context
                                          .watch<UserModel>()
                                          .categorias
                                          .firstWhere((element) => element.id == widget.financia.categoria)
                                          .color),
                                  const SizedBox(width: 8),
                                  Text(
                                      context
                                          .watch<UserModel>()
                                          .categorias
                                          .firstWhere((element) => element.id == widget.financia.categoria)
                                          .descricao,
                                      style: TextStyle(fontSize: 20)),
                                ],
                              )
                            : DropdownButton(
                                hint: Text("Escolher: "),
                                items: context
                                    .watch<UserModel>()
                                    .categorias
                                    .map((item) => DropdownMenuItem(
                                          child: Row(
                                            children: [
                                              Container(height: 15, width: 15, color: item.color),
                                              const SizedBox(width: 8),
                                              Text(item.descricao, style: TextStyle(fontSize: 20)),
                                            ],
                                          ),
                                          value: item,
                                        ))
                                    .toList(),
                                onChanged: (Categoria newVal) async {
                                  print(newVal.id);
                                  setState(() {
                                    financia.categoria = newVal.id;
                                  });
                                  FocusScope.of(context).unfocus();
                                },
                                value: financia.categoria == ''
                                    ? null
                                    : context
                                        .watch<UserModel>()
                                        .categorias
                                        .firstWhere((element) => element.id == financia.categoria),
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: RaisedButton(
                  onPressed: widget.onCancel,
                  color: widget.financia != null ? Colors.blue : Colors.red,
                  child: Text(widget.financia != null ? "Voltar" : "Cancelar"),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: RaisedButton(
                  color: widget.financia != null ? Colors.red : Colors.blue,
                  onPressed: widget.financia != null
                      ? () async {
                          progressDialog(context);
                          await context.read<UserModel>().deleteFinancia(financia);
                          context.read<UserModel>().search = '';

                          Navigator.pop(context);
                          widget.onCancel();
                        }
                      : () async {
                          if (_formKey.currentState.validate()) {
                            if (financia.tipo != 0 && financia.categoria != '') {
                              _formKey.currentState.save();
                              financia.image = getImage;
                              await widget.onSave(financia);
                            }
                          }
                        },
                  child: Text(widget.financia != null ? "Deletar" : "Salvar"),
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
