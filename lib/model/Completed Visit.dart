import 'dart:io';

import 'package:hook_atos/shared/helper/mangers/constants.dart';

class CompletedVisit {
  String? id;
  String? userId;
  String? name;
  String? phone;
  String? line;
  String? classy;
  String? dist;
  String? specialty;
  String? searchName;
  String? address;
  String?previousDate;
  String? time;
  String? completedDate;
  bool?planed;
  String?note;




  CompletedVisit({
    id,
    required this.userId,
    required this.name,
    required this.searchName,
    required this.phone,
    required this.line,
    required this.classy,
    required this.dist,
    required this.specialty,

    required this.previousDate,
    required this.address,
    required this.completedDate,

    required this.time,

    required this.planed,
    required this.note,
  });

  CompletedVisit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    name = json['name'];
    phone = json['phone'];
    line=json['line'];
    specialty=json['specialty'];
    classy=json['classy'];
    dist=json['dist'];
    previousDate = json['previousDate'];
    completedDate = json['completedDate'];
    time = json['time'];
    searchName = json['searchName'];
    address = json['address'];
    planed=json['planed'];
    note=json['note'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "name": name,
      "phone": phone,
      "dist":dist,
      "classy":classy,
      "line":line,
      "specialty":specialty,
      "time": time,
      "previousDate": previousDate,
      "completedDate":completedDate,
      "searchName": searchName,
      "address": address,
      "planed":planed,
      "note":note,
    };
  }
}
