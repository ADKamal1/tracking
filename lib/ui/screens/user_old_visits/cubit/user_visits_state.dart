part of 'user_visits_cubit.dart';

@immutable
abstract class UserVisitsState {}

class UserVisitsInitial extends UserVisitsState {}
class ChangeVisitOrOState extends UserVisitsState {}
class GetOldVisitsLoading extends UserVisitsState {}
class GetOldVisitsSuccess extends UserVisitsState {}
class SetUpPermsion extends UserVisitsState {}
class TryCatchState extends UserVisitsState {
  String error;

  TryCatchState(this.error);
}


class AddVistingSuccess extends UserVisitsState {}
class AddVistingLoading extends UserVisitsState {}
class UpdatePageState extends UserVisitsState {}
class AddVistingError extends UserVisitsState {
  String metter;
  double lat;
  double lng;
  AddVistingError(this.metter , this.lat,this.lng);
}


class ErrorGPS extends UserVisitsState {}
class PerrmisionError extends UserVisitsState {}
