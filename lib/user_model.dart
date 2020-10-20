import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/helpers/firebaseHelper.dart';
import 'package:my_app/objects/categoria.dart';
import 'package:path/path.dart';
import 'package:supercharged/supercharged.dart';

import 'objects/financia.dart';

class UserModel extends ChangeNotifier {
  FirebaseHelper helper = FirebaseHelper();

  UserModel() {
    getAllCategoria();
    getAllFinancias();
  }

  bool _loading = false;

  double _receitas = 0.0;
  double _despesas = 0.0;
  double _balanco = 0.0;
  String _search = "";

  String get search => _search;

  set search(String value) {
    _search = value;
    notifyListeners();
  }

  List<Financia> _financias = [];
  List<Categoria> categorias = [];

  Color colorFromCategoria(String categoria) {
    try {
      return categorias.firstWhere((element) => element.id == categoria).color;
    } catch (e) {
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

  Future<void> getAllFinancias() async {
    loading = true;
    _financias = await helper.getAllFinancia();
    loading = false;
    _recalcule();
  }

  Future<void> getAllCategoria() async {
    categorias = await helper.getAllCategoria();
  }

  Future<void> saveFinancia(Financia financia, VoidCallback onError) async {
    try {
      print(financia.toString());
      if (financia.image == '')
        financia.image =
            'https://static.wikia.nocookie.net/beekeepers21/images/c/c8/NotFound.png/revision/latest?cb=20200523132136';
      else {
        StorageReference ref = FirebaseStorage.instance.ref();
        StorageTaskSnapshot addImg =
            await ref.child("${basename(financia.image)}").putFile(File(financia.image)).onComplete;
        if (addImg.error == null) {
          financia.image = await addImg.ref.getDownloadURL();
          print("added to Firebase Storage");
        } else {
          throw Exception(addImg.error);
        }
      }
      financia = await helper.saveFinancia(financia);
      financias.add(financia);
      search = '';
      _recalcule();
    } catch (e) {
      print(e);
      onError();
    }
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
