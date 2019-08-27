import 'package:flutter/material.dart';
import 'package:mysales_flutter/helpers/TargetDBProvider.dart';
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
  TargetDBProvider tdbx;
  Future<List<SalesSummary>> lf;

  @override
  void initState() {
    super.initState();
    dbx = DBProvider();
    tdbx = TargetDBProvider();
    lf = load();
  }

  Future<List<SalesSummary>> load() async {
    List<SalesSummary> ls = [];
    Map<String, Target> mt;
    await tdbx.openDB();

    var productGroups = await tdbx.getProductGroups();
    if (isNotEmpty(widget.month)) {
      mt = await tdbx.getMonthlyTarget(widget.month);
    }

    else if (isNotEmpty(widget.quarter)) {
      mt = await tdbx.getQuarterlyTarget(widget.quarter);
    }

    else if (isNotEmpty(widget.halfyear)) {
      mt = await tdbx.getHalfYearlyTarget(widget.halfyear);
    }

    await dbx.openDB();

    for (String product in productGroups) {
      SalesSummary monthlySummary;

      if (isNotEmpty(widget.month)) {
        print('xxx');
        monthlySummary = await dbx.getMontlySummary(widget.month, product, mt[product]);
        print('yyy');
      }

      else if (isNotEmpty(widget.quarter)) {
        monthlySummary = await dbx.getQuarterlySummary(widget.quarter, product, mt[product]);
      }

      else if (isEmpty(widget.halfyear)) {
        monthlySummary = await dbx.getHalfYearlySummary(widget.halfyear, product, mt[product]);
      }

      if (monthlySummary != null) {
        ls.add(monthlySummary);
      }
    }

    await dbx.closeDB();
    await tdbx.closeDB();

    return ls;
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
            child: Text('No records found!'),
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
            SalesSummary o = snapshot.data[i];
            return Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(o.productGroup),
                  Text('Actual: ${formatDouble(o.actual)}'),
                  Text('Target: ${formatDouble(o.target)} (${o.actualVsTarget} %, ${formatDouble(o.actualVsTargetDiff)})'),
                  Text('Last Year: ${formatDouble(o.actual1)} (${o.actualVsPrevYear} %, ${formatDouble(o.actualVsPrevYearDiff)})'),
                ],
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