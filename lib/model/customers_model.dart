import 'dart:io';

import 'package:hook_atos/shared/helper/mangers/constants.dart';

class CustomerModel {
  String? id;
  String? userId;
  String? name;
  String? phone;
  String? line;
  String? classy;
  String? dist;
  String? specialty;
  String? searchName;
  double? lat;
  double? lon;
  String? address;
  String? image;
  String? date;
  String? time;
  bool? isMocking;
  bool?states;
  String?note;



  CustomerModel({
    this.id = ConstantsManger.DEFULT,
    required this.userId,
    required this.name,
    required this.searchName,
    required this.phone,
    required this.line,
    required this.classy,
    required this.dist,
    required this.specialty,

    required this.lat,
    required this.address,
    required this.lon,
    required this.image,
    required this.date,
    required this.time,
    required this.isMocking,
    required this.states,
    required this.note,
  });

  CustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    name = json['name'];
    phone = json['phone'];
    line=json['line'];
    specialty=json['specialty'];
    classy=json['classy'];
    dist=json['dist'];
    lat = json['lat'];
    lon = json['lon'];
    image = json['image'];
    date = json['date'];
    time = json['time'];
    isMocking = json['isMocking'];
    searchName = json['searchName'];
    address = json['address'];
    states=json['states'];
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
      "lat": lat,
      "lon": lon,
      "image": image,
      "time": time,
      "date": date,
      "searchName": searchName,
      "isMocking": isMocking,
      "address": address,
      "states":states,
      "note":note,
    };
  }
}
