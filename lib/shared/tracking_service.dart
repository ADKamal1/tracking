/*
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/locator_settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart' as location;
import 'package:path_provider_android/path_provider_android.dart';
import 'package:permission_handler/permission_handler.dart' as p_handler;

class hook_atosService {
  ReceivePort port = ReceivePort();
  bool isRunning = false;

  // final lastLocation = <LocationDto>[].obs;

  Future<hook_atosService> init() async {
    if (IsolateNameServer.lookupPortByName(
          LocationServiceRepository.isolateName,
        ) !=
        null) {
      IsolateNameServer.removePortNameMapping(
        LocationServiceRepository.isolateName,
      );
    }
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      LocationServiceRepository.isolateName,
    );
    port.listen(
      (dynamic data) async {
        if (data == null || data is! LocationDto) return;
        // lastLocation.assignAll([data]);
      },
    );
    await initPlatformState();
    return this;
  }

  Future<void> initPlatformState() async {
    print('hook_atosService Initializing...');
    await BackgroundLocator.initialize();
    print('hook_atosService Initialization done');
    isRunning = await BackgroundLocator.isServiceRunning();
    print('hook_atosService Running ${isRunning.toString()}');
  }

  Future<void> stop() async {
    await BackgroundLocator.unRegisterLocationUpdate();
    isRunning = await BackgroundLocator.isServiceRunning();
  }

  Future<void> start({
    bool checkPermissions = true,
  }) async {
    try {
      _startLocator();
    } catch (error) {}
  }

  Future<void> _startLocator() async {
    // lastLocation.assignAll([]);

    final data = {};
    await FileManager.clearLogFile();
    await FileManager.writeToLogFile(json.encode(data));
    await BackgroundLocator.registerLocationUpdate(
      LocationCallbackHandler.callback,
      initCallback: LocationCallbackHandler.initCallback,
      initDataCallback: {
        'countInit': 1,
      },
      disposeCallback: LocationCallbackHandler.disposeCallback,
      // iosSettings: const IOSSettings(
      //   accuracy: LocationAccuracy.NAVIGATION,
      //   distanceFilter: 0,
      // ),
      // autoStop: true,
      androidSettings: AndroidSettings(
        accuracy: LocationAccuracy.HIGH,
        // interval: 60,
        // distanceFilter: 5,
        // client: LocationClient.google,
        // wakeLockTime: 120,
        androidNotificationSettings: AndroidNotificationSettings(
          // notificationChannelName: 'Location hook_atos',
          notificationTitle: 'hook_atos Notification Title',
          notificationMsg: 'hook_atos Notification Message',
          notificationBigMsg: 'hook_atos Notification Big Message',
          notificationTapCallback: LocationCallbackHandler.notificationCallback,
        ),
      ),
    );
    isRunning = await BackgroundLocator.isServiceRunning();
  }

*/
/*
  Future<bool> _checkLocationPermission() async {
    final access = await LocationPermissions().checkPermissionStatus();
    switch (access) {
      case PermissionStatus.unknown:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
        backgroundCollectLocationInfoDialog();
        return false;
      case PermissionStatus.granted:
        await _startLocator();
        return true;
      default:
        return false;
    }
  }
*//*


  Future<void> checkLocationServiceAndUpdateCloud({
    bool showSuccess = false,
  }) async {
    final locationService = location.Location();
    if (!await locationService.serviceEnabled()) {
      if (await locationService.requestService()) {
        // _checkLocationPermission();
      } else {
        // handleGPSClosed();
      }
    } else {
      //_checkLocationPermission();
    }
  }

*/
/*
  void handleGPSClosed() {
    defaultDialog(
      title: 'GPS is closed'.tr,
      content: Text(
        'GPS is needed to be opened'.tr,
        style: Get.textTheme.headline5,
      ),
      confirm: BlockButtonWidget(
        color: Get.theme.colorScheme.secondary,
        decoration: const BoxDecoration(),
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
        text: Text(
          'Allow'.tr,
          overflow: TextOverflow.ellipsis,
          style: Get.textTheme.headline6!.merge(
            TextStyle(
              color: Get.theme.primaryColor,
            ),
          ),
        ),
        onPressed: () async {
          Get.back();
          checkLocationServiceAndUpdateCloud();
        },
      ),
      cancel: BlockButtonWidget(
        color: Get.theme.focusColor.withOpacity(0.2),
        decoration: const BoxDecoration(),
        text: Text(
          'Cancel'.tr,
          overflow: TextOverflow.ellipsis,
          style: Get.textTheme.headline6,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
        onPressed: () => Get.back(),
      ),
    );
  }
*//*


}

mixin FileManager {
  static Future<void> writeToLogFile(String log) async {
    final file = await _getTempLogFile();
    await file.writeAsString(log, mode: FileMode.append);
  }

  static Future<String> readLogFile() async {
    final file = await _getTempLogFile();
    return file.readAsString();
  }

  static Future<File> _getTempLogFile() async {
    if (Platform.isAndroid) PathProviderAndroid.registerWith();

    // final directory = await getTemporaryDirectory();
    // final file = File('${directory.path}/log.txt');
    final directory = await PathProviderAndroid().getTemporaryPath();
    final file = File('$directory/log.txt');
    if (!await file.exists()) {
      await file.writeAsString('');
    }
    return file;
  }

  static Future<void> clearLogFile() async {
    final file = await _getTempLogFile();
    await file.writeAsString('');
  }
}

mixin LocationCallbackHandler {
  static Future<void> initCallback(Map<dynamic, dynamic> params) async {
    await LocationServiceRepository().init(params);
  }

  static Future<void> disposeCallback() async {
    await LocationServiceRepository().dispose();
  }

  static Future<void> callback(LocationDto locationDto) async {
    await LocationServiceRepository().callback(locationDto);
  }

  static Future<void> notificationCallback() async {
    print('***notificationCallback');
  }
}

class LocationServiceRepository {
  factory LocationServiceRepository() {
    return _instance;
  }

  LocationServiceRepository._();

  static final LocationServiceRepository _instance =
      LocationServiceRepository._();

  static const String isolateName = 'LocatorIsolate';

  int _count = -1;

  Future<void> init(Map<dynamic, dynamic> params) async {
    print("***********Init callback handler");
    if (params.containsKey('countInit')) {
      final tmpCount = params['countInit'];
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
    final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(null);
  }

  Future<void> dispose() async {
    print("***********Dispose callback handler");
    print("$_count");
    final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(null);
  }

  Future<void> callback(LocationDto locationDto) async {
    */
/*final dataFromFile = await FileManager.readLogFile();
    final data = json.decode(dataFromFile) as Map<String, dynamic>;*//*


    print(locationDto.longitude);
  }

  Future<void> updateFirebaseLocation({
    required LocationDto locationDto,
    required bool isProductionMode,
    required String driverId,
    required String driverName,
    required int count,
  }) async {
    print('$count location in dart: ${locationDto.toString()}');
    final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(locationDto);
    count++;
  }
}
*/
