import 'package:flutter/material.dart';
import 'package:mysales_flutter/models/customer_query.dart';
import 'package:mysales_flutter/widgets/input-field.dart';
import 'package:mysales_flutter/helpers/DBProvider.dart';
import 'package:mysales_flutter/helpers/utils.dart';
import 'package:mysales_flutter/ui/items.dart';
import 'package:mysales_flutter/ui/customers.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<String> ls = <String>[];
  List<String> li = <String>[];
  List<String> lp = <String>[];
  List<String> lt = <String>[];
  List<String> lperiod = <String>[];
  List<String> lyear = <String>[];
  String customer;
  List<String> selectedItems = <String>[];
  List<String> selectedProductGroups = <String>[];
  List<String> selectedTerritories = <String>[];
  List<String> selectedPeriods = <String>[];
  List<String> selectedYears = <String>[];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    var dbx = DBProvider();
    await dbx.openDB();
    var lss = await dbx.getCustomers();
    var lii = await dbx.getItems();
    var lpp = await dbx.getProductGroups();
    var ltt = await dbx.getTerritories();
    await dbx.closeDB();

    int year = DateTime.now().year;
    int gap = year - 2012 + 1;

    List<String> la = List.generate(12, (int i) {
      return '${i + 1}';
    });

    List<String> lb = List.generate(gap, (int i) {
      return '${year - i}';
    });

    setState(() {
     ls = lss; 
     li = lii;
     lp = lpp;
     lt = ltt;
     lperiod = la;
     lyear = lb;
    });
  }

  Widget buildContent() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: ListView(
          children: <Widget>[
            TypeAheadInputField(
              label: 'Customer',
              ls: ls,
              onChanged: (String s) {
                setState(() {
                 customer = s; 
                });
              },
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                elevation: 5,
                child: Text(
                  'Item',
                ),
                onPressed: () async {
                  var lx = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Items(
                        title: 'Select Items', 
                        label: 'Search item', 
                        items: li, 
                        selectedItems: selectedItems
                      ),
                    ),
                  );
                  if (lx != null) {
                    setState(() {
                     selectedItems = lx;
                    });
                  }
                },
              ),
            ),
            Container(
              child: selectedItems.isEmpty ? null : Text(selectedItems.join(', ')),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                elevation: 5,
                child: Text(
                  'Product Group',
                ),
                onPressed: () async {
                  var lx = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Items(
                        title: 'Select Product Groups', 
                        label: 'Search product group', 
                        items: lp, 
                        selectedItems: selectedProductGroups
                      ),
                    ),
                  );
                  if (lx != null) {
                    setState(() {
                     selectedProductGroups = lx;
                    });
                  }
                },
              ),
            ),
            Container(
              child: selectedProductGroups.isEmpty ? null : Text(selectedProductGroups.join(', ')),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                elevation: 5,
                child: Text(
                  'Territories',
                ),
                onPressed: () async {
                  var lx = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Items(
                        title: 'Select Territories', 
                        label: 'Search territory', 
                        items: lt, 
                        selectedItems: selectedTerritories
                      ),
                    ),
                  );
                  if (lx != null) {
                    setState(() {
                     selectedTerritories = lx;
                    });
                  }
                },
              ),
            ),
            Container(
              child: selectedTerritories.isEmpty ? null : Text(selectedTerritories.join(', ')),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                elevation: 5,
                child: Text(
                  'Periods',
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
                    setState(() {
                     selectedPeriods = lx;
                    });
                  }
                },
              ),
            ),
            Container(
              child: selectedPeriods.isEmpty ? null : Text(selectedPeriods.join(', ')),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                elevation: 5,
                child: Text(
                  'Year',
                ),
                onPressed: () async {
                  var lx = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Items(
                        title: 'Select Year', 
                        label: 'Search year', 
                        items: lyear, 
                        selectedItems: selectedYears
                      ),
                    ),
                  );
                  if (lx != null) {
                    setState(() {
                     selectedYears = lx;
                    });
                  }
                },
              ),
            ),
            Container(
              child: selectedYears.isEmpty ? null : Text(selectedYears.join(', ')),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                elevation: 5,
                color: Theme.of(context).primaryColor,
                child: Text(
                  'Search',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Customers(
                        title: 'Customers', 
                        param: CustomerQuery(
                          name: customer,
                          item: getSelected(selectedItems, true),
                          productGroup: getSelected(selectedProductGroups, true),
                          territory: getSelected(selectedTerritories, true),
                          period: getSelected(selectedPeriods),
                          year: getSelected(selectedYears)
                        ),
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