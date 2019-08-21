import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {

  Database db;

  DBProvider({
    this.db
  });

  Future<Database> openDB() async {
    Directory directory = await getExternalStorageDirectory();
    String path = join(directory.path, 'app.db');
    db = await openDatabase(path);
    return db;
  }

  Future<void> closeDB() async {
    await db?.close();
  }

  Future<List<String>> getCustomers() async {
    List<String> ls = <String>[];
    var lx = await db.rawQuery('select distinct cust_name from sales order by cust_name');
    ls = lx.map<String>((x) => x['cust_name']).toList();
    return ls;
  }

  getCustomers1() {
    
  }
}