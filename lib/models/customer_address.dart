class CustomerAddress {
  String addr1;
  String addr2;
  String addr3;
  String postalCode;
  String area;
  String territory;
  String telephone;
  String contact;

  CustomerAddress({
    this.addr1,
    this.addr2,
    this.addr3,
    this.postalCode,
    this.area,
    this.territory,
    this.telephone,
    this.contact
  });

  void set _addr1(String a) {
    addr1 = '0' == a ? '' : a;
  }

  void set _addr2(String a) {
    addr2 = '0' == a ? '' : a;
  }

  void set _addr3(String a) {
    addr3 = '0' == a ? '' : a;
  }

  void set _postalCode(String a) {
    postalCode = '0' == a ? '' : a;
  }

  void set _area(String a) {
    area = '0' == a ? '' : a;
  }

  void set _territory(String a) {
    territory = '0' == a ? '' : a;
  }

  void set _telephone(String a) {
    telephone = '0' == a ? '' : a;
  }

  void set _contact(String a) {
    contact = '0' == a ? '' : a;
  }
}