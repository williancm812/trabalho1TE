import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/helpers/firebaseHelper.dart';
import 'package:my_app/objects/categoria.dart';
import 'package:supercharged/supercharged.dart';

import 'objects/financia.dart';

class UserModel extends ChangeNotifier {
  FirebaseHelper helper = FirebaseHelper();

  UserModel() {
    helper.getAllCategoria().then((value) => categorias = value);
    _getAllFinancias();
  }

  bool _loading = false;

  double _receitas = 0.0;
  double _despesas = 0.0;
  double _balanco = 0.0;

  List<Financia> _financias = [];
  List<Categoria> categorias = [];

  Color colorFromCategoria(String categoria) {
    try{
      return categorias.firstWhere((element) => element.id == categoria).color;
    } catch(e){
      return Colors.transparent;
    }
  }

  void _recalcule() {
    _receitas = 0.0;
    _despesas = 0.0;
    _receitas = financias.where((element) => element.tipo == 1).toList().sumByDouble((element) => element.valor);
    _despesas = financias.where((element) => element.tipo == 2).toList().sumByDouble((element) => element.valor);
    balanco = _receitas - _despesas;
  }

  void _getAllFinancias() async {
    loading = true;
    _financias = await helper.getAllFinancia();
    loading = false;
    _recalcule();
  }

  Future<void> saveFinancia(Financia financia) async {
    financia = await helper.saveFinancia(financia);
    financias.add(financia);
    _recalcule();
  }

  Future<void> deleteFinancia(Financia financia) async {
    await helper.deleteFinancia(financia.id);
    financias.removeWhere((element) => element.id == financia.id);
    _recalcule();
  }

  double get despesas => _despesas;

  set despesas(double value) {
    _despesas = value;
    notifyListeners();
  }

  double get receitas => _receitas;

  set receitas(double value) {
    _receitas = value;
    notifyListeners();
  }

  double get balanco => _balanco;

  set balanco(double value) {
    _balanco = value;
    notifyListeners();
  }

  List<Financia> get financias => _financias;

  set financias(List<Financia> value) {
    _financias = value;

    notifyListeners();
  }

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
