import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hook_atos/layout/cubit/main_cubit.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:hook_atos/shared/services/local/cache_helper.dart';
import 'package:hook_atos/ui/screens/check_screen/check_screen.dart';
import 'package:hook_atos/ui/screens/upgrade_screen/update_screen.dart';
import '../../../../shared/helper/mangers/size_config.dart';
import '../../../../shared/helper/methods.dart';
import '../../../layout/main_layout.dart';
import '../../../model/users_model.dart';
import '../../../shared/helper/mangers/colors.dart';
import '../../../shared/helper/mangers/constants.dart';
import '../login_screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  void checkUserState() {
    _timer = Timer(const Duration(seconds: 3), () async {
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        String uid = CachedHelper.getString(key: ConstantsManger.USERS_UID) ??
            ConstantsManger.DEFULT;
        print(uid);
        if (uid == ConstantsManger.DEFULT) {
          if (mounted) {
            FirebaseFirestore.instance
                .collection("admin")
                .doc("admin")
                .get()
                .then((admin) {
              int ver = admin.data()!['version'];
              if (ver == ConstantsManger.appVersion) {
                if (mounted) {
                  navigateToAndFinish(context, LoginScreen());
                }
              } else {
                if (mounted) {
                  navigateToAndFinish(context, UpdateScreen());
                }
              }
            });
          }
        } else {
          FirebaseFirestore.instance
              .collection(ConstantsManger.USERS)
              .doc(uid)
              .get()
              .then((userFromFirestore) {
            UserModel userModel =
                UserModel.fromJson(userFromFirestore.data() ?? {});
            if (userModel.isActive == true) {
              FirebaseFirestore.instance
                  .collection("admin")
                  .doc("admin")
                  .get()
                  .then((admin) {
                int ver = admin.data()!['version'];
                if (ver == ConstantsManger.appVersion) {
                  if (mounted) {
                    navigateToAndFinish(context, MainLayout());
                  }
                } else {
                  if (mounted) {
                    navigateToAndFinish(context, UpdateScreen());
                  }
                }
              });
            } else {
              if (mounted) {
                navigateToAndFinish(context, CheckScreen());
              }
            }
          });
        }
      } else {
        if (mounted) {
          showSnackBar(context, "من فضلك تحقق من إتصال الانترنت");
        }
      }
    });
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    checkUserState();

  }

  @override
  Widget build(BuildContext context) {
    SizeConfigManger().init(context);
    return Scaffold(
      backgroundColor: ColorsManger.darkPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: SizeConfigManger.bodyHeight * .3,
                height: SizeConfigManger.bodyHeight * .3,
                child: Image.asset("assets/images/HookTrack.png")),
            SizedBox(height: SizeConfigManger.bodyHeight * .008),
            Text('${ConstantsManger.appVersion}.0.0',
                style: TextStyle(
                  fontSize: getProportionateScreenHeight(16),
                  color: ColorsManger.darkPrimary,
                )),
          ],
        ),
      ),
    );
  }
}
