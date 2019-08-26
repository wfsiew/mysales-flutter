import 'package:flutter/material.dart';
import 'package:mysales_flutter/helpers/DBProvider.dart';
import 'package:mysales_flutter/helpers/utils.dart';
import 'package:mysales_flutter/ui/items.dart';
import 'package:mysales_flutter/ui/sales_summaries.dart';

class SalesSummary extends StatefulWidget {
  SalesSummary({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SalesSummaryState createState() => _SalesSummaryState();
}

class _SalesSummaryState extends State<SalesSummary> {

  DBProvider dbx;
  List<String> lperiod = <String>[];
  List<String> lquarter = <String>[];
  List<String> lhalfyear = <String>[];
  List<String> selectedPeriods = <String>[];
  List<String> selectedQuarters = <String>[];
  List<String> selectedHalfYears = <String>[];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() {
    List<String> la = List.generate(12, (int i) {
      return '${i + 1}';
    });

    setState(() {
     lperiod = la;
     lquarter = ['1', '2', '3', '4'];
     lhalfyear = ['1', '2'];
    });
  }

  Widget buildContent() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                elevation: 5,
                child: Text(
                  'Monthly'
                ),
                onPressed: () async {
                  var lx = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Items(
                        title: 'Select Periods', 
                        label: 'Search Period', 
                        items: lperiod, 
                        selectedItems: selectedPeriods
                      ),
                    ),
                  );
                  if (lx != null) {
                    selectedPeriods = lx;
                  }
                },
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                elevation: 5,
                color: Theme.of(context).primaryColor,
                child: Text(
                  'View',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SalesSummaries(
                        title: 'Sales Summary',
                        month: getSelected(selectedPeriods),
                        quarter: '',
                        halfyear: '',
                      )
                    ),
                  );
                },
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                elevation: 5,
                child: Text(
                  'Quarterly'
                ),
                onPressed: () async {
                  var lx = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Items(
                        title: 'Select', 
                        label: 'Search', 
                        items: lquarter, 
                        selectedItems: selectedQuarters
                      ),
                    ),
                  );
                  if (lx != null) {
                    setState(() {
                     selectedQuarters = lx; 
                    });
                  }
                },
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                elevation: 5,
                color: Theme.of(context).primaryColor,
                child: Text(
                  'View',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SalesSummaries(
                        title: 'Sales Summary',
                        month: '',
                        quarter: getSelected(selectedQuarters),
                        halfyear: '',
                      )
                    ),
                  );
                },
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                elevation: 5,
                child: Text(
                  'Quarterly'
                ),
                onPressed: () async {
                  var lx = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Items(
                        title: 'Select', 
                        label: 'Search', 
                        items: lhalfyear, 
                        selectedItems: selectedHalfYears
                      ),
                    ),
                  );
                  if (lx != null) {
                    setState(() {
                     selectedHalfYears = lx; 
                    });
                  }
                },
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                elevation: 5,
                color: Theme.of(context).primaryColor,
                child: Text(
                  'View',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SalesSummaries(
                        title: 'Sales Summary',
                        month: '',
                        quarter: '',
                        halfyear: getSelected(selectedHalfYears),
                      )
                    ),
                  );
                },
              ),
            ),
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