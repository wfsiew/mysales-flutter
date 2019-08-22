import 'package:flutter/material.dart';
import 'package:mysales_flutter/widgets/input-field.dart';
import 'package:mysales_flutter/helpers/DBProvider.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<String> ls = <String>[];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    var dbx = DBProvider();
    await dbx.openDB();
    var lx = await dbx.getCustomers();
    print(lx);
    setState(() {
     ls = lx; 
    });
  }

  Widget buildContent() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: ListView(
          children: <Widget>[
            InputField(
              label: 'Customer',
              onChanged: (String s) {

              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: buildContent(),
    );
  }
}