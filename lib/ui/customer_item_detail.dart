import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mysales_flutter/models/customer_query.dart';
import 'package:mysales_flutter/models/customer_item.dart';
import 'package:mysales_flutter/helpers/DBProvider.dart';

class CustomerItemDetail extends StatefulWidget {
  CustomerItemDetail({Key key, this.title, this.param}) : super(key: key);

  final String title;
  final CustomerQuery param;

  @override
  _CustomerItemDetailState createState() => _CustomerItemDetailState();
}

class _CustomerItemDetailState extends State<CustomerItemDetail> {

  DBProvider dbx;
  
}