import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Financia {
  String id;
  String descricao;
  String data;
  String image;
  double valor;
  int tipo = 0;
  String categoria = "";

  Financia();

  Financia.fromDocument(QueryDocumentSnapshot doc) {
    id = doc.id;
    descricao = doc.data()['descricao'];
    data = doc.data()['data'];
    valor = double.parse(doc.data()['valor']);
    categoria = doc.data()['categoria'];
    image = doc.data()['image'];
    tipo = doc.data()['tipo'];
  }

  Map toMapFirebase() {
    Map<String, dynamic> map = {
      'categoria': categoria,
      'data': data,
      'descricao': descricao,
      'tipo': tipo,
      'image': image,
      'valor': valor.toString(),
    };

    return map;
  }

  static Color colorFromTipo(int tipo) {
    switch (tipo) {
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

  @override
  String toString() {
    return 'Financia{id: $id, descricao: $descricao, data: $data, image: $image, valor: $valor, tipo: $tipo, categoria: $categoria}';
  }
}
