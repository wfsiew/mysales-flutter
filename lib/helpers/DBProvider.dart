import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mysales_flutter/models/customer.dart';
import 'package:mysales_flutter/models/customer_query.dart';

class DBProvider {

  Database db;

  DBProvider({
    this.db
  });

  Future<void> openDB() async {
    Directory directory = await getExternalStorageDirectory();
    String path = join(directory.path, 'app.db');
    db = await openDatabase(path);
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

  Future<List<Customer>> getCustomers1() async {
    List<Customer> ls = <Customer>[];
    var lx = await db.rawQuery('select distinct cust_code, cust_name from sales order by cust_name');
    ls = lx.map<Customer>((x) => Customer.fromData(x)).toList();
    return ls;
  }

  Future<List<String>> getItems() async {
    List<String> ls = <String>[];
    var lx = await db.rawQuery('select distinct item_name from sales order by item_name');
    ls = lx.map<String>((x) => x['item_name']).toList();
    return ls;
  }

  Future<List<String>> getTerritories() async {
    List<String> ls = <String>[];
    var lx = await db.rawQuery("select distinct territory from sales where territory not in ('0') order by territory");
    ls = lx.map<String>((x) => x['territory']).toList();
    return ls;
  }

  Future<List<String>> getProductGroups() async {
    List<String> ls = <String>[];
    var lx = await db.rawQuery("select distinct product_group from sales where product_group not in ('0') order by product_group");
    ls = lx.map<String>((x) => x['product_group']).toList();
    return ls;
  }

  Future<List<Customer>> filterCustomer(CustomerQuery q, String sort) async {
    List<Customer> ls = <Customer>[];
    bool and = false;

    await openDB();
    StringBuffer sb = StringBuffer();
    
    if (sort.isEmpty) {
      sort = 'cust_name';
    }

    if ('cust_name' == sort) {
      sb.write('select distinct cust_code, cust_name from sales');
    }

    else {
      sb.write('select cust_code, cust_name, sum(sales_unit) salesu, sum(sales_value) salesv,');
      sb.write(' sum(bonus_unit) bonusu from sales');
    }

    if (q.name.isNotEmpty || 
      q.item.isNotEmpty || 
      q.productGroup.isNotEmpty || 
      q.territory.isNotEmpty || 
      q.period.isNotEmpty || 
      q.year.isNotEmpty) {
      sb.write(' where');

      if (q.name.isNotEmpty) {
        sb.write(" cust_name like '%${q.name}%'");
        and = true;
      }

      if (q.item.isNotEmpty) {
        if (and) {
          sb.write(" and item_name in (${q.item})");
        } 
        
        else {
          sb.write(" item_name in (${q.item})");
          and = true;
        }
      }

      if (q.productGroup.isNotEmpty) {
        if (and) {
          sb.write(" and product_group in (${q.productGroup})");
        }
        
        else {
          sb.write(" product_group in (${q.productGroup})");
          and = true;
        }
      }

      if (q.territory.isNotEmpty) {
        if (and) {
          sb.write(" and territory in (${q.territory})");
        }
          
        else {
          sb.write(" territory in (${q.territory})");
          and = true;
        }
      }

      if (q.period.isNotEmpty) {
        if (and) {
          sb.write(" and period in (${q.period})");
        }
        
        else {
          sb.write(" period in (${q.period})");
          and = true;
        }
      }

      if (q.year.isNotEmpty) {
        if (and) {
          sb.write(" and year in (${q.year})");
        }
        
        else {
          sb.write(" year in (${q.year})");
        }
      }
    }

    if ('cust_name' != sort) {
      sb.write(' group by cust_code, cust_name');
    }

    sb.write(' order by $sort');
    String s = sb.toString();
    print(s);
    var lx = await db.rawQuery(s);
    ls = lx.map<Customer>((x) => Customer.fromData(x)).toList();
    return ls;
  }
}