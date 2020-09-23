import 'package:flutter/cupertino.dart';

import 'helpers/helper.dart';
import 'objects/financia.dart';

class UserModel extends ChangeNotifier {
  DbHelper helper = DbHelper();

  UserModel() {
    _getAllFinancias();
  }

  bool _loading = false;

  double _receitas = 0.0;
  double _despesas = 0.0;
  double _balanco = 0.0;

  List<Financia> _financias = [];

  void _recalcule() {
    _receitas = 0.0;
    _despesas = 0.0;
    financias.where((element) => element.tipo == 1).toList().forEach((element) {
      _receitas += element.valor;
    });
    financias.where((element) => element.tipo == 2).toList().forEach((element) {
      _despesas += element.valor;
    });
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
