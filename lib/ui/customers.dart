import 'package:flutter/material.dart';
import 'package:mysales_flutter/models/customer_query.dart';
import 'package:mysales_flutter/models/customer.dart';
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

  @override
  void initState() {
    super.initState();
    dbx = DBProvider();
  }

  Widget buildList() {
    return FutureBuilder(
      future: dbx.filterCustomer(widget.param, ''),
      builder: (context, snapshot) {
        if (snapshot.hasData == null || snapshot.data == null) {
          return Container();
        }

        if (snapshot.data.length < 1) {
          return Center(
            child: Text('No records found!'),
          );
        }

        return ListView.separated(
          separatorBuilder: (context, i) {
            return Divider(color: Theme.of(context).colorScheme.primary,);
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
      ),
      body: buildList(),
    );
  }
}