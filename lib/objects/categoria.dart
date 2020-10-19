import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Categoria {
  String id;
  String descricao;
  Color color;

  Categoria({
    @required this.id,
    @required this.descricao,
    @required this.color,
  });

  Categoria.fromDocument(QueryDocumentSnapshot doc) {
    id = doc.id;
    descricao = doc.data()['descricao'];
    color = Color(int.parse(doc.data()['color']));
  }
}
