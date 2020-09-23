import 'package:flutter/material.dart';
import 'package:my_app/helpers/categoryList.dart';
import 'package:my_app/helpers/helper.dart';

class Financia {
  int id;
  String descricao;
  String data;
  double valor;
  int tipo = 0;
  int categoria = 0;

  Financia();

  Financia.fromMap(Map map) {
    id = map["ID"];
    descricao = map[descricaoFinancia];
    data = map[dataFinancia];
    valor = map[valorFinancia];
    categoria = map[categoriaFinancia];
    tipo = map[tipoFinancia];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      descricaoFinancia: descricao,
      valorFinancia: valor,
      dataFinancia: data,
      categoriaFinancia: categoria,
      tipoFinancia: tipo,
    };
    if (id != null) {
      map["ID"] = id;
    }
    return map;
  }

  static Color colorFromTipo(int tipo) {
    switch(tipo){
      case 1:
        return Colors.green;
        break;
      case 2:
        return Colors.red;
        break;
      default:
        return Colors.black87;
        break;
    }
  }

  static Color colorFromCategoria(int categoria) {
    switch(categoria){
      case 0:
        return categorias.firstWhere((element) => element.id == 0).color;
        break;
      case 1:
        return categorias.firstWhere((element) => element.id == 1).color;
        break;
      case 2:
        return categorias.firstWhere((element) => element.id == 2).color;
        break;
      case 3:
        return categorias.firstWhere((element) => element.id == 3).color;
        break;
      default:
        return Colors.black87;
        break;
    }
  }
}
