import 'dart:async';

import 'package:my_app/objects/financia.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String financiaTable = "financiaTable";
final String descricaoFinancia = "descricao";
final String valorFinancia = "valor";
final String dataFinancia = "data";
final String categoriaFinancia = "categoria";
final String tipoFinancia = "tipo";


class DbHelper {
  static final DbHelper _instance = DbHelper.internal();

  factory DbHelper() => _instance;

  DbHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "trabdb.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {


      await db.execute("CREATE TABLE $financiaTable("
          " ID INTEGER PRIMARY KEY AUTOINCREMENT,"
          " $descricaoFinancia TEXT,"
          " $dataFinancia TEXT,"
          " $categoriaFinancia INTEGER,"
          " $tipoFinancia INTEGER,"
          " $valorFinancia REAL"
          " )");
    });
  }

  Future<Financia> saveFinancia(Financia financia) async {
    print(financia.toMap());
    Database dbContact = await db;
    financia.id = await dbContact.insert(financiaTable, financia.toMap());
    return financia;
  }

  Future<int> deleteFinancia(int id) async {
    Database dbContact = await db;
    return await dbContact
        .delete(financiaTable, where: "ID = ?", whereArgs: [id]);
  }

  Future<int> updateFinancia(Financia financia) async {
    Database dbContact = await db;
    return await dbContact.update(financiaTable, financia.toMap(),
        where: "ID = ?", whereArgs: [financia.id]);
  }

  Future<List<Financia>> getAllFinancia() async {
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery("SELECT * FROM $financiaTable");
    List<Financia> listContact = List();
    for (Map m in listMap) {
      listContact.add(Financia.fromMap(m));
    }
    return listContact;
  }

  Future close() async {
    Database dbContact = await db;
    dbContact.close();
  }
}
