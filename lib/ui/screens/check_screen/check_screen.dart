import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hook_atos/shared/helper/mangers/size_config.dart';
import 'package:hook_atos/shared/helper/methods.dart';
import 'package:hook_atos/shared/services/local/cache_helper.dart';
import 'package:hook_atos/ui/components/app_text.dart';
import 'package:hook_atos/ui/components/custom_button.dart';
import 'package:hook_atos/ui/screens/login_screen/login_screen.dart';

class CheckScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfigManger().init(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(text: "Your Are Banned",textSize: 35,fontWeight: FontWeight.bold,color: Colors.red),
              SizedBox(height: SizeConfigManger.bodyHeight*0.05,),
              Container(
                height: SizeConfigManger.bodyHeight*0.35,
                width: SizeConfigManger.bodyHeight*0.35,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/error.png'),
                  ),
                ),
              ),
              SizedBox(height: SizeConfigManger.bodyHeight*0.05,),
              CustomButton(text: "Log Out",press: ()async{
                FirebaseAuth.instance.signOut();
                CachedHelper.clearData();
                navigateToAndFinish(context, LoginScreen());
              },)
            ],
          ),
        ),
      ),
    );
  }
}
