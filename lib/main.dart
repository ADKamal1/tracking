import 'dart:async';
import 'dart:developer';
import 'package:background_location/background_location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hook_atos/shared/helper/bloc_observer.dart';
import 'package:hook_atos/shared/helper/mangers/constants.dart';
import 'package:hook_atos/shared/services/local/cache_helper.dart';
import 'package:hook_atos/shared/services/network/dio_helper.dart';
import 'package:hook_atos/shared/styles/styles.dart';
import 'package:hook_atos/ui/screens/splash_screen/splash_screen.dart';
import 'package:hook_atos/ui/screens/user_old_visits/cubit/user_visits_cubit.dart';
import 'firebase_options.dart';
import 'layout/cubit/main_cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  FirebaseMessaging.instance.getToken();
   BackgroundLocation.setAndroidNotification(
    message: "background hook_atos Service Running",
    title: "hook_atos",
    icon: "@mipmap/ic_launcher",
  );
  BackgroundLocation.setAndroidConfiguration(2000);
  BackgroundLocation.startLocationService();
  BackgroundLocation.getLocationUpdates((loca) async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseFirestore.instance
          .collection(ConstantsManger.USERS)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"lat": loca.latitude, "lon": loca.longitude});
    }
  });
  Future.delayed(
    Duration(seconds: 60),
    () async {
      BackgroundLocation.stopLocationService();
    },
  );
}

// Future<void> setUpInteractedMessage() async {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//   ///Configure notification permissions
//   //IOS
//   await FirebaseMessaging.instance
//       .setForegroundNotificationPresentationOptions(
//     alert: true, // Required to display a heads up notification
//     badge: true,
//     sound: true,
//   );
//
//   //Android
//   NotificationSettings settings = await messaging.requestPermission(
//     alert: true,
//     announcement: false,
//     badge: true,
//     carPlay: false,
//     criticalAlert: false,
//     provisional: false,
//     sound: true,
//   );
//
//   log('User granted permission: ${settings.authorizationStatus}');
//
//   //Get the message from tapping on the notification when app is not in foreground
//   RemoteMessage? initialMessage = await messaging.getInitialMessage();
//
//   //If the message contains a service, navigate to the admin
//
//
//   //This listens for messages when app is in background
//   FirebaseMessaging.onMessageOpenedApp.listen((event) {
//
//   },);
//
//   //Listen to messages in Foreground
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//
//     //Initialize FlutterLocalNotifications
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
//
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'schedular_channel', // id
//       'Schedular Notifications', // title
//       description:
//       'This channel is used for Schedular app notifications.', // description
//       importance: Importance.max,
//     );
//
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//
//     //Construct local notification using our created channel
//     if (notification != null && android != null) {
//       flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               channelDescription: channel.description,
//               icon: "@mipmap/ic_launcher", //Your app icon goes here
//               // other properties...
//             ),
//           ));
//     }
//   });
// }
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.max,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus ==
      AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}
void loadFCM() async {
  if (!kIsWeb) {
    var channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.high,
      enableVibration: true,
    );

  //   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
void listenFCM() async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
       flutterLocalNotificationsPlugin;
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: 'launch_background',
          ),
        ),
      );
    }
  });
}
void main() {
  BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      if (Firebase.apps.length == 0) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      await Firebase.initializeApp();

      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: false,
      );
      // setUpInteractedMessage();
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      print('User granted permission: ${settings.authorizationStatus}');
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print('Message also contained a notification: ${message.notification}');
        }
      });

//loadFCM();

      await CachedHelper.init();
      DioHelper.init();
      runApp(MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => MainCubit()..setUpWorkManger()),
          BlocProvider(create: (context) => UserVisitsCubit(),
          ),
          BlocProvider(   create: (context) => MainCubit()..getLines()),

          BlocProvider(   create: (context) => MainCubit()..visitsOfTheDay())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Location',
          theme: ThemeManger.setLightTheme(),
          home: SplashScreen(),
        ));
  }
}
