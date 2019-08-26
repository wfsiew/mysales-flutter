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

String getHalfYearMonths(String h) {
  List<String> arr = [];
  StringBuffer sb = StringBuffer();

  if (h.contains(',')) {
    arr = h.split(',');
  }

  else {
    arr = [h];
  }

  for (String y in arr) {
    if ('1' == y) {
      sb.write('1,2,3,4,5,6');
    }

    else if ('2' == y) {
      sb.write('7,8,9,10,11,12');
    }
  }

  return sb.toString();
}

String getQuarterMonths(String quarter) {
  List<String> arr = [];
  StringBuffer sb = StringBuffer();

  if (quarter.contains(',')) {
    arr = quarter.split(',');
  }

  else {
    arr = [quarter];
  }

  for (String period in arr) {
    if ('1' == period) {
      sb.write('1,2,3');
    }

    else if ('2' == period) {
      sb.write('4,5,6');
    }

    else if ('3' == period) {
      sb.write('7,8,9');
    }

    else if ('4' == period) {
      sb.write('10,11,12');
    }
  }

  return sb.toString();
}