import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/objects/categoria.dart';
import 'package:my_app/objects/financia.dart';

final String users = "users";
final String financias = "financias";
final String categorias = "categorias";
final String usuarioId1 = "usuario1";

class FirebaseHelper {
  final financiasReference = FirebaseFirestore.instance.collection(users).doc(usuarioId1).collection(financias);
  final categorysReference = FirebaseFirestore.instance.collection(users).doc(usuarioId1).collection(categorias);
  final usersReference = FirebaseFirestore.instance.collection(users);

  Future<Financia> saveFinancia(Financia financia) async {
    DocumentReference doc = await financiasReference.add(financia.toMapFirebase());
    financia.id = doc.id;
    return financia;
  }

  Future<int> deleteFinancia(String id) async {
    try {
      await financiasReference.doc(id).delete();
      return 1;
    } catch (e) {
      return 0;
    }
  }

  Future<int> updateFinancia(Financia financia) async {
    try {
      await financiasReference.doc(financia.id).set(financia.toMapFirebase());
      return 1;
    } catch (e) {
      return 0;
    }
  }

  Future<List<Financia>> getAllFinancia() async {
    List<Financia> list = List();
    QuerySnapshot docs = await financiasReference.get();

    for (QueryDocumentSnapshot m in docs.docs) {
      print(m.data());
      list.add(Financia.fromDocument(m));
    }
    return list;
  }

  Future<List<Categoria>> getAllCategoria() async {
    List<Categoria> list = List();
    QuerySnapshot docs = await categorysReference.get();

    for (QueryDocumentSnapshot m in docs.docs) {
      print(m.data());
      list.add(Categoria.fromDocument(m));
    }
    return list;
  }
}
