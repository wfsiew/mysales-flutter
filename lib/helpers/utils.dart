import 'package:intl/intl.dart';

bool isEmpty(String s) {
  return s?.isEmpty ?? true;
}

bool isNotEmpty(String s) {
  return !isEmpty(s);
}

String formatDouble(double i) {
  final fmt = NumberFormat('#,##0.00');
  return fmt.format(i);
}

String escapeStr(String s) {
  String r = s;
  if (s.isEmpty) {
    return s;
  }

  r = r.replaceAll("'", "''");
  return r;
}

String getSelected(List<String> ls, [bool useQuote = false]) {
  List<String> lr = [];
  String r = '';

  if (useQuote) {
    lr = ls.map<String>((x) => "'${escapeStr(x)}'").toList();
  }
  
  else {
    lr = ls.map<String>((x) => '${escapeStr(x)}').toList();
  }

  r = lr.join(',');
  return r;
}

String replaceZero(s) {
  return s == '0' ? '' : s;
}