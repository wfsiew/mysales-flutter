import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mysales_flutter/models/target.dart';
import 'package:mysales_flutter/helpers/utils.dart';

class TargetDBProvider {

  Database db;

  TargetDBProvider({
    this.db
  });

  Future<void> openDB() async {
    Directory directory = await getExternalStorageDirectory();
    String path = join(directory.path, 'target.db');
    db = await openDatabase(path);
  }

  Future<void> closeDB() async {
    await db?.close();
  }

  Future<List<String>> getProductGroups() async {
    List<String> ls = <String>[];
    var lx = await db.rawQuery("select distinct product_group from target order by product_group");
    ls = lx.map<String>((x) => x['product_group']).toList();
    return ls;
  }

  Future<Map<String, Target>> getHalfYearlyTarget(String h) async {
    Map<String, Target> m = {};
    int year = DateTime.now().year;
    String months = getHalfYearMonths(h);

    String s = '''select product_group, sum(sales_value) salesv from target 
                  where year = $year 
                  and month in ($months)
                  group by product_group
    ''';
    var lx = await db.rawQuery(s);
    lx.forEach((x) {
      Target o = Target();
      o.productGroup = x['product_group'];
      o.year = year;
      o.value = x['salesv'];
      m[o.productGroup] = o;
    });

    return m;
  }

  Future<Map<String, Target>> getQuarterlyTarget(String quarter) async {
    Map<String, Target> m = {};
    int year = DateTime.now().year;
    String months = getQuarterMonths(quarter);

    String s = '''select product_group, sum(sales_value) salesv from target
                  where year = $year
                  and month in ($months)
                  group by product_group
    ''';
    var lx = await db.rawQuery(s);
    lx.forEach((x) {
      Target o = Target();
      o.productGroup = x['product_group'];
      o.year = year;
      o.value = x['salesv'];
      m[o.productGroup] = o;
    });

    return m;
  }

  Future<Map<String, Target>> getMonthlyTarget(String months) async {
    Map<String, Target> m = {};
    int year = DateTime.now().year;

    String s = '''select product_group, sum(sales_value) salesv from target
                  where year = $year
                  and month in ($months)
                  group by product_group
    ''';
    var lx = await db.rawQuery(s);
    lx.forEach((x) {
      Target o = Target();
      o.productGroup = x['product_group'];
      o.year = year;
      o.value = x['salesv'];
      m[o.productGroup] = o;
    });

    return m;
  }
}