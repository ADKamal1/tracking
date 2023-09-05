import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hook_atos/model/Visit.dart';
import 'package:hook_atos/model/customers_model.dart';
import 'package:hook_atos/shared/helper/mangers/constants.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as per;

import '../../../../model/location_model.dart';
import '../../../../model/online_report_model.dart';
import '../../../../model/users_model.dart';
import '../../../../shared/helper/methods.dart';
import '../../../../shared/services/network/dio_helper.dart';

part 'user_visits_state.dart';

class UserVisitsCubit extends Cubit<UserVisitsState> {
  UserVisitsCubit() : super(UserVisitsInitial());

  static UserVisitsCubit get(context) => BlocProvider.of(context);

  Location location = new Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? locationData;
  bool? isMocking;

  List<CustomerModel> customerVistsList = [];

  void getUserVists({required String phone}) {
    setUpOnlineOfflineMode(isOnline: true);
    emit(GetOldVisitsLoading());
    FirebaseFirestore.instance
        .collection(ConstantsManger.CUSTOMERSVistind)
        .doc(ConstantsManger.CUSTOMERSVistind)
        .collection(phone)
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((event) {
      customerVistsList.clear();
      event.docs.forEach((cus) {
        customerVistsList.add(CustomerModel.fromJson(cus.data()));
      });
      emit(GetOldVisitsSuccess());
    });
  }

  bool isVisit = false;

  void changeVisitState({required bool from}) {
    isVisit = from;
    emit(ChangeVisitOrOState());
  }

  void setUpOnlineOfflineMode({required bool isOnline}) {
    FirebaseFirestore.instance
        .collection(ConstantsManger.ONLINEREPORT)
        .where("time", isEqualTo: formatTime())
        .get()
        .then((value) {
      if (value.docs.length == 0) {
        OnlineReport onlineReport = OnlineReport(
            id: FirebaseAuth.instance.currentUser!.uid,
            isOnline: isOnline,
            time: formatTime(),
            date: formatDate());
        FirebaseFirestore.instance
            .collection(ConstantsManger.ONLINEREPORT)
            .add(onlineReport.toMap());
      }
    });
  }

  Future<void> setUpPermissions() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    var statue1 = await per.Permission.location.status;
    if (statue1.isRestricted ||
        statue1.isDenied ||
        statue1.isLimited ||
        statue1.isPermanentlyDenied) {
      per.Permission.location.request();
    }
    var status = await per.Permission.locationAlways.status;
    if (status.isDenied) {
      per.Permission.locationAlways.request();
    }
    if (status.isRestricted ||
        status.isDenied ||
        status.isLimited ||
        status.isPermanentlyDenied) {
      per.Permission.locationAlways.request();
    }

    locationData = await location.getLocation();
    print(locationData!.longitude);
    isMocking = locationData!.isMock;
    if (isMocking == true) {
      _mockingUser();
    }
  }

  void _mockingUser() {
    FirebaseFirestore.instance
        .collection(ConstantsManger.USERS)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"isMocking": true}).then((value) {
      _sendNotifiationToAdmin(title: "Fake GPS", body: "using fake gps");
    });
  }

  void _sendNotifiationToAdmin({required String title, required String body}) {
    FirebaseFirestore.instance
        .collection(ConstantsManger.USERS)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((user) {
      UserModel userModel = UserModel.fromJson(user.data() ?? {});
      FirebaseFirestore.instance
          .collection("admin")
          .doc("admin")
          .get()
          .then((admin) {
        String token = admin.data()!['token'];
        final data = {
          "to": "${token}",
          "notification": {
            "body": "${userModel.username} is ${body}",
            "title": "${title}",
            "sound": "default"
          },
          "android": {
            "priority": "HIGH",
            "notification": {
              "notification_priority": "PRIORITY_HIGH",
              "sound": "default",
              "default_sound": true,
              "default_vibrate_timings": true,
              "default_light_settings": true,
            },
          },
          "data": {
            "type": "Cheating",
            "id": "87",
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
          }
        };
        DioHelper().postData(path: 'fcm/send', data: data).then((value) {
          if (value.statusCode == 200) {
            print("Done Sending ");
          }
        });
      });
    });
  }

  Future<String?> addVisitUser({
    required double orginalLat,
    required double orginalLong,
    required String phone,
    required String line,
    required String specilty,
    required String classy,
    required String dist,
    required String name,
    required String userName,
    required String image,
    required String visitDate,
    required String nextVisitDate,
    required bool states,
    required bool planed,
    required String note,
    required String type,

    // required Product product
  }) async {
    try {
      emit(AddVistingLoading());
      FirebaseFirestore.instance
          .collection("admin")
          .doc("admin")
          .get()
          .then((admin) async {
        int ver = admin.data()!['version'];
        if (ver != ConstantsManger.appVersion) {
          emit(UpdatePageState());
        } else {
          await setUpPermissions();

          var _distanceInMeters = GeolocatorPlatform.instance.distanceBetween(
              locationData!.latitude!,
              locationData!.longitude!,
              orginalLat,
              orginalLong);

          AddressInfo addressInfo =
              await setUpAddress(locationData: locationData!);

          List mm = "$_distanceInMeters".split(".");
          String m = mm[0];
          int mLast = int.parse(m);
          print(mLast.toString());

          Visit previsit = Visit(
              userId: FirebaseAuth.instance.currentUser!.uid,
              name: name,
              searchName: name,
              phone: phone,
              line: line,
              classy: classy,
              dist: dist,
              specialty: specilty,
              dateOfNextVisit: nextVisitDate,
              address: addressInfo.address,
              dateOfVisit: visitDate,
              time: DateFormat('dd/MM/yyyy').format(DateTime.now()).toString(),
              planed: planed,
              status: states,
              note: note,
              visitId: '',
              image: image,
              governorate: addressInfo.governorate,
              isMocking: isMocking,
              type: type);
          if (mLast < 200) {
            if (planed == false) {
              CollectionReference visitCollection =
                  FirebaseFirestore.instance.collection('visitsV2');
              DocumentReference visitDocRef;
              visitDocRef = await visitCollection.add(previsit.toMap());
              String visitId = visitDocRef.id;

              visitDocRef.update({
                'visitId': visitId,
                'image': image,
                'status': true,
                'note': "un planed visit",
              }).whenComplete(() {
                FirebaseFirestore.instance.collection('completed visits').add({
                  ...previsit.toMap(),
                  "completedDate": DateFormat('dd/MM/yyyy')
                      .format(DateTime.now())
                      .toString(),
                  "completedTime": DateTime.now(),
                  'visitId': visitId,
                });
              });

              CollectionReference visitCollection2 =
              FirebaseFirestore.instance.collection('visitsV2');
              DocumentReference visitDocRef2;
              visitDocRef2 = await visitCollection.add(previsit.toMap());
              String visitId2 = visitDocRef2.id;
              visitDocRef2.update({
                'visitId': visitId2,
                'image': image,
                'status': false,
                'note': note,
                'planed':true
              });


              Visit visit = Visit(
                  userId: FirebaseAuth.instance.currentUser!.uid,
                  name: name,
                  searchName: name,
                  phone: phone,
                  line: line,
                  classy: classy,
                  dist: dist,
                  specialty: specilty,
                  dateOfNextVisit: nextVisitDate,
                  address: addressInfo.address,
                  dateOfVisit: visitDate,
                  time: DateTime.now().toString(),
                  planed: planed,
                  status: states,
                  note: note,
                  visitId: visitId,
                  image: image,
                  governorate: addressInfo.governorate,
                  isMocking: isMocking,
                  type: type);
              await FirebaseFirestore.instance
                  .collection(ConstantsManger.USERS)
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .update({
                "lat": locationData!.latitude,
                "lon": locationData!.longitude
              });

              await FirebaseFirestore.instance
                  .collection(ConstantsManger.CUSTOMERSVistind)
                  .doc(ConstantsManger.CUSTOMERSVistind)
                  .collection(phone)
                  .add(visit.toMap());

              await FirebaseFirestore.instance
                  .collection(ConstantsManger.LOCATION)
                  .where("date", isEqualTo: formatDate())
                  .where("userId",
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .get()
                  .then((date) async {
                LocationModel locationModel = LocationModel(
                    userName: userName,
                    image: image,
                    address: addressInfo.address,
                    isMocking: isMocking,
                    description: setUpDescription(date),
                    lat: locationData!.latitude,
                    lon: locationData!.longitude,
                    time: formatTime(),
                    id: ConstantsManger.DEFULT,
                    userId: FirebaseAuth.instance.currentUser!.uid,
                    date: formatDate(),
                    note: note);

                await FirebaseFirestore.instance
                    .collection(ConstantsManger.LOCATION)
                    .add(locationModel.toMap());
              });

              emit(AddVistingSuccess());
            } else {
              CollectionReference visitCollection =
                  FirebaseFirestore.instance.collection('visitsV2');
              DocumentReference visitDocRef;
              visitDocRef = await visitCollection.add(previsit.toMap());
              String visitId = visitDocRef.id;
              visitDocRef.update({
                'visitId': visitId,
                'image': image,
                'status': states,
                'note': note
              }).whenComplete(() {
                FirebaseFirestore.instance.collection('completed visits').add({
                  ...previsit.toMap(),
                  "completedDate": DateFormat('dd/MM/yyyy')
                      .format(DateTime.now())
                      .toString(),
                  'visitId': visitId
                });
              });

              Visit visit = Visit(
                  userId: FirebaseAuth.instance.currentUser!.uid,
                  name: name,
                  searchName: name,
                  phone: phone,
                  line: line,
                  classy: classy,
                  dist: dist,
                  specialty: specilty,
                  dateOfNextVisit: nextVisitDate,
                  address: addressInfo.address,
                  dateOfVisit: visitDate,
                  time: DateFormat('dd/MM/yyyy')
                      .format(DateTime.now())
                      .toString(),
                  planed: planed,
                  status: states,
                  note: note,
                  visitId: visitId,
                  image: image,
                  governorate: addressInfo.governorate,
                  isMocking: isMocking,
                  type: type);
              await FirebaseFirestore.instance
                  .collection(ConstantsManger.USERS)
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .update({
                "lat": locationData!.latitude,
                "lon": locationData!.longitude
              });

              await FirebaseFirestore.instance
                  .collection(ConstantsManger.CUSTOMERSVistind)
                  .doc(ConstantsManger.CUSTOMERSVistind)
                  .collection(phone)
                  .add(visit.toMap());

              await FirebaseFirestore.instance
                  .collection(ConstantsManger.LOCATION)
                  .where("date", isEqualTo: formatDate())
                  .where("userId",
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .get()
                  .then((date) async {
                LocationModel locationModel = LocationModel(
                    userName: userName,
                    image: image,
                    address: addressInfo.address,
                    isMocking: isMocking,
                    description: setUpDescription(date),
                    lat: locationData!.latitude,
                    lon: locationData!.longitude,
                    time: formatTime(),
                    id: ConstantsManger.DEFULT,
                    userId: FirebaseAuth.instance.currentUser!.uid,
                    date: formatDate(),
                    note: note);
                await FirebaseFirestore.instance
                    .collection(ConstantsManger.LOCATION)
                    .add(locationModel.toMap());
              });

              emit(AddVistingSuccess());
            }
          } else {
            emit(AddVistingError(
                " متر ${mLast}انت بعيد عن المكان المحدد بمسافة ",
                locationData!.latitude!,
                locationData!.longitude!));
            return null;
          }
        }
      });
    } catch (error) {
      emit(TryCatchState(error.toString()));
    }
  }

  String setUpDescription(QuerySnapshot date) {
    if (date.docs.isEmpty) {
      return "attend";
    } else {
      return checkIsHereAnyLast2(date);
    }
  }

  List<LocationModel> _locationListCheck = [];

  String checkIsHereAnyLast2(QuerySnapshot date) {
    _locationListCheck.clear();
    date.docs.forEach((element) async {
      LocationModel locationModel =
          LocationModel.fromJson(element.data() as Map<String, dynamic>);

      if (locationModel.description == "attend" ||
          locationModel.description == "visit") {
        _locationListCheck.add(locationModel);
      }

      var array = locationModel.time!.split(":");
      int time = int.parse(array.first);

      if (locationModel.description == "attend" && time < 6) {
        /*await Workmanager().registerPeriodicTask(
            "${DateTime.now().second.toString()}", ConstantsManger.LOCATION,
            frequency: Duration(minutes: 15),
            constraints: Constraints(16/





                networkType: NetworkType.not_required,
                requiresBatteryNotLow: false,
                requiresCharging: false,
                requiresDeviceIdle: false,
                requiresStorageNotLow: false),
            initialDelay: Duration(minutes: 15));*/
      }
    });

    return _locationListCheck.isEmpty ? "attend" : "visit";
  }
}
