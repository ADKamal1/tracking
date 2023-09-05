import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:hook_atos/model/AddressModel.dart';
import 'mangers/colors.dart';
import 'package:geocoding/geocoding.dart' as geo;

import 'mangers/constants.dart';

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateToAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (Route<dynamic> route) => false,
    );

void showSnackBar(BuildContext context, String errorMsg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(errorMsg),
    backgroundColor: Colors.black,
    duration: Duration(seconds: 5),
  ));
}

void showCustomProgressIndicator(BuildContext context) {
  AlertDialog alertDialog = AlertDialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(ColorsManger.darkPrimary),
      ),
    ),
  );

  showDialog(
    barrierColor: Colors.white.withOpacity(0),
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return alertDialog;
    },
  );
}

String formatDate({DateTime? date}) {
  if (date == null) {
    return DateFormat.yMMMEd().format(DateTime.now());
  } else {
    return DateFormat.yMMMEd().format(date);
  }
}

String formatTime({DateTime? time}) {
  if (time == null) {
    return DateFormat.Hms().format(DateTime.now());
  } else {
    return DateFormat.Hms().format(time);
  }
}

Future<AddressInfo> setUpAddress({required LocationData locationData}) async {
  List<geo.Placemark> addressList = await geo.placemarkFromCoordinates(
      locationData.latitude ?? 0.0, locationData.longitude ?? 0.0);
  String address =
      '${addressList[0].country} - ${addressList[0].administrativeArea} - ${addressList[0].subAdministrativeArea} - ${addressList[0].street}';
String governorate=addressList[0].administrativeArea.toString();
  return AddressInfo(address: address, governorate: governorate);
}
class AddressInfo {
  final String address;
  final String governorate;

  AddressInfo({
    required this.address,
    required this.governorate,
  });
}
