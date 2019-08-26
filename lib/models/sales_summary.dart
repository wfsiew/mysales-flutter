class SalesSummary {
  String productGroup;
  double actual;
  double target;
  double actual1;

  SalesSummary({
    this.productGroup,
    this.actual,
    this.target,
    this.actual1
  });

  int get actualVsTarget {
    var v = (actual * 100 / target) as int;
    int k = v.round();
    return k;
  }

  double get actualVsTargetDiff {
    return actual - target;
  }

  int get actualVsPrevYear {
    var v = actual * 100 / actual1;
    int k = v.round();
    return k;
  }

  double get actualVsPrevYearDiff {
    return actual - actual1;
  }
}