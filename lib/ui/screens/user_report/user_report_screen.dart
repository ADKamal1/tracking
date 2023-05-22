import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hook_atos/animation/faidAnimation.dart';
import '../../../model/location_model.dart';
import '../../../shared/helper/mangers/colors.dart';
import '../../../shared/helper/mangers/constants.dart';
import '../../../shared/helper/mangers/size_config.dart';
import '../../../shared/helper/methods.dart';
import '../../components/app_text.dart';
import '../../components/custom_button.dart';
import '../animated_map/animated_map.dart';
import 'compoents/images_view.dart';
import 'compoents/map_screen.dart';
import 'cubit/user_report_cubit.dart';

class UserReportScreen extends StatefulWidget {
  String uid;

  UserReportScreen(this.uid);

  @override
  State<UserReportScreen> createState() => _UserReportScreenState();
}

class _UserReportScreenState extends State<UserReportScreen> {
  DateTime? startDate;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserReportCubit(),
      child: BlocConsumer<UserReportCubit, UserReportState>(
        listener: (context, state) {},
        builder: (context, state) {
          UserReportCubit cubit = UserReportCubit.get(context);
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenHeight(20),
                        vertical: getProportionateScreenHeight(10)),
                    child:
                    CustomButton(
                      height: 65,
                      press: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020, 12, 31),
                          lastDate: DateTime.now(),
                        ).then((value) {
                          cubit.getUserLocation(userId: widget.uid, startDate: value!);
                          setState(() {
                            startDate = value;
                          });
                        });
                      },
                      text: "إختر تاريخ البداية",
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenHeight(20)),
                    child: CustomButton(
                      height: 65,
                      press: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020, 12, 31),
                          lastDate: DateTime.now(),
                        ).then((value) {
                          if(startDate !=null){
                            cubit.getUserLocation(
                                userId: widget.uid,
                                startDate: startDate!,
                                endDate: value!);
                          }

                        });
                      },
                      text: "إختر تاريخ الإنتهاء",
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  cubit.ReportList.length == 0
                      ? buildTotal(cubit.totalList, cubit)
                      : Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal:
                                          getProportionateScreenHeight(15)),
                                  child: ListView.separated(
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            // AwesomeDialog(context: context,
                                            // width: 350,
                                            // title: "ddddddddddddd",
                                            // animType: AnimType.TOPSLIDE,
                                            //
                                            // body:
                                            // Container(
                                            //   width: 350,
                                            //
                                            //   child: Card(
                                            //     elevation: 5,
                                            //     child: Padding(
                                            //       padding: const EdgeInsets.symmetric(
                                            //           horizontal: 24.0, vertical: 24),
                                            //       child: FadeAnimation(
                                            //         0.5,
                                            //         Column(
                                            //           crossAxisAlignment: CrossAxisAlignment.start,
                                            //           mainAxisAlignment: MainAxisAlignment.start,
                                            //           children: [
                                            //             Text(
                                            //               "Name : " ,
                                            //               style: TextStyle(
                                            //                   fontSize: 24,
                                            //                   fontWeight: FontWeight.w600),
                                            //             ),
                                            //             Text(
                                            //               "Phone : " ,
                                            //               style: TextStyle(
                                            //                   fontSize: 24,
                                            //                   fontWeight: FontWeight.w600),
                                            //             ),
                                            //             Text(
                                            //               "Adress : "  ,
                                            //               maxLines: 3,
                                            //               style: TextStyle(
                                            //                   fontSize: 16,
                                            //                   fontWeight: FontWeight.w600),
                                            //             ),
                                            //             Text(
                                            //               "Line : "  ,
                                            //               style: TextStyle(
                                            //                   fontSize: 24,
                                            //                   fontWeight: FontWeight.w600),
                                            //             ),
                                            //             Text(
                                            //               "Class : " ,
                                            //               style: TextStyle(
                                            //                   fontSize: 24,
                                            //                   fontWeight: FontWeight.w600),
                                            //             ),
                                            //             Text(
                                            //               "specilty : ",
                                            //               style: TextStyle(
                                            //                   fontSize: 24,
                                            //                   fontWeight: FontWeight.w600),
                                            //             ),
                                            //           ],
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                            //
                                            //
                                            //
                                            // )..show();
                                          },
                                          child:
                                          // Container(
                                          //   decoration: BoxDecoration(
                                          //       border: Border.all(
                                          //           color: Colors.grey),
                                          //       borderRadius:
                                          //           BorderRadius.circular(20)),
                                          //   child: Padding(
                                          //     padding: EdgeInsets.all(5),
                                          //     child: Row(
                                          //       mainAxisAlignment:
                                          //           MainAxisAlignment.start,
                                          //       crossAxisAlignment:
                                          //           CrossAxisAlignment.start,
                                          //       children: [
                                          //         Container(
                                          //           height: SizeConfigManger
                                          //                   .bodyHeight *
                                          //               .14,
                                          //           width: SizeConfigManger
                                          //                   .bodyHeight *
                                          //               .12,
                                          //           decoration: BoxDecoration(
                                          //               borderRadius:
                                          //                   BorderRadius
                                          //                       .circular(10),
                                          //               image: DecorationImage(
                                          //                   fit: BoxFit.cover,
                                          //                   image: cubit
                                          //                               .ReportList[
                                          //                                   index]
                                          //                               .image !=
                                          //                           ConstantsManger
                                          //                               .DEFULT
                                          //                       ? NetworkImage(
                                          //                           "${cubit.ReportList[index].image}")
                                          //                       : AssetImage(
                                          //                               "assets/images/att.jpg")
                                          //                           as ImageProvider)),
                                          //         ),
                                          //         SizedBox(
                                          //           width:
                                          //               getProportionateScreenHeight(
                                          //                   20),
                                          //         ),
                                          //         Column(
                                          //           crossAxisAlignment:
                                          //               CrossAxisAlignment
                                          //                   .start,
                                          //           children: [
                                          //             AppText(
                                          //                 text:
                                          //                     "${cubit.ReportList[index].userName}",
                                          //                 color: cubit
                                          //                             .ReportList[
                                          //                                 index]
                                          //                             .isMocking ==
                                          //                         false
                                          //                     ? Colors.black
                                          //                     : Colors.red,
                                          //                 fontWeight:
                                          //                     FontWeight.bold),
                                          //             SizedBox(
                                          //                 height:
                                          //                     getProportionateScreenHeight(
                                          //                         5)),
                                          //             AppText(
                                          //               text:
                                          //                   "${cubit.ReportList[index].description}",
                                          //               color: cubit
                                          //                           .ReportList[
                                          //                               index]
                                          //                           .isMocking ==
                                          //                       false
                                          //                   ? Colors.black
                                          //                   : Colors.red,
                                          //             ),
                                          //             SizedBox(
                                          //                 height:
                                          //                     getProportionateScreenHeight(
                                          //                         5)),
                                          //             AppText(
                                          //                 text:
                                          //                     "${cubit.ReportList[index].date}",
                                          //                 fontWeight:
                                          //                     FontWeight.bold,
                                          //                 color: cubit
                                          //                             .ReportList[
                                          //                                 index]
                                          //                             .isMocking ==
                                          //                         false
                                          //                     ? Colors.black
                                          //                     : Colors.red),
                                          //             SizedBox(
                                          //                 height:
                                          //                     getProportionateScreenHeight(
                                          //                         5)),
                                          //             AppText(
                                          //                 text:
                                          //                     "${cubit.ReportList[index].time}",
                                          //                 color: cubit
                                          //                             .ReportList[
                                          //                                 index]
                                          //                             .isMocking ==
                                          //                         false
                                          //                     ? Colors.black
                                          //                     : Colors.red),
                                          //             SizedBox(
                                          //                 height:
                                          //                     getProportionateScreenHeight(
                                          //                         5)),
                                          //             InkWell(
                                          //               onTap: () {
                                          //                 LatLng _postion = LatLng(
                                          //                     cubit
                                          //                         .ReportList[
                                          //                             index]
                                          //                         .lat!,
                                          //                     cubit
                                          //                         .ReportList[
                                          //                             index]
                                          //                         .lon!);
                                          //                 navigateTo(
                                          //                     context,
                                          //                     MapScreen(
                                          //                         "${cubit.ReportList[index].userName}",
                                          //                         _postion,
                                          //                         "${cubit.ReportList[index].time}"));
                                          //               },
                                          //               child: AppText(
                                          //                   color: Colors.blue,
                                          //                   textDecoration:
                                          //                       TextDecoration
                                          //                           .underline,
                                          //                   text:
                                          //                       "View on Map"),
                                          //             ),
                                          //           ],
                                          //         ),
                                          //       ],
                                          //     ),
                                          //   ),
                                          // ),
                                          Container(
                                            height: MediaQuery.of(context).size.height*0.15,
                                            width: MediaQuery.of(context).size.width*0.7,
                                            child: Card(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                                              
                                              elevation: 10,
                                              child:
                                                  Row(
                                                   children: [
                                                     Container(
                                                         //clipBehavior: Clip.antiAlias,
                                                         width: 100,
                                                         height: MediaQuery.of(context).size.height*0.14,
                                                         decoration: BoxDecoration(
                                                           
                                                           borderRadius: BorderRadius.circular(35),
                                                           image: DecorationImage(
                                                             fit: BoxFit.cover,
                                                               image: cubit
                                                                   .ReportList[
                                                               index]
                                                                   .image !=
                                                                   ConstantsManger
                                                                       .DEFULT
                                                                   ? NetworkImage(
                                                                   "${cubit.ReportList[index].image}")
                                                                   : AssetImage(
                                                                   "assets/images/att.jpg")
                                                               as ImageProvider)


                                                         ),),
                                                     Padding(
                                                       padding: const EdgeInsets.all(10.0),
                                                       child: Column(

                                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                         crossAxisAlignment: CrossAxisAlignment.start,
                                                         children: [
                                                           Text("${cubit.ReportList[index].userName}",style: TextStyle(
                                                             fontSize: 20,
                                                           ),),
                                                           Text("${cubit.ReportList[index].date}",style: TextStyle(
                                                             fontSize: 12,
                                                           ),),

                                                           Text("${cubit.ReportList[index].time}",style: TextStyle(
                                                             fontSize: 12,
                                                           ),)
                                                   ],
                                                  ),
                                                     )

                                                ],
                                              ),

                                            ),
                                             ),

                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      10)),
                                      itemCount: cubit.ReportList.length),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  LatLng initalPostion = LatLng(
                                      cubit.ReportList.first.lat!,
                                      cubit.ReportList.first.lon!);
                                  navigateTo(
                                      context,
                                      AnimatedMapScreen(
                                          cubit.totalList, initalPostion));
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: SizeConfigManger.bodyHeight * .1,
                                  decoration: BoxDecoration(
                                      color: ColorsManger.darkPrimary,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30))),
                                  child:Center(
                                    child: Column(
                                      children: [
                                        AppText(
                                            textSize: 28,
                                            color: Colors.white,
                                            text: "مجموع الزيارات : ${cubit.totalVistes}"),
                                        SizedBox(
                                          height: getProportionateScreenHeight(10),
                                        ),
                                        AppText(
                                            textSize: 28,
                                            color: Colors.white,
                                            text: " مجموع نقاط التتبع : ${cubit.ReportListShown.length}"),
                                      ],
                                    ),
                                  ) /*Center(
                                    child: AppText(
                                        textSize: 30,
                                        color: Colors.white,
                                        text: "Total Visits : ${cubit.totalVistes}"),
                                  )*/,
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildTotal(List<LocationModel> list, UserReportCubit cubit) {
    if (list.isEmpty) {
      return Center(
        child: AppText(text: 'No Data', fontWeight: FontWeight.bold, textSize: 25),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: SizeConfigManger.bodyHeight * .2),
        child: InkWell(
          onTap: () {
            LatLng initalPostion = LatLng(list.first.lat!, list.first.lon!);
            navigateTo(context, AnimatedMapScreen(cubit.totalList, initalPostion));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenHeight(20)),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  vertical: getProportionateScreenHeight(20)),
              decoration: BoxDecoration(
                  color: ColorsManger.darkPrimary,
                  borderRadius: BorderRadius.circular(getProportionateScreenHeight(10))),
              child: Center(
                child: Column(
                  children: [
                    AppText(
                        textSize: 28,
                        color: Colors.white,
                        text: "مجموع الزيارات : ${cubit.totalVistes}"),
                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    AppText(
                        textSize: 28,
                        color: Colors.white,
                        text: " مجموع نقاط التتبع : ${cubit.ReportListShown.length}"),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
