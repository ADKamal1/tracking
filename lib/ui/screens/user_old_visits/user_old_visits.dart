import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hook_atos/model/customers_model.dart';
import 'package:hook_atos/shared/helper/mangers/size_config.dart';
import 'package:hook_atos/shared/helper/methods.dart';
import 'package:hook_atos/ui/components/app_text.dart';
import 'package:hook_atos/ui/screens/map2/map_2.dart';
import 'package:hook_atos/ui/screens/map_screen_distance/map_screen_distance.dart';
import 'package:hook_atos/ui/screens/user_old_visits/cubit/user_visits_cubit.dart';
import 'package:tbib_toast/tbib_toast.dart';
import '../../../shared/helper/enum_hlper/NetworkAwareWidget.dart';
import '../../../shared/helper/enum_hlper/network_status_service.dart';
import '../add_user_visit/add_user_visit.dart';
import '../upgrade_screen/update_screen.dart';
import 'compoents/add_visit_design.dart';
import 'compoents/visits_design.dart';
import 'package:provider/provider.dart';

class UserOldVisitsScreen extends StatelessWidget {
  CustomerModel customerModel;

  UserOldVisitsScreen(this.customerModel);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<NetworkStatus>(
      create: (context) => NetworkStatusService().networkStatusController.stream,
      initialData: NetworkStatus.Online,
      child: NetworkAwareWidget(
          onlineChild: Builder(builder: (context) {
            UserVisitsCubit.get(context).getUserVists(phone: customerModel.phone??"");
            return BlocConsumer<UserVisitsCubit, UserVisitsState>(
              listener: (context, state) {
                if (state is AddVistingSuccess) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                } else if (state is AddVistingLoading) {
                  showCustomProgressIndicator(context);
                } else if (state is ErrorGPS) {
                  showSnackBar(context,
                      " تم إرسال رسالة للمدير بقفل الGps من فضلك قم بتشغيله");
                } else if (state is PerrmisionError) {
                  showSnackBar(context,
                      " تم إرسال رسالة للمدير بقفل الصلاحيات من فضلك قم بتشغيلها");
                } else if (state is UpdatePageState) {
                  navigateToAndFinish(context, UpdateScreen());
                }
              },
              builder: (context, state) {
                LatLng lngUser = LatLng(customerModel.lat??0.0,customerModel.lon??0.0 );
                UserVisitsCubit cubit = UserVisitsCubit.get(context);
                return Scaffold(
                  appBar: AppBar(
                    actions: [
                      IconButton(
                          onPressed: () async {
                            await cubit.setUpPermissions();
                            LatLng myPos = LatLng(
                                cubit.locationData!.latitude ?? 0.0,
                                cubit.locationData!.longitude ?? 0.0);
                            navigateTo(
                                context,
                                Map2(
                                    myPos: myPos,
                                    name: customerModel.name??"",
                                    customerPos: lngUser));
                          },
                          icon: Icon(Icons.my_location))
                    ],
                    title: AppText(text: customerModel.name??"", textSize: 30),
                    centerTitle: true,
                  ),
                  body: state is GetOldVisitsLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.separated(
                          itemBuilder: (context, index) {
                            return VisitsDesign(cubit.customerVistsList[index]);
                          },
                          separatorBuilder: (context, index) => SizedBox(
                              height: getProportionateScreenHeight(10)),
                          itemCount: cubit.customerVistsList.length),
                  floatingActionButton: FloatingActionButton(
                                     onPressed: () => navigateTo(context, AddUserVisitScreen(customerModel,false,""),
                  ),
                    child: Icon(Icons.add),
                  ),
                );
              },
            );
          }),
          offlineChild: BlocProvider(
            create: (context) => UserVisitsCubit()..setUpOnlineOfflineMode(isOnline: false),
            child: BlocConsumer<UserVisitsCubit, UserVisitsState>(
              listener: (context, state) {},
              builder: (context, state) {
                return Scaffold(
                  body: Center(
                    child: Container(
                        child: AppText(
                      text:
                          "من فضلك قم بتشغيل الانترنت خلال 3 دقايق والا سيتم ارسال رسالة للادمن",
                      maxLines: 4,
                      fontWeight: FontWeight.bold,
                    )),
                  ),
                );
              },
            ),
          )),
    );
  }
}
