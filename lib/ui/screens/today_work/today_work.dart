import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hook_atos/layout/cubit/main_cubit.dart';
import 'package:hook_atos/shared/helper/mangers/constants.dart';
import 'package:hook_atos/shared/helper/mangers/size_config.dart';
import 'package:hook_atos/shared/helper/methods.dart';
import 'package:hook_atos/ui/screens/map_screen/map_screen.dart';
import 'package:hook_atos/ui/screens/today_work/compoents/images_view.dart';

import '../../components/app_text.dart';

class TodayWork extends StatelessWidget {
  const TodayWork({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {},
      builder: (context, state) {
        MainCubit cubit = MainCubit.get(context);
        return cubit.locationList.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                child: RefreshIndicator(
                  onRefresh: ()async{
                    await cubit.onRefreshGetWorkToday();
                  },
                  child: ListView.separated(
                      itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              navigateTo(
                                  context,
                                  ImageViewPage(
                                      '${cubit.locationList[index].image}'));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: SizeConfigManger.bodyHeight * .12,
                                      width: SizeConfigManger.bodyHeight * .12,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: cubit.locationList[index].image !=
                                                      ConstantsManger.DEFULT
                                                  ? NetworkImage(
                                                      "${cubit.locationList[index].image}")
                                                  : AssetImage(
                                                          "assets/images/att.jpg")
                                                      as ImageProvider)),
                                    ),
                                    SizedBox(
                                      width: getProportionateScreenHeight(20),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                            text:
                                                "${cubit.locationList[index].userName}",
                                            color: cubit.locationList[index]
                                                        .isMocking ==
                                                    false
                                                ? Colors.black
                                                : Colors.red,
                                            fontWeight: FontWeight.bold),
                                        SizedBox(
                                            height:
                                                getProportionateScreenHeight(10)),
                                        AppText(
                                          text:
                                              "${cubit.locationList[index].description}",
                                          color: cubit.locationList[index]
                                                      .isMocking ==
                                                  false
                                              ? Colors.black
                                              : Colors.red,
                                        ),
                                        SizedBox(
                                            height:
                                                getProportionateScreenHeight(10)),
                                        AppText(
                                          text:
                                              "${cubit.locationList[index].time}",
                                          color: cubit.locationList[index]
                                                      .isMocking ==
                                                  false
                                              ? Colors.black
                                              : Colors.red,
                                        ),
                                        SizedBox(
                                            height:
                                                getProportionateScreenHeight(10)),
                                        InkWell(
                                          onTap: () {
                                            LatLng _postion = LatLng(
                                                cubit.locationList[index].lat!,
                                                cubit.locationList[index].lon!);
                                            navigateTo(
                                                context,
                                                MapScreen(
                                                    "${cubit.locationList[index].userName}",
                                                    _postion,
                                                    "${cubit.locationList[index].time}"));
                                          },
                                          child: AppText(
                                              color: Colors.blue,
                                              textDecoration:
                                                  TextDecoration.underline,
                                              text: "View on Map"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: getProportionateScreenHeight(15)),
                      itemCount: cubit.locationList.length),
                ),
              )
            : RefreshIndicator(
                onRefresh: () async {
                 await cubit.onRefreshGetWorkToday();
                },
                child: ListView());
      },
    );
  }
}
