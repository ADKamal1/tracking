import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:hook_atos/layout/cubit/main_cubit.dart';
import 'package:hook_atos/shared/helper/icon_broken.dart';
import 'package:provider/provider.dart';
import 'package:tbib_toast/tbib_toast.dart';
import 'package:hook_atos/shared/helper/mangers/colors.dart';
import 'package:hook_atos/shared/helper/methods.dart';
import 'package:hook_atos/ui/screens/add_customer_screen/add_customer_screen.dart';
import '../shared/helper/enum_hlper/NetworkAwareWidget.dart';
import '../shared/helper/enum_hlper/network_status_service.dart';
import '../shared/helper/mangers/size_config.dart';
import '../ui/components/app_text.dart';
import '../ui/components/custom_text_form_field.dart';
import '../ui/screens/users_screen/component/custom_dialog.dart';
import '../ui/screens/users_screen/component/custom_user_item.dart';

class MainLayout extends StatefulWidget {
  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<NetworkStatus>(
      create: (context) =>
          NetworkStatusService().networkStatusController.stream,
      initialData: NetworkStatus.Online,
      child: NetworkAwareWidget(
          onlineChild: Container(
            child: BlocConsumer<MainCubit, MainState>(
              listener: (context, state) {
                if (state is PerrmisionError) {
                  Toast.show("Perrmsion Error", context);
                } else if (state is ErrorGPS) {
                  Toast.show("Gps Error", context);
                }
              },
              builder: (context, state) {
                MainCubit cubit = MainCubit.get(context);

                return Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    title: AppText(text: cubit.titles[cubit.currentIndex],textSize: 24,color: Colors.white,fontWeight: FontWeight.w600,),

                  ),
                  body: cubit.screens[cubit.currentIndex],
                  floatingActionButton: cubit.currentIndex == 0
                      ? FloatingActionButton(
                          onPressed: () {
                            navigateTo(context,  AddCustomerScreen());

                          },
                          child: Icon(IconBroken.Add_User),
                        )
                      : null,
                  bottomNavigationBar: BottomNavigationBar(
                    onTap: (index) {
                      cubit.changeIndexNumber(index);
                    },
                    items: cubit.navList,
                    currentIndex: cubit.currentIndex,
                  ),
                );
              },
            ),
          ),
          offlineChild: BlocProvider(
            create: (context) => MainCubit(),
            child: BlocConsumer<MainCubit, MainState>(
              listener: (context, state) {},
              builder: (context, state) {
                return Scaffold(
                  body: SafeArea(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenHeight(20)),
                        child: Container(
                            child: AppText(
                          align: TextAlign.center,
                          textSize: 25,
                          text: "من فضلك قم بتشغيل الانترنت لإستكمال العمل",
                          maxLines: 4,
                          fontWeight: FontWeight.bold,
                        )),
                      ),
                    ),
                  ),
                );
              },
            ),
          )),
    );
  }
}
