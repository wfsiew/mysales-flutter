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

  set _addr1(String a) {
    addr1 = a;
    if ('0' == a) {
      addr1 = '';
    }
  }

  set _addr2(String a) {
    addr2 = a;
    if ('0' == a) {
      addr2 = '';
    }
  }
}