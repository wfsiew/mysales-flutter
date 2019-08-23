class Customer {
  String name;
  String code;

  Customer({
    this.name,
    this.code
  });

  factory Customer.fromData(Map<String, dynamic> m) {
    return Customer(
      name: m['cust_name'],
      code: m['cust_code']
    );
  }

  @override
  String toString() {
    if ('All' == code) {
      return code;
    }

    return '$code - $name';
  }
}