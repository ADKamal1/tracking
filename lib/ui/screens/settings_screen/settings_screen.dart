import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hook_atos/layout/cubit/main_cubit.dart';
import 'package:hook_atos/shared/helper/mangers/constants.dart';
import 'package:hook_atos/shared/helper/methods.dart';
import 'package:hook_atos/ui/components/custom_button.dart';
import 'package:hook_atos/ui/screens/login_screen/login_screen.dart';
import 'package:tbib_toast/tbib_toast.dart';

import '../../../shared/helper/mangers/colors.dart';
import '../../../shared/helper/mangers/size_config.dart';
import '../../components/app_text.dart';
import 'componets/custom_card_item.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) async{
        if (state is SignOutUser) {
          navigateToAndFinish(context, LoginScreen());
          Toast.show("Logged Out", context,
              duration: 3, backgroundColor: Colors.red);

        }
      },
      builder: (context, state) {
        return MainCubit.get(context).userModel == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: SizeConfigManger.bodyHeight * 0.30,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            child: Container(
                              height: SizeConfigManger.bodyHeight * .22,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4),
                                  ),
                                  image: DecorationImage(
                                      image:
                                          AssetImage("assets/images/cover.jpg")
                                              as ImageProvider,
                                      fit: BoxFit.cover)),
                            ),
                            alignment: AlignmentDirectional.topCenter,
                          ),
                          InkWell(
                            onTap: () {
                              MainCubit.get(context).uploadUserImage();
                            },
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius:
                                          SizeConfigManger.bodyHeight * .084,
                                      backgroundColor: ColorsManger.darkPrimary,
                                    ),
                                    CircleAvatar(
                                      radius: SizeConfigManger.bodyHeight * .08,
                                      backgroundImage: MainCubit.get(context)
                                                  .userModel!
                                                  .image ==
                                              ConstantsManger.DEFULT
                                          ? AssetImage(
                                              "assets/images/defult_image.png")
                                          : NetworkImage(MainCubit.get(context)
                                              .userModel!
                                              .image!) as ImageProvider,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      end: getProportionateScreenHeight(5),
                                      bottom: getProportionateScreenHeight(5)),
                                  child: Icon(Icons.camera_alt,
                                      size: getProportionateScreenHeight(35),
                                      color: Colors.brown),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    Center(
                      child: AppText(
                        text: "${MainCubit.get(context).userModel!.username}",
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        textSize: 28,
                      ),
                    ),
                    CardItem(
                      title: "email",
                      detials: "${MainCubit.get(context).userModel!.email}",
                      prefix: Icons.email,
                    ),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    CardItem(
                      title: "phone",
                      detials: "${MainCubit.get(context).userModel!.phone}",
                      prefix: Icons.phone,
                    ),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    CardItem(
                      title: "App Version",
                      detials: "${ConstantsManger.appVersion}.0.0",
                      prefix: CupertinoIcons.settings,
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenHeight(20)),
                      child: CustomButton(
                        text: 'Log out',
                        press: () {
                          MainCubit.get(context).signOutUser();
                        },
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
