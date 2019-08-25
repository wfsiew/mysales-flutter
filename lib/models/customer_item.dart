import 'package:mysales_flutter/models/customer_query.dart';

class CustomerItem {
  String code;
  String name;
  String item;
  int unit;
  double value;
  int bonus;

  String header;
  bool isHeader;
  bool isFooter;

  int sumunit;
  int sumbonus;
  double sumvalue;

  CustomerItem({
    this.code,
    this.name,
    this.item,
    this.unit,
    this.value,
    this.bonus,

    this.header,
    this.isHeader = false,
    this.isFooter = false,

    this.sumunit,
    this.sumbonus,
    this.sumvalue
  });

  factory CustomerItem.fromData(Map<String, dynamic> m, CustomerQuery q, String code, String name) {
    return CustomerItem(
      code: code,
      name: name,
      item: m['item_name'],
      unit: m['salesu'],
      value: m['salesv'],
      bonus: m['bonusu']
    );
  }
}