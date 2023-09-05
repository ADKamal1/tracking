
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timeline_calendar/timeline/model/calendar_options.dart';
import 'package:flutter_timeline_calendar/timeline/model/day_options.dart';
import 'package:flutter_timeline_calendar/timeline/model/headers_options.dart';
import 'package:flutter_timeline_calendar/timeline/utils/calendar_types.dart';
import 'package:flutter_timeline_calendar/timeline/widget/timeline_calendar.dart';
import 'package:hook_atos/animation/faidAnimation.dart';
import 'package:hook_atos/layout/cubit/main_cubit.dart';
import 'package:hook_atos/model/Visit.dart';
import 'package:hook_atos/model/customers_model.dart';
import 'package:hook_atos/ui/screens/add_user_visit/add_user_visit.dart';
import 'package:intl/intl.dart';
import 'package:tap_to_expand/tap_to_expand.dart';
class MyLine extends StatefulWidget {
  @override
  _MyLineState createState() => _MyLineState();
}

class _MyLineState extends State<MyLine> {
  int _currentStep = 0;
  DateTime selectedDate = DateTime.now();


  @override

  List<CustomerModel> myvisitsOfTheDayList = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => MainCubit(),
        child: BlocConsumer<MainCubit, MainState>(
          listener: (context, state) {

          },
          builder: (context, state) {
            MainCubit cubit = MainCubit.get(context);
            return Scaffold(

              body: Column(
                children: [
                  TimelineCalendar(

                    calendarType: CalendarType.GREGORIAN,
                    calendarLanguage: "en",

                    calendarOptions: CalendarOptions(
                      viewType: ViewType.DAILY,
                      toggleViewType: true,
                      headerMonthElevation: 10,

                      headerMonthShadowColor: Colors.black26,
                      headerMonthBackColor: Colors.transparent,
                    ),
                    dayOptions: DayOptions(

                        compactMode: true,
                        showWeekDay:true,
                        selectedBackgroundColor:const Color(0xffC1301A) ,
                        weekDaySelectedColor: const Color(0xffC1301A),
                        disableDaysBeforeNow: false,differentStyleForToday: true,todayTextColor:const Color(0xffC1301A), ),
                    headerOptions: HeaderOptions(

                        weekDayStringType: WeekDayStringTypes.SHORT,
                        monthStringType: MonthStringTypes.FULL,
                        backgroundColor: const Color(0xffC1301A),
                        headerTextColor: Colors.black),


                    onChangeDateTime: (datetime) {

                      cubit.visitsOfTheDay(DateTime.parse(datetime.toString()));


                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height/80,),

                  (cubit.visitsOfTheDayList.length == 0)?
                  Center(child: Text('NO visits in this day',),):

                    (cubit.visitsOfTheDayList.length==null)? CircularProgressIndicator():
                   Container( width: MediaQuery.of(context).size.width,
                     height: MediaQuery.of(context).size.height*0.6,
                     child: ListView.builder(
                        itemCount: cubit.visitsOfTheDayList.length,
                        itemBuilder: (context, index) {
                          return
                           InkWell(
                                onTap: () async {
                                  if (cubit.visitsOfTheDayList[index].status ==
                                      false) {
                                    cubit.getCustomerByName(cubit.visitsOfTheDayList[index].name!);
                                    if(cubit.customer.isNotEmpty)
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddUserVisitScreen(
                                                  cubit.customer[0],
                                                  cubit.visitsOfTheDayList[index]
                                                      .status!,
                                                  cubit.visitsOfTheDayList[index]
                                                      .note
                                                      .toString(),
                                                  true,cubit.visitsOfTheDayList[index].visitId!

                                                )));
                                    //
                                  }
                                },
                                child: CardWidget(
                                  title: cubit.visitsOfTheDayList[index].name!,
                                  time: cubit.visitsOfTheDayList[index].note!,

                                  states: cubit.visitsOfTheDayList[index].status!,
                                  VisitModel: cubit.visitsOfTheDayList[index],
                                  currentIndex: _currentStep,
                                  cardIndex: index,
                                ),
                          );
                        },
                      ),
                   ),

                ],
              ),
            );
          },
        ));
  }
}

class CardWidget extends StatelessWidget {
  final String title;
  final String time;
  final int currentIndex;
  final int cardIndex;
  final bool states;
  final Visit VisitModel;

  const CardWidget({
    required this.title,
    required this.time,
    required this.states,
    required this.VisitModel,
    required this.currentIndex,
    required this.cardIndex,
  });

  @override
  Widget build(BuildContext context) {
    int index = cardIndex + 1;

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                height: 48,
                width: 8,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: (states) ? Colors.green : Colors.red, width: 2),
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(8), bottom: Radius.circular(8))),
              ),
              Container(
                width: 36,
                height: 24,
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: (states) ? Colors.green : Colors.red, width: 2)),
                child: Center(
                  child: Text(
                    '$index',
                    style: TextStyle(
                      color: (states) ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                height: 48,
                width: 8,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: (states) ? Colors.green : Colors.red, width: 2),
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(8), bottom: Radius.circular(8))),
              ),
            ],
          ),
          (states)
              ? Expanded(

                child: TapToExpand(
                    borderRadius: 35,
                    closedHeight: MediaQuery.of(context).size.height*0.16,
                    color: Colors.white,
                    title: Container(
                      width: 150,
                      child: Column(children: [
                        Text(
                          "" + title,
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(time,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey),
                          ),

                        ),
                      Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(VisitModel.dateOfVisit.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey),
                          ),),
                      ]),
                    ),
                    content: Container(
                      width: 140,

                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Phone : " + VisitModel.phone.toString(),
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Adress : " +
                                VisitModel.address.toString().substring(0, 50),
                            overflow:TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w300),
                          ),
                          Text(
                            "Line : " + VisitModel.line.toString(),
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Class : " + VisitModel.classy.toString(),
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "specilty : " + VisitModel.specialty.toString(),
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
              )
              : Container(
                  width: 210,
                  height: 120,
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  child: Card(
                    elevation: 15,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                              child: Text(
                            title,
                            style: TextStyle(color: Colors.black, fontSize: 24),
                          )),
                          Center(
                              child: Text(
                          time,overflow: TextOverflow.ellipsis,

                                maxLines: 1,
                            style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                          )),
                        ],
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
