import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hook_atos/model/users_model.dart';
import 'package:meta/meta.dart';
import 'package:hook_atos/shared/services/local/cache_helper.dart';

import '../../../../shared/helper/mangers/constants.dart';
import '../../../../shared/services/network/dio_helper.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(BuildContext context) => BlocProvider.of(context);

  bool isPassword = true;

  void changePasswordVisibalty() {
    isPassword = !isPassword;
    emit(ChangePasswordVisibiltyState());
  }

  void signInUser({required String username, required String password}) {
    emit(LoginLoadingState());

    String mail = username.replaceAll(" ", "s").toLowerCase();

    FirebaseAuth.instance.signInWithEmailAndPassword(email:"${mail}@gmail.com" , password: password)
        .then((user) async{
          await CachedHelper.saveData(key: ConstantsManger.USERS_UID, value: user.user!.uid);
      FirebaseFirestore.instance
          .collection(ConstantsManger.USERS)
          .doc(user.user!.uid)
          .get()
          .then((userFromFirestore)async {
        UserModel userModel = UserModel.fromJson(userFromFirestore.data() ?? {});

        if(userModel.info == ConstantsManger.DEFULT) {
          var deviceInfo = DeviceInfoPlugin();
          var androidDeviceInfo = await deviceInfo.androidInfo;
          String uniqueDeviceId = '${androidDeviceInfo.model}:${androidDeviceInfo.id}';

          FirebaseFirestore.instance.collection(ConstantsManger.USERS).doc(user.user!.uid).update({"info":uniqueDeviceId});

          if (userModel.isActive == true) {
            FirebaseMessaging.instance.getToken().then((token) {
              FirebaseFirestore.instance
                  .collection(ConstantsManger.USERS)
                  .doc(user.user!.uid)
                  .update({"token": token});
            });

            emit(LoginSuccessState());
          }
          else {
            emit(LoginSuccessButBannedState());
          }
        }
        else
        {
          var deviceInfo = DeviceInfoPlugin();
          var androidDeviceInfo = await deviceInfo.androidInfo;
          String uniqueDeviceId = '${androidDeviceInfo.model}:${androidDeviceInfo.id}';

          if(userModel.info == uniqueDeviceId){
            if (userModel.isActive == true) {
              FirebaseMessaging.instance.getToken().then((token) {
                FirebaseFirestore.instance
                    .collection(ConstantsManger.USERS)
                    .doc(user.user!.uid)
                    .update({"token": token});
              });

              emit(LoginSuccessState());
            }
            else {
              emit(LoginSuccessButBannedState());
            }
          }else
          {
            FirebaseFirestore.instance.collection(ConstantsManger.USERS).doc(user.user!.uid).update({"isActive":false});
            _sendNotifiationToAdmin(title: "Banned User",body: "banned while trying login from anther device");
            emit(LoginSuccessButBannedState());

          }

        }
      });
    }).catchError((error) {
      emit(LoginErrorState(errorMsg: error.toString()));
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
          "to": token,
          "notification": {
            "body": "${userModel.username} is $body",
            "title": title,
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
          if (value.statusCode == 200) {}
        });

      });
    });
  }

}
