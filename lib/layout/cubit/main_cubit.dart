import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hook_atos/model/LineModel.dart';
import 'package:hook_atos/model/Visit.dart';
import 'package:hook_atos/ui/screens/line_visits/lineVisits.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart' as per;
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:hook_atos/model/customers_model.dart';
import 'package:hook_atos/model/location_model.dart';
import 'package:hook_atos/shared/helper/icon_broken.dart';
import 'package:hook_atos/shared/helper/location_helper.dart';
import 'package:hook_atos/shared/helper/mangers/constants.dart';
import 'package:hook_atos/shared/services/local/cache_helper.dart';
import 'package:hook_atos/ui/screens/location_screen/location_screen.dart';
import 'package:hook_atos/ui/screens/location_screen/location_service_repository.dart';
import 'package:hook_atos/ui/screens/settings_screen/settings_screen.dart';
import '../../model/users_model.dart';
import '../../shared/helper/methods.dart';
import '../../shared/services/network/dio_helper.dart';
import '../../ui/screens/location_screen/file_manager.dart';
import '../../ui/screens/search_screen/search_screen.dart';
import '../../ui/screens/today_work/today_work.dart';
import '../../ui/screens/user_report/user_report_screen.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());

  int currentIndex = 0;

  static MainCubit get(context) => BlocProvider.of(context);

  void changeIndexNumber(int index) {
    currentIndex = index;
    if (index == 2) {
      getWorkToday();



    } else if (index == 4) {
      getUserData();
    }
    else if(index==0){
getUserData();
      getLines();

    }

    emit(ChangeBottomNavigationIndex());
  }

  List<BottomNavigationBarItem> navList = [
    const BottomNavigationBarItem(
        icon: Icon(
          IconBroken.User1,
        ),
        label: "العملاء"),
    const BottomNavigationBarItem(
        icon: Icon(
          IconBroken.Location,
        ),
        label: "الموقع"),
    const BottomNavigationBarItem(
        icon: Icon(
          IconBroken.Work,
        ),
        label: "عمل اليوم"),
    const BottomNavigationBarItem(
        icon: Icon(
          IconBroken.Activity,
        ),
        label: "التقارير"),
    const BottomNavigationBarItem(
        icon: Icon(
          IconBroken.Setting,
        ),
        label: "الإعدادت"),
  ];

  List<String> titles = [
    "العملاء",
    "الموقع",
    "عمل اليوم",
    "التقارير",
    "الإعدادات"
  ];
  List<Widget> screens = [
    const SearchScreen(),
    LocationScreen(),
    MyLine(),
    UserReportScreen(FirebaseAuth.instance.currentUser!.uid),
    const SettingScreen(),
  ];

  ////////////////// LocationSysyem ////////////////////////////////
  Location location = new Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? locationData;
  StreamSubscription<LocationData>? _locationDatatSub;
  bool? isMocking;


  Future<void> listenLocation() async {
    await setUpPermissions(start: false);
    _locationDatatSub = location.onLocationChanged.handleError((error) {
      _locationDatatSub?.cancel();
      _locationDatatSub = null;
    }).listen((loca) async {
      print(loca.latitude);
      await FirebaseFirestore.instance
          .collection(ConstantsManger.USERS)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"lat": loca.latitude, "lon": loca.longitude});
    });
    Future.delayed(
      Duration(seconds: 60),
      () async {
        await _locationDatatSub!.cancel();
        _locationDatatSub = null;
      },
    );
  }

  void setUpWorkManger() async {
    await setUpPermissions(start: true);
    updateToken();
    FirebaseMessaging.instance.getToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data['type'] == "track") {
        listenLocation();
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['type'] == "track") {
        listenLocation();
      }
    });
    Timer.periodic(const Duration(seconds: 20), (Timer t) async {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled!) {
        _sendNotifiationToAdmin(
            title: "Turning of GPS", body: "Turning of GPS");
        if (!_serviceEnabled!) {
          _serviceEnabled = await location.requestService();

          return;
        }
      }
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _sendNotifiationToAdmin(
            title: "Turning of Permision", body: "Turning of Permision");
        if (_permissionGranted != PermissionStatus.granted) {
          _permissionGranted = await location.requestPermission();
          return;
        }
      }
      var status = await per.Permission.locationAlways.status;
      if (status.isDenied) {
        per.Permission.locationAlways.request();
      }
    }); //Using GeoLocator
  }

  void updateToken() {
    FirebaseMessaging.instance.getToken().then((token) async {
      await FirebaseFirestore.instance
          .collection(ConstantsManger.USERS)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"token": token});
    });
  }

  Future<void> setUpPermissions({bool start = true}) async {
    try {
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

      var status = await per.Permission.locationAlways.status;
      if (status.isDenied) {
        per.Permission.locationAlways.request();
      }

      if (start) {
        _initLocationScreen();
      }
      locationData = await location.getLocation();
      print("Location ${locationData!.longitude}");
      isMocking = locationData!.isMock;
      if (isMocking == true) {
        _mockingUser();
      }
    } catch (error) {
      emit(ShowCatchError(error.toString()));
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

  Future<void> sendPushNotification(String fcmToken, String message,String title) async {
    String serverKey = 'YOUR_SERVER_KEY'; // Obtain your FCM server key from the Firebase console
    String url = 'https://fcm.googleapis.com/fcm/send';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=AAAATed1J9w:APA91bFpWFaLdjQ1fT6QS-uhacEqsFy8CmcDynSSHRuPoeSZBlu5kWpoZfBP9d4tEFLLv07Uf9cc0-zdNKKEkkTlbOdQVogpTR4Z-GyPpYq0dMfJL5D8VyBkPE4ZbiVb6LTrTBy_Z9bF',
    };

    Map<String, dynamic> body = {
      'to': fcmToken,
      'notification': {
        'title': title,
        'body': message,
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      },
      'data': {
        'message': message,
      },
    };

    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      print('Push notification sent successfully!');
    } else {
      print('Failed to send push notification: ${response.body}');
    }
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
        print(token);

        sendPushNotification(token, body,userModel.username!);

      });
    }

    );
  }


  LocationData? currentLocationData;

  void clearData() {
    FirebaseFirestore.instance
        .collection("location")
        .where("userId", isEqualTo: "EPLh6YTVDMYinqUQ2o2scMb4Trg2")
        .get()
        .then((value) {
      print(value.docs.length);
    });
  }

///////////////////////// UsersScreen /////////////////////////

  void addCustomer(
      { required File image,
        required String name,
        required String phone,
        required String line,
        required String speciality,
        required String classy,
        required String dist,
        required double lat,
        required double lon,
        required bool states,
        required String type,

      }) async {

    emit(LoadingState());

    try {
      bool result = await InternetConnectionChecker().hasConnection;
       var conn =  await InternetConnectionChecker().checkTimeout;
       print("000000000000bbbbbbbb"+conn.inSeconds.toString());

      if (result&&conn.inSeconds<30) {
        FirebaseFirestore.instance
            .collection("admin")
            .doc("admin")
            .get()
            .then((admin) async {
          int ver = admin.data()!['version'];
          if (ver != ConstantsManger.appVersion) {
            emit(UpdatePageState());
          } else {
            emit(AddNewCustomerLoading());

            AddressInfo addressInfo=await setUpAddress(locationData: locationData!);
            CustomerModel model = CustomerModel(
                id:FirebaseFirestore.instance.collection("customersV2").doc().id,
                userId: FirebaseAuth.instance.currentUser!.uid,
                date: formatDate(),
                address: addressInfo.address,
                time: formatTime(time: DateTime.now()),
                searchName: name.toLowerCase(),
                name: name,
                specialty: speciality,
                line: line,
                dist: dist,
                classy: classy,
                isMocking: isMocking,
                phone: phone,
                lat: lat,
                lon: lon,
           note: "",
           states: false,
type: type,

           //   planed: false,


              image: ConstantsManger.DEFULT



            );

            await FirebaseFirestore.instance
                .collection(ConstantsManger.CUSTOMERSList)
                .doc(phone)
                .get()
                .then((value) async {
              if (value.exists) {
                emit(PhoneAlreadyHere());
                return;
              } else {
                FirebaseFirestore.instance
                    .collection(ConstantsManger.CUSTOMERSList)
                    .doc(phone)
                    .set(model.toMap());
                await FirebaseFirestore.instance
                    .collection(ConstantsManger.USERS)
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .update({"lat": lat, "lon": lon});

                await FirebaseFirestore.instance
                    .collection(ConstantsManger.CUSTOMERSVistind)
                    .doc(ConstantsManger.CUSTOMERSVistind)
                    .collection(phone)
                    .add(model.toMap())
                    .then((modelUrl) async {
                  //upload image to storge
                  await firebase_storage.FirebaseStorage.instance
                      .ref()
                      .child("CustomerImage")
                      .child(Uri.file(image.path).pathSegments.last)
                      .putFile(image)
                      .then((p0) {
                    p0.ref.getDownloadURL().then((imageUrl) async {
                      FirebaseFirestore.instance
                          .collection(ConstantsManger.CUSTOMERSVistind)
                          .doc(ConstantsManger.CUSTOMERSVistind)
                          .collection(phone)
                          .doc(modelUrl.id)
                          .update({"image": imageUrl, "id": modelUrl.id});

                      FirebaseFirestore.instance
                          .collection(ConstantsManger.CUSTOMERSList)
                          .doc(phone).update({"image": imageUrl});


                      await FirebaseFirestore.instance
                          .collection(ConstantsManger.USERS)
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({"image": imageUrl});


                      FirebaseFirestore.instance
                          .collection(ConstantsManger.LOCATION)
                          .where("date", isEqualTo: formatDate())
                          .where("userId",
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                          .get()
                          .then((data) async {
                        // LocationModel locationModel = LocationModel(
                        //     note: "",
                        //     image: imageUrl,
                        //     userName: name,
                        //     address:
                        //         await setUpAddress(locationData: locationData!),
                        //     isMocking: isMocking,
                        //     description: "visit",
                        //     lat: locationData!.latitude,
                        //     lon: locationData!.longitude,
                        //     time: formatTime(),
                        //     id: ConstantsManger.DEFULT,
                        //     userId: FirebaseAuth.instance.currentUser!.uid,
                        //     date: formatDate());
                        //
                        // FirebaseFirestore.instance
                        //     .collection(ConstantsManger.LOCATION)
                        //     .add(locationModel.toMap())
                        //     .then((q12) {
                        //   FirebaseFirestore.instance
                        //       .collection(ConstantsManger.LOCATION)
                        //       .doc(q12.id)
                        //       .update({"image": imageUrl, "id": q12.id});
                        // });
                      });
                    }).then((value) {
                      emit(AddNewCustomerSuccess());
                    });
                  });
                });
              }
            });
          }
        });
      } else {
        emit(ShowNetWORKError("لا يوجد إتصال بالانترنت"));
      }
    } catch (error) {
      emit(ShowCatchError(error.toString()));
    }
  }

  List<Line>lines=[];
  List<String>linesNames=[];

  List<String>linesClssifications=[];

  Future<void> getLines() async {

    getUserData();
if(userModel?.group == 'Atos') {

  final CollectionReference linesCollection = FirebaseFirestore.instance
      .collection('lines');
  print(userModel?.group);
  final QuerySnapshot querySnapshot = await linesCollection.get();
  final List<QueryDocumentSnapshot> documents = querySnapshot.docs;
  lines =
      documents.map((doc) => Line.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
  linesNames.clear();
  for (var linename in lines) {
    linesNames.add(linename.name);
  }
}
else
  {
    final CollectionReference linesCollection = FirebaseFirestore.instance
        .collection('${userModel?.group}');
    print(userModel?.group);
    final QuerySnapshot querySnapshot = await linesCollection.get();
    final List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    lines =
        documents.map((doc) => Line.fromJson(doc.data() as Map<String, dynamic>))
            .toList();

    linesNames.clear();
    for (var linename in lines) {
      linesNames.add(linename.name);
    }
  }

  }

  List<String> typesList=[];
  void getAllType()  {

    FirebaseFirestore.instance
        .collection("dropdown data").doc("Type").get().

    then((value) {
      if (value.data()!['Type'] != null) {
        typesList.clear();
        for (String type in value.data()!['Type']) {
          typesList.add(type);
        }}
    });

  }

  List<CustomerModel> customerListSeach = [];

  void serachQuery({required String query}) {
    FirebaseFirestore.instance
        .collection("customersV2")
        .where('userId',isEqualTo: FirebaseAuth.instance.currentUser!.uid)

        .where('searchName',
        isGreaterThanOrEqualTo: query,
        isLessThan: query.substring(0, query.length - 1) +
            String.fromCharCode(query.codeUnitAt(query.length - 1) + 1))
        .get()
        .then((value) {
      customerListSeach.clear();
      value.docs.forEach((element) {
        customerListSeach.add(CustomerModel.fromJson(element.data()));
        print(customerListSeach.length);

      });
      emit(SeachListState());
    });
  }


  List<Visit> visitsOfTheDayList = [];

  void visitsOfTheDay(var selectedDate) {
    visitsOfTheDayList.clear();
    FirebaseFirestore.instance
        .collection("visitsV2").orderBy("time")
        .where('userId',isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('dateOfNextVisit',
        isEqualTo:DateFormat('dd/MM/yyyy').format(selectedDate).toString())
        .where('planed', isEqualTo: true) // Add this condition

        .get()
        .then((value) {

      print("AHHHHHHHHHHHHHHHHHHHHHHHHHHHHA");

      value.docs.forEach((element) {
        visitsOfTheDayList.add(
            Visit.fromJson(element.data())
        );
      });

      emit(SeachListState());
    });
  }



  bool isSearch = false;

  void getSearchScreen() {
    isSearch = !isSearch;
    emit(GetSeachScreen());
  }

  bool isVisit = false;

  void changeVisitState({required bool from}){
    isVisit = from;
    emit(ChangeVisitOrState());
  }

  List<CustomerModel> customersList = [];

  void getAllCustomers() {
    emit(GetCustomersdLoading());
    FirebaseFirestore.instance
        .collection(ConstantsManger.CUSTOMERSList)
        .snapshots()
        .listen((value) {
      customersList.clear();
      value.docs.forEach((element) {
        customersList.add(CustomerModel.fromJson(element.data()));
      });
      emit(GetCustomersdSuccess());
    });
  }

  List<CustomerModel> customer = [];
  void getCustomerByName(String name) {
    emit(GetCustomersdLoading());
    FirebaseFirestore.instance
        .collection(ConstantsManger.CUSTOMERSList)
        .where('name', isEqualTo: name)
        .get()
        .then((value) {

      customer.clear();
      value.docs.forEach((element) {
        customer.add(CustomerModel.fromJson(element.data()));
      });
      emit(GetCustomersdSuccess());
    });
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

      if (locationModel.description == "attend" && time < 6) {}
    });

    return _locationListCheck.isEmpty ? "" : "visit";
  }

  ///////////////////////////////////Location Screen ///////////////////////////////

  ReceivePort port = ReceivePort();

  String logStr = '';
  String msgStatus = "-";
  LocationDto? lastLocation;

  void _initLocationScreen() {
    if (IsolateNameServer.lookupPortByName(
            LocationServiceRepository.isolateName) !=
        null) {
      IsolateNameServer.removePortNameMapping(
          LocationServiceRepository.isolateName);
    }

    IsolateNameServer.registerPortWithName(
        port.sendPort, LocationServiceRepository.isolateName);

    port.listen(
      (dynamic data) async {
        //await updateUI(data);
      },
    );
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    print('Initializing...');
    await BackgroundLocator.initialize();
    logStr = await FileManager.readLogFile();
    print('Initialization done');
    final _isRunning = await BackgroundLocator.isServiceRunning();
    _getIsRunningState(isRung: _isRunning);
  }

  void onStop() async {
    await BackgroundLocator.unRegisterLocationUpdate();
    final _isRunning = await BackgroundLocator.isServiceRunning();
    _getIsRunningState(isRung: _isRunning);
    _sendNotifiationToAdmin(title: "إغلاق التتبع ", body: "قد تم إغلاق التتبع");
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("OnlineV2")
          .doc("${FirebaseAuth.instance.currentUser!.uid}");
      await transaction.delete(documentReference);
    });
  }

  void onStart() async {
await setUpPermissions();
    await startLocator();
    final _isRunning = await BackgroundLocator.isServiceRunning();
    lastLocation = null;
    _getIsRunningState(isRung: _isRunning);
    _sendNotifiationToAdmin(title: "تفعيل التتبع ", body: "قد تم تفعيل التتبع");
    await FirebaseFirestore.instance
        .collection(ConstantsManger.ONLINEhook_atos)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({"id": "${FirebaseAuth.instance.currentUser!.uid}"});
  }

  void _getIsRunningState({required bool isRung}) {
    if (isRung != null) {
      if (isRung == true) {
        msgStatus = 'Is running';
      } else {
        msgStatus = 'Is not running';
      }
    }
    emit(ChangeIsRunningState());
  }

//////////////////////////////////Today Work///////////////////////////////////////////
  List<LocationModel> locationList = [];

  void getWorkToday() {
    emit(GetTodayWorkLoading());
    FirebaseFirestore.instance
        .collection(ConstantsManger.LOCATION)
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("date", isEqualTo: formatDate())
        .orderBy("time", descending: true)
        .get()
        .then((event) {
      locationList.clear();
      event.docs.forEach((element) {
        print(element.data());
        LocationModel model = LocationModel.fromJson(element.data());
        if (model.description != "Check Point" &&
            model.image != ConstantsManger.DEFULT) {
          locationList.add(model);
        }
      });
      emit(GetCustomersdSuccess());
    });
  }
  // void getLineData() {
  //   emit(GetTodayWorkLoading());
  //   FirebaseFirestore.instance
  //       .collection(ConstantsManger.LINES).doc()
  //
  //       .get()
  //       .then((event) {
  //     locationList.clear();
  //     event.doc.forEach((element) {
  //       print(element.data());
  //       LocationModel model = LocationModel.fromJson(element.data());
  //       if (model.description != "Check Point" &&
  //           model.image != ConstantsManger.DEFULT) {
  //         locationList.add(model);
  //       }
  //     });
  //     emit(GetCustomersdSuccess());
  //   });
  // }

  Future onRefreshGetWorkToday() async {
    getWorkToday();
    return "";
  }
  //
  // Future onRefreshGetVisitsoftheday() async {
  //   visitsOfTheDay();
  //   return "";
  // }
  ///////////////////////////////////////////////////////////////

  final ImagePicker _picker = ImagePicker();
  File? imageFile;

  void uploadUserImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageFile = File(image.path);
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child("Users")
          .child(Uri.file(image.path).pathSegments.last)
          .putFile(imageFile!)
          .then((p) {
        p.ref.getDownloadURL().then((im) {
          FirebaseFirestore.instance
              .collection(ConstantsManger.USERS)
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({"image": im}).then((value) {
            emit(UpdateUserImage());
          });
        });
      });
    }
  }

  void signOutUser() {
    FirebaseAuth.instance.signOut().then((value) async {
      await CachedHelper.clearData();
      emit(SignOutUser());
    });
  }

  UserModel? userModel;

  void getUserData() {
    emit(GetUserDataLoading());
    FirebaseFirestore.instance
        .collection(ConstantsManger.USERS)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((event) {
      userModel = UserModel.fromJson(event.data() ?? {});
      emit(GetUserDataSuccess());
    });
  }


}

