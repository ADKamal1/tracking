import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hook_atos/animation/faidAnimation.dart';
import 'package:hook_atos/layout/cubit/main_cubit.dart';
import 'package:hook_atos/model/customers_model.dart';
import 'package:hook_atos/shared/helper/methods.dart';
import 'package:hook_atos/ui/screens/add_customer_screen/add_customer_screen.dart';
import 'package:hook_atos/ui/screens/add_user_visit/add_user_visit.dart';
import 'package:tap_to_expand/tap_to_expand.dart';


class MyStepper extends StatefulWidget {
  @override
  _MyStepperState createState() => _MyStepperState();
}

class _MyStepperState extends State<MyStepper> {
  int _currentStep = 0;

  List<CustomerModel> myvisitsOfTheDayList = [];
  @override
  void initState() {

    MainCubit cubit= MainCubit.get(context);
    cubit.visitsOfTheDay();
    myvisitsOfTheDayList=cubit.visitsOfTheDayList;

    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {



    return Builder(

      builder: (context) {
        return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: myvisitsOfTheDayList.length,
                  itemBuilder: (context, index)
                  {
                    return
                      FadeAnimation(
                      index/3, GestureDetector(
                          onTap: () async {

                           if (myvisitsOfTheDayList[index].states==false){
                    Navigator.push(context,MaterialPageRoute(builder:(context)=> AddUserVisitScreen
                      (myvisitsOfTheDayList[index],myvisitsOfTheDayList[index].states!,
                      myvisitsOfTheDayList[index].note.toString(),
                        )));
                          //
                          // setState(()  {
                          //   FirebaseFirestore.instance.collection("user visits")
                          //       .doc(myvisitsOfTheDayList[index].id)
                          //       .update({ "states": true});
                          //
                          // });
                           }
                        },
                    child:CardWidget(
                        title: myvisitsOfTheDayList[index].name!,
                        time: myvisitsOfTheDayList[index].time!,
                        image: myvisitsOfTheDayList[index].image.toString(),
                        states: myvisitsOfTheDayList[index].states!,
                        customerModel: myvisitsOfTheDayList[index],
                        currentIndex: _currentStep,
                        cardIndex: index,
                    )),
                      );
                  },
                ),
              ),
            ],
        );
      }
    );
  }
}

class CardWidget extends StatelessWidget {
  final String title;
  final String time;
  final int currentIndex;
  final int cardIndex;
  final String image;
  final bool states;
  final CustomerModel customerModel;

  const CardWidget({
    required this.title,
    required this.time,
    required this.image,
    required this.states,
    required this.customerModel,

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
                        color: (states) ? Colors.green : Colors.red,
                        width: 2),
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
                        color: (states) ? Colors.green : Colors.red,
                        width: 2)),
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
                        color: (states) ? Colors.green : Colors.red,
                        width: 2),
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(8), bottom: Radius.circular(8))),
              ),
            ],
          ),
          (states)?
    TapToExpand(
    borderRadius: 35,
closedHeight: 100,

      color: Colors.white,
            title:Container(
              width: 150,
              child: Column(
                  children:[ Text(
    ""+title,
    style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
      color: Colors.black
    ),
    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "      "+time,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),
                      ),
                    ),
                  ]),
            ),
      content:
      Container(
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Phone : " +  customerModel.phone.toString(),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              "Adress : " +  customerModel.address.toString().substring(0,50),
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300),
            ),
            Text(
              "Line : " +  customerModel.line.toString(),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              "Class : " +  customerModel.classy.toString(),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              "specilty : " +  customerModel.specialty.toString(),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
        ):
              Container(
                width: 220,
                height: 80,
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: Card(


                  elevation: 15,
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Column(

                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,

                     children: [
                       Center(child: Text( title,style: TextStyle(color: Colors.black,fontSize: 24),)),

                       Center(child: Text(time,style: TextStyle(color: Colors.black,fontSize: 18),)),




                     ],
                   ),
                 ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.0),

                  ),
                ),
              )
          ,


        ],
      ),
    );
  }
}
