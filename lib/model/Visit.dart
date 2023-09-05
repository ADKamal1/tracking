import 'dart:io';

import 'package:hook_atos/shared/helper/mangers/constants.dart';

class Visit {
  String? visitId;
  String? userId;
  String? name;
  String? phone;
  String? line;
  String? classy;
  String? dist;
  String? specialty;
  String? searchName;
  String? address;
  String?dateOfNextVisit;
  String? time;
  String? dateOfVisit;
  bool?planed;
  String?note;
  bool?status;
  String?image;
  String?governorate;
  bool?isMocking;
  String?type;




  Visit({
    visitId,
    required this.userId,
    required this.name,
    required this.searchName,
    required this.phone,
    required this.line,
    required this.classy,
    required this.dist,
    required this.specialty,
    required this.dateOfNextVisit,
    required this.address,
    required this.dateOfVisit,
    required this.time,
    required this.planed,
    required this.status,
    required this.note,
    required this.image,
    required this.governorate,
    required this.isMocking,
    required this.type

  });

  Visit.fromJson(Map<String, dynamic> json) {
    visitId = json['visitId'];
    userId = json['userId'];
    name = json['name'];
    phone = json['phone'];
    line=json['line'];
    specialty=json['specialty'];
    classy=json['classy'];
    dist=json['dist'];
    dateOfNextVisit = json['dateOfNextVisit'];
    dateOfVisit = json['dateOfVisit'];
    time = json['time'];
    searchName = json['searchName'];
    address = json['address'];
    planed=json['planed'];
    note=json['note'];
    status=json['status'];
    image=json['image'];
    governorate=json['governorate'];
    isMocking=json['isMocking'];
    type=json['type'];
  }

  Map<String, dynamic> toMap() {
    return {
      "visitId": visitId,
      "userId": userId,
      "name": name,
      "phone": phone,
      "dist":dist,
      "classy":classy,
      "line":line,
      "specialty":specialty,
      "time": time,
      "dateOfNextVisit": dateOfNextVisit,
      "dateOfVisit":dateOfVisit,
      "searchName": searchName,
      "address": address,
      "planed":planed,
      "note":note,
      "status":status,
      "image":image,
      "governorate":governorate,
      "isMocking":isMocking,
      "type":type,

    };
  }
}
