import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:background_locator_2/location_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../model/location_model.dart';
import '../../../shared/helper/mangers/constants.dart';
import '../../../shared/helper/methods.dart';
import 'file_manager.dart';

class LocationServiceRepository {
  static LocationServiceRepository _instance = LocationServiceRepository._();

  LocationServiceRepository._();

  factory LocationServiceRepository() {
    return _instance;
  }

  static const String isolateName = 'LocatorIsolate';

  int _count = -1;

  Future<void> init(Map<dynamic, dynamic> params) async {
    print("***********Init callback handler");
    if (params.containsKey('countInit')) {
      dynamic tmpCount = params['countInit'];
      if (tmpCount is double) {
        _count = tmpCount.toInt();
      } else if (tmpCount is String) {
        _count = int.parse(tmpCount);
      } else if (tmpCount is int) {
        _count = tmpCount;
      } else {
        _count = -2;
      }
    } else {
      _count = 0;
    }
    print("$_count");
    await setLogLabel("start");
    final SendPort send = IsolateNameServer.lookupPortByName(isolateName)!;
    send.send(null);
  }

  Future<void> dispose() async {
    print("***********Dispose callback handler");
    print("$_count");
    await setLogLabel("end");
    final SendPort send = IsolateNameServer.lookupPortByName(isolateName)!;
    send.send(null);
  }

  Future<void> callback(LocationDto locationDto) async {
    print('$_count location in dart: ${locationDto.toString()}');
    await setLogPosition(_count, locationDto);
    makeCheckPoint(locationDto: locationDto, count: _count);
  }

  static Future<void> setLogLabel(String label) async {
    final date = DateTime.now();
    await FileManager.writeToLogFile(
        '------------\n$label: ${formatDateLog(date)}\n------------\n');
  }

  static Future<void> setLogPosition(int count, LocationDto data) async {
    final date = DateTime.now();
    await FileManager.writeToLogFile(
        '$count : ${formatDateLog(date)} --> ${formatLog(data)} --- isMocked: ${data.isMocked}\n');
  }

  static double dp(double val, int places) {
    var mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  static String formatDateLog(DateTime date) {
    return "${date.hour}:${date.minute}:${date.second}";
  }

  static String formatLog(LocationDto locationDto) {
    return "${dp(locationDto.latitude, 4)} ${dp(locationDto.longitude, 4)}";
  }

  Future<void> makeCheckPoint({
    required LocationDto locationDto,
    required int count,
  }) async {
    await Firebase.initializeApp();
    LocationModel locationModel = LocationModel(
      userName: "Check Point",
      address: "",
      image: ConstantsManger.Check_Point,
      isMocking: locationDto.isMocked,
      description: "Check Point",
      note: "Check Point",
      lat: locationDto.latitude,
      lon: locationDto.longitude,
      time: formatTime(),
      id: ConstantsManger.DEFULT,
      userId: FirebaseAuth.instance.currentUser!.uid,
      date: formatDate(),
    );



    FirebaseFirestore.instance
        .collection(ConstantsManger.LOCATION)
        .where("time", isEqualTo: formatTime())
        .get()
        .then((mo) {
      if (mo.size == 0) {
        FirebaseFirestore.instance
            .collection(ConstantsManger.LOCATION)
            .add(locationModel.toMap())
            .then((value) {
          FirebaseFirestore.instance
              .collection(ConstantsManger.LOCATION)
              .doc(value.id)
              .update({"id": value.id});
        });
      }
    });
      await setLogPosition(_count, locationDto);
      final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
      send?.send(locationDto.toJson()); //corrected.
      _count++;

  }
}
