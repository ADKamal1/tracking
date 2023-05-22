import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hook_atos/layout/cubit/main_cubit.dart';
import 'package:hook_atos/shared/helper/icon_broken.dart';
import 'package:hook_atos/ui/components/app_text.dart';
import 'package:hook_atos/ui/components/custom_button.dart';

import '../../../shared/helper/mangers/size_config.dart';

class LocationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(22),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: SizeConfigManger.bodyHeight * .05),
                CustomButton(
                    height: SizeConfigManger.bodyHeight * .15,
                    text: "تشغيل الموقع",
                    backgroundColor: Colors.green,
                    press: () => MainCubit.get(context).onStart(),
                    borderColor: Colors.green),
                SizedBox(height: SizeConfigManger.bodyHeight * .05),
                CustomButton(
                  height: SizeConfigManger.bodyHeight * .15,
                  text: "إيقاف الموقع",
                  press: () => MainCubit.get(context).onStop(),
                ),
                SizedBox(height: SizeConfigManger.bodyHeight * .05),
                MainCubit.get(context).msgStatus == "Is running"
                    ? Icon(
                        IconBroken.Shield_Done,
                        size: SizeConfigManger.bodyHeight * .2,
                        color: Colors.green,
                      )
                    : Icon(
                        IconBroken.Shield_Fail,
                        size: SizeConfigManger.bodyHeight * .2,
                        color: Colors.red,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      color:MainCubit.get(context).msgStatus == "Is running"? Colors.green : Colors.red,
                      text:
                          "${MainCubit.get(context).msgStatus == "Is running" ? "يعمل " : "لا يعمل"} ",
                      textSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                    AppText(
                      text: "الموقع ",
                      textSize: 35,
                      color:MainCubit.get(context).msgStatus == "Is running"? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,

                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
