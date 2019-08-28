import 'package:flutter/material.dart';
import 'package:mysales_flutter/helpers/TargetDBProvider.dart';
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
  List<SalesSummary> lf = <SalesSummary>[];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    dbx = DBProvider();
    tdbx = TargetDBProvider();
    load();
  }

  void load() async {
    List<SalesSummary> ls = [];
    Map<String, Target> mt;

    setState(() {
     isLoading = true; 
    });

    try {
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
          monthlySummary = await dbx.getMontlySummary(widget.month, product, mt[product]);
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

      setState(() {
       lf = ls; 
       isLoading = false;
      });
    }

    catch (error) {
      setState(() {
       isLoading = false; 
      });
    }

    finally {
      await dbx.closeDB();
      await tdbx.closeDB();
    }
  }

  Widget buildList() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (lf.length < 1) {
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
      itemCount: lf.length,
      itemBuilder: (context, i) {
        SalesSummary o = lf[i];
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