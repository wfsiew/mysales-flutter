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