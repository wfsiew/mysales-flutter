import 'package:flutter/material.dart';
import 'package:mysales_flutter/widgets/input-field.dart';

class Items extends StatefulWidget {
  Items({Key key, this.title, this.label, this.items, this.selectedItems}) : super(key: key);

  final String title;
  final String label;
  final List<String> items;
  final List<String> selectedItems;

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {

  List<String> ls = <String>[];
  List<String> lk = <String>[];

  @override
  void initState() {
    super.initState();
    ls = widget.items;
    lk = List.from(widget.selectedItems);
  }

  List<Widget> buildItems() {
    List<Widget> lx = <Widget>[];
    ls.forEach((x) {
      lx.add(
        Container(
          padding: const EdgeInsets.all(2.0),
          child: ChoiceChip(
            label: Text(x),
            selected: lk.contains(x),
            onSelected: (bool selected) {
              setState(() {
               lk.contains(x) 
                 ? lk.remove(x)
                 : lk.add(x);
              });
            },
          ),
        )
      );
    });

    return lx;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check, color: Colors.white),
            onPressed: () {
              Navigator.pop(context, lk);
            }
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: 80.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputField(
                label: widget.label,
                onChanged: (String s) {
                  if (s.isEmpty) {
                    setState(() {
                     ls = widget.items; 
                    });
                  }

                  var lx = widget.items.where((x) => x.toLowerCase().contains(s.toLowerCase())).toList();
                  setState(() {
                   ls = lx; 
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(children: buildItems()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}