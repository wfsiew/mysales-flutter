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
    if ((target ?? 0) == 0) {
      return 0;
    }

    var v = (actual ?? 0) * 100 / target;
    int k = v.round();
    return k;
  }

  double get actualVsTargetDiff {
    return (actual ?? 0) - (target ?? 0);
  }

  int get actualVsPrevYear {
    if ((actual1 ?? 0) == 0) {
      return 0;
    }

    var v = (actual ?? 0) * 100 / actual1;
    int k = v.round();
    return k;
  }

  double get actualVsPrevYearDiff {
    return (actual ?? 0) - (actual1 ?? 0);
  }
}