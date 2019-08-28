import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mysales_flutter/models/customer.dart';
import 'package:mysales_flutter/models/customer_address.dart';
import 'package:mysales_flutter/models/customer_item.dart';
import 'package:mysales_flutter/models/sales_summary.dart';
import 'package:mysales_flutter/models/target.dart';
import 'package:mysales_flutter/models/customer_query.dart';
import 'package:mysales_flutter/helpers/utils.dart';

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
    
    if (isEmpty(sort)) {
      sort = 'cust_name';
    }

    if ('cust_name' == sort) {
      sb.write('select distinct cust_code, cust_name from sales');
    }

    else {
      sb.write('select cust_code, cust_name, sum(sales_unit) salesu, sum(sales_value) salesv,');
      sb.write(' sum(bonus_unit) bonusu from sales');
    }

    if (isNotEmpty(q.name) || 
      isNotEmpty(q.item) || 
      isNotEmpty(q.productGroup) || 
      isNotEmpty(q.territory) || 
      isNotEmpty(q.period) || 
      isNotEmpty(q.year)) {
      sb.write(' where');

      if (isNotEmpty(q.name)) {
        sb.write(" cust_name like '%${q.name}%'");
        and = true;
      }

      if (isNotEmpty(q.item)) {
        if (and) {
          sb.write(" and item_name in (${q.item})");
        } 
        
        else {
          sb.write(" item_name in (${q.item})");
          and = true;
        }
      }

      if (isNotEmpty(q.productGroup)) {
        if (and) {
          sb.write(" and product_group in (${q.productGroup})");
        }
        
        else {
          sb.write(" product_group in (${q.productGroup})");
          and = true;
        }
      }

      if (isNotEmpty(q.territory)) {
        if (and) {
          sb.write(" and territory in (${q.territory})");
        }
          
        else {
          sb.write(" territory in (${q.territory})");
          and = true;
        }
      }

      if (isNotEmpty(q.period)) {
        if (and) {
          sb.write(" and period in (${q.period})");
        }
        
        else {
          sb.write(" period in (${q.period})");
          and = true;
        }
      }

      if (isNotEmpty(q.year)) {
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
    var lx = await db.rawQuery(s);
    ls = lx.map<Customer>((x) => Customer.fromData(x)).toList();
    return ls;
  }

  Future<CustomerAddress> getCustomerAddress(String code, String name) async {
    String s = '''select cust_addr1, cust_addr2, cust_addr3, postal_code, area, territory, telephone, contact_person 
                  from sales where cust_code = '$code' and cust_name = '$name'
    ''';
    var lx = await db.rawQuery(s);
    Map<String, dynamic> m = lx.first;
    return CustomerAddress.fromData(m);
  }

  Future<Map<String, List<CustomerItem>>> getItemsByCustomer(
    String code, String name, CustomerQuery q, String sort, CustomerAddress addr, List<String> ls) async {
    Map<String, List<CustomerItem>> m = {};
    await openDB();
    var address = await getCustomerAddress(code, name);
    addr.copy(address);
    StringBuffer sb = StringBuffer();
    StringBuffer sa = StringBuffer();

    if (isEmpty(sort)) {
      sort = 'salesv desc';
    }

    sb.write("select period, year, item_name, sum(sales_unit) salesu, sum(sales_value) salesv, sum(bonus_unit) bonusu from sales");
    sb.write(" where cust_code = '$code'");
    sb.write(" and cust_name = '$name'");
    sa.write("select period, year, sum(sales_unit) salesu, sum(sales_value) salesv, sum(bonus_unit) bonusu from sales");
    sa.write(" where cust_code = '$code'");
    sa.write(" and cust_name = '$name'");

    if (isNotEmpty(q.item)) {
      sb.write(" and item_name in (${q.item})");
      sa.write(" and item_name in (${q.item})");
    }

    if (isNotEmpty(q.productGroup)) {
      sb.write(" and product_group in (${q.productGroup})");
      sa.write(" and product_group in (${q.productGroup})");
    }

    if (isNotEmpty(q.territory)) {
      sb.write(" and territory in (${q.territory})");
      sa.write(" and territory in (${q.territory})");
    }

    if (isNotEmpty(q.period)) {
      sb.write(" and period in (${q.period})");
      sa.write(" and period in (${q.period})");
    }

    if (isNotEmpty(q.year)) {
      sb.write(" and year in (${q.year})");
      sa.write(" and year in (${q.year})");
    }

    sb.write(" group by period, year, item_name");
    sb.write(" order by $sort, period, year");
    sa.write(" group by period, year");
    sa.write(" order by $sort, period, year");

    String s = sb.toString();
    var lx = await db.rawQuery(s);
    lx.forEach((k) {
      int month = k['period'];
      int y = k['year'];

      String key = '$y-$month';
      CustomerItem x = CustomerItem.fromData(k, q, code, name);

      if (m.containsKey(key)) {
        m[key].add(x);
      }

      else {
        List<CustomerItem> l = [x];
        m[key] = l;

        if ('item_name' == sort) {
          ls.add(key);
        }
      }
    });

    if ('item_name' != sort) {
      s = sa.toString();
      lx = await db.rawQuery(s);
      lx.forEach((k) {
        int month = k['period'];
        int y = k['year'];

        String key = '$y-$month';
        ls.add(key);
      });
    }

    return m;
  }

  Future<SalesSummary> getHalfYearlySummary(String h, String product, Target t) async {
    SalesSummary o = SalesSummary(productGroup: product, target: t.value);
    int year = DateTime.now().year;
    int pyear = year - 1;
    String years = '$year,$pyear';
    String months = getHalfYearMonths(h);

    String s = '''select year, sum(sales_value) salesv from sales
                  where period in ($months) 
                  and product_group like '$product%' 
                  and year in ($years) 
                  group by year
    ''';
    var lx = await db.rawQuery(s);
    lx.forEach((x) {
      int y = x['year'];
      if (y == year) {
        o.actual = x['salesv'];
      }

      else if (y == pyear) {
        o.actual1 = x['salesv'];
      }
    });

    return o;
  }

  Future<SalesSummary> getQuarterlySummary(String quarter, String product, Target t) async {
    SalesSummary o = SalesSummary(productGroup: product, target: t.value);
    int year = DateTime.now().year;
    int pyear = year - 1;
    String years = '$year,$pyear';
    String months = getQuarterMonths(quarter);

    String s = '''select year, sum(sales_value) salesv from sales
                  where period in ($months)
                  and product_group like '$product%'
                  and year in ($years)
                  group by year
    ''';
    var lx = await db.rawQuery(s);
    lx.forEach((x) {
      int y = x['year'];
      if (y == year) {
        o.actual = x['salesv'];
      }

      else if (y == pyear) {
        o.actual1 = x['pyear'];
      }
    });

    return o;
  }

  Future<SalesSummary> getMontlySummary(String months, String product, Target t) async {
    print('aaaa ${t.value}');
    SalesSummary o = SalesSummary(productGroup: product, target: t.value);
    int year = DateTime.now().year;
    int pyear = year - 1;
    String years = '$year,$pyear';

    String s = '''select year, sum(sales_value) as salesv from sales
                  where period in ($months)
                  and product_group like '$product%'
                  and year in ($years)
                  group by year
    ''';
    print(s);
    var lx = await db.rawQuery(s);
    lx.forEach((x) {
      int y = x['year'];
      if (y == year) {
        o.actual = x['salesv'];
      }

      else if (y == pyear) {
        o.actual1 = x['pyear'];
      }
    });

    return o;
  }
}