import 'package:mysales_flutter/models/customer_item.dart';

class Result {

  List<CustomerItem> list;
  int totalSalesUnit;
  int totalBonusUnit;
  double totalSalesValue;

  Result({
    this.list,
    this.totalSalesUnit,
    this.totalBonusUnit,
    this.totalSalesValue
  });
}