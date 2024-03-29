import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mysales_flutter/models/customer_query.dart';
import 'package:mysales_flutter/models/customer.dart';
import 'package:mysales_flutter/ui/customer_item_detail.dart';
import 'package:mysales_flutter/helpers/DBProvider.dart';

class Customers extends StatefulWidget {
  Customers({Key key, this.title, this.param}) : super(key: key);

  final String title;
  final CustomerQuery param;

  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {

  DBProvider dbx;
  Future<List<Customer>> lf;
  final List<String> sortOptions = ['cust_code', 'cust_name', 'salesu desc', 'salesv desc', 'bonusu desc'];

  @override
  void initState() {
    super.initState();
    dbx = DBProvider();
    lf = load();
  }

  Future<List<Customer>> load([String sort = '']) async {
    List<Customer> lx;

    try {
      lx = await dbx.filterCustomer(widget.param, sort);
    }

    catch (error) {

    }

    finally {
      await dbx.closeDB();
    }
    
    return lx;
  }

  void sortBy(int i) {
    setState(() {
     lf = load(sortOptions[i]);
    });
  }

  Widget buildList() {
    return FutureBuilder(
      future: lf,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data.length < 1) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(width: 1.0),
              ),
              child: Text(
                'No records found!',
                style: TextStyle(
                  fontSize: 14.0
                ),
              ),
            ),
          );
        }

        return ListView.separated(
          separatorBuilder: (context, i) {
            return Container(
              margin: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Divider(
                color: Theme.of(context).colorScheme.primary, 
                height: 2.0,
              ),
            );
          },
          itemCount: snapshot.data.length,
          itemBuilder: (context, i) {
            Customer o = snapshot.data[i];
            return ListTile(
              title: Text(o.code),
              subtitle: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  o.name,
                ),
              ),
              onTap: () {
                var prm = widget.param;
                prm.code = o.code;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerItemDetail(
                      title: 'Customer Item Details',
                      param: prm,
                      code: o.code,
                      name: o.name,
                    )
                  ),
                );
              },
            );
          },
        );
      },
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
                  child: Text('By Customer Code'),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Text('By Customer Name'),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text('By Sales Unit'),
                ),
                PopupMenuItem(
                  value: 3,
                  child: Text('By Sales Value'),
                ),
                PopupMenuItem(
                  value: 4,
                  child: Text('By Bonus Unit'),
                ),
              ];
            },
          ),
        ],
      ),
      body: buildList(),
    );
  }
}