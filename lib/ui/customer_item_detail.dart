import 'package:flutter/material.dart';
import 'package:mysales_flutter/models/customer_query.dart';
import 'package:mysales_flutter/models/customer_item.dart';
import 'package:mysales_flutter/models/customer_address.dart';
import 'package:mysales_flutter/models/result.dart';
import 'package:mysales_flutter/helpers/DBProvider.dart';
import 'package:mysales_flutter/helpers/utils.dart';

class CustomerItemDetail extends StatefulWidget {
  CustomerItemDetail({Key key, this.title, this.param, this.code, this.name}) : super(key: key);

  final String title;
  final CustomerQuery param;
  final String code;
  final String name;

  @override
  _CustomerItemDetailState createState() => _CustomerItemDetailState();
}

class _CustomerItemDetailState extends State<CustomerItemDetail> {

  DBProvider dbx;
  String main = '';
  List<CustomerItem> lf = <CustomerItem>[];
  final List<String> sortOptions = ['item_name', 'salesu desc', 'salesv desc', 'bonusu desc'];
  bool isLoading = false;
  
  @override
  void initState() {
    super.initState();
    dbx = DBProvider();
    load();
  }

  void load([String sort = '']) async {
    var addr = CustomerAddress();
    List<String> la = [];

    setState(() {
     isLoading = true; 
    });

    try {
      var m = await dbx.getItemsByCustomer(widget.code, widget.name, widget.param, sort, addr, la);
      Result r = process(m, la);
      List<CustomerItem> lk = r.list;
      StringBuffer sb = StringBuffer();

      if (la.isNotEmpty) {
        List<CustomerItem> lx = m[la.first];
        if (lx.isNotEmpty) {
          CustomerItem x = lx.first;
          sb.writeln('${x.code} - ${x.name}');

          if (isNotEmpty(addr.addr1)) {
            sb.write(addr.addr1);
          }

          if (isNotEmpty(addr.addr2)) {
            if (sb.toString().trim().endsWith(',')) {
              sb.write(' ${addr.addr2}');
            }

            else {
              sb.write(', ${addr.addr2}');
            }
          }

          if (isNotEmpty(addr.addr3)) {
            if (sb.toString().trim().endsWith(',')) {
              sb.write(' ${addr.addr3}');
            }

            else {
              sb.write(', ${addr.addr3}');
            }
          }

          if (isNotEmpty(addr.telephone)) {
            sb.writeln();
            sb.write(addr.telephone);
          }

          if (isNotEmpty(addr.contact)) {
            sb.writeln();
            sb.write(addr.contact);
          }

          sb.writeln('\nTotal Sales Unit: ${r.totalSalesUnit}');
          sb.writeln('Total Bonus Unit: ${r.totalBonusUnit}');
          sb.writeln('Total Sales Value: ${formatDouble(r.totalSalesValue)}');

          setState(() {
           main = sb.toString();
           lf = lk;
           isLoading = false;
          });
        }
      }
    }

    catch (error) {
      setState(() {
       isLoading = false; 
      });
    }

    finally {
      await dbx.closeDB();
    }
  }

  void sortBy(int i) {
    setState(() {
     load(sortOptions[i]);
    });
  }

  Result process(Map<String, List<CustomerItem>> m, List<String> la) {
    Result r = Result();
    List<CustomerItem> lk = [];
    r.list = lk;

    if (la.isEmpty) {
      return r;
    }

    int salesunittotal = 0;
    double salesvaluetotal = 0;
    int bonustotal = 0;

    la.forEach((key) {
      List<CustomerItem> l = m[key];
      CustomerItem h = CustomerItem();
      h.isHeader = true;
      h.header = key;
      lk.add(h);

      int salesunit = 0;
      double salesvalue = 0;
      int bonus = 0;

      l.forEach((o) {
        CustomerItem i = CustomerItem();
        i.item = o.item;
        i.unit = o.unit;
        i.bonus = o.bonus;
        i.value = o.value;
        lk.add(i);

        salesunit += o.unit;
        salesvalue += o.value;
        bonus += o.bonus;

        salesunittotal += o.unit;
        salesvaluetotal += o.value;
        bonustotal += o.bonus;
      });

      CustomerItem f = CustomerItem();
      f.isFooter = true;
      f.sumunit = salesunit;
      f.sumbonus = bonus;
      f.sumvalue = salesvalue;
      lk.add(f);
    });

    r.list = lk;
    r.totalSalesUnit = salesunittotal;
    r.totalBonusUnit = bonustotal;
    r.totalSalesValue = salesvaluetotal;
    return r;
  }

  Widget buildContent() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            main,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 12.0, right: 12.0),
          child: Divider(
            color: Theme.of(context).colorScheme.primary, 
            height: 2.0,
          ),
        ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, i) {
              return Container(
                margin: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Divider(
                  color: Theme.of(context).colorScheme.primary, 
                  height: 2.0,
                ),
              );
            },
            itemCount: lf?.length ?? 0,
            itemBuilder: (context, i) {
              CustomerItem o = lf[i];
              if (o.isHeader) {
                return ListTile(
                  title: Center(
                    child: Text(
                      o.header,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }

              else if (o.isFooter) {
                return ListTile(
                  title: Text(
                    '${o.sumunit} (Sales Unit) ${o.sumbonus} (Bonus Unit) ${formatDouble(o.sumvalue)} (Sales Value)',
                    style: TextStyle(
                      fontStyle: FontStyle.italic
                    ),
                  ),
                );
              }

              return ListTile(
                title: Text(o.item),
                subtitle: Text(
                  '${o.unit} (Sales Unit) ${o.bonus} (Bonus Unit) ${formatDouble(o.value)} (Sales Value)',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (int i) {
              sortBy(i);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 0,
                  child: Text('By Item'),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Text('By Sales Unit'),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text('By Sales Value'),
                ),
                PopupMenuItem(
                  value: 3,
                  child: Text('By Bonus Unit'),
                ),
              ];
            },
          ),
        ],
      ),
      body: buildContent(),
    );
  }
}