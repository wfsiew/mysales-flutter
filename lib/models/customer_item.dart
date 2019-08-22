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
    this.isHeader,
    this.isFooter,

    this.sumunit,
    this.sumbonus,
    this.sumvalue
  });
}