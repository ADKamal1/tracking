import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../model/location_model.dart';
import '../../../../shared/helper/mangers/constants.dart';
import '../../../../shared/helper/methods.dart';

part 'user_report_state.dart';

class UserReportCubit extends Cubit<UserReportState> {
  UserReportCubit() : super(UserReportInitial());

  static UserReportCubit get(context) => BlocProvider.of(context);

  List<LocationModel> ReportList = [];
  List<LocationModel> ReportListShown = [];
  List<LocationModel> totalList = [];

  late int totalVistes;

  void getUserLocation(
      {required String userId,
      required DateTime startDate,
      DateTime? endDate}) {
    emit(GetUserReportLoading());
    if (endDate == null) {
      totalVistes = 0;
      FirebaseFirestore.instance
          .collection(ConstantsManger.LOCATION)
          .where("date", isEqualTo: formatDate(date: startDate))
          .where("userId", isEqualTo: userId)
          .orderBy("time")
          .get()
          .then((value) {
        ReportList.clear();
        totalList.clear();
        ReportListShown.clear();
        totalVistes = 0;

        value.docs.forEach((element) {
          LocationModel model = LocationModel.fromJson(element.data());
          totalList.add(model);
          if (model.description != "Check Point") { //كل الزيارات مش عاوز النقط الصفرا
            ReportList.add(model);
            totalVistes++;
          } else { // النقط الصفر بس
            ReportListShown.add(model);
          }
        });
        emit(GetUserReportSuccess());
      }).catchError((error) {
        emit(GetUserReportError());
      });
    }
    else {
      totalVistes = 0;
      List<DateTime> days = [];
      for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
        days.add(startDate.add(Duration(days: i)));
      }
      ReportList.clear();
      ReportListShown.clear();
      totalList.clear();
      days.forEach((day) {
        FirebaseFirestore.instance
            .collection(ConstantsManger.LOCATION)
            .where("date", isEqualTo: formatDate(date: day))
            .where("userId", isEqualTo: userId)
            .orderBy("time")
            .get()
            .then((value) {
          value.docs.forEach((element) {
            LocationModel model = LocationModel.fromJson(element.data());
            totalList.add(model);
            if (model.description != "Check Point") {
              ReportList.add(model);
              totalVistes++;
            } else {
              ReportListShown.add(model);
            }
          });
          emit(GetUserReportSuccess());
        }).catchError((error) {
          emit(GetUserReportError());
        });
      });
    }
  }
}
