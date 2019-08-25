import 'package:mysales_flutter/helpers/utils.dart';

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

  factory CustomerAddress.fromData(Map<String, dynamic> m) {
    return CustomerAddress(
      addr1: replaceZero(m['cust_addr1']),
      addr2: replaceZero(m['cust_addr2']),
      addr3: replaceZero(m['cust_addr3']),
      postalCode: replaceZero(m['postal_code']),
      area: replaceZero(m['area']),
      territory: replaceZero(m['territory']),
      telephone: replaceZero(m['telephone']),
      contact: replaceZero(m['contact_person'])
    );
  }

  void copy(CustomerAddress a) {
    addr1 = a.addr1;
    addr2 = a.addr2;
    addr3 = a.addr3;
    postalCode = a.postalCode;
    area = a.area;
    a.territory = territory;
    telephone = a.telephone;
    contact = a.contact;
  }
}