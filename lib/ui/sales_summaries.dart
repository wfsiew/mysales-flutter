import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mysales_flutter/models/sales_summary.dart';
import 'package:mysales_flutter/models/target.dart';
import 'package:mysales_flutter/helpers/DBProvider.dart';
import 'package:mysales_flutter/helpers/utils.dart';

class SalesSummaries extends StatefulWidget {
  SalesSummaries({Key key, this.title, this.month, this.quarter, this.halfyear}) : super(key: key);

  final String title;
  final String month;
  final String quarter;
  final String halfyear;

  @override
  _SalesSummariesState createState() => _SalesSummariesState();
}

class _SalesSummariesState extends State<SalesSummaries> {

  DBProvider dbx;
  Future<List<SalesSummary>> lf;

  @override
  void initState() {
    super.initState();
    dbx = DBProvider();
    lf = load();
  }

  Future<List<SalesSummary>> load() async {
    List<SalesSummary> ls = [];
    Map<String, Target> mt;
    await dbx.openDB();

    var productGroups = await dbx.getProductGroups();
    if (isNotEmpty(widget.month)) {
      mt = await dbx.get
    }

    await dbx.closeDB();
  }

  Widget buildList() {

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