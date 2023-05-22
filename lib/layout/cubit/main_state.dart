part of 'main_cubit.dart';

@immutable
abstract class MainState {}

class MainInitial extends MainState {}
class ChangeBottomNavigationIndex extends MainState {}
class SetUpPerrmisions extends MainState {}
class ChooseUserimageSuccess extends MainState {}

class AddNewCustomerLoading extends MainState {}
class AddNewCustomerSuccess extends MainState {}
class UpdatePageState extends MainState {}
class PhoneAlreadyHere extends MainState {}
class ChooseCustomerImageState extends MainState {}
class ShowCatchError extends MainState {
  String error;

  ShowCatchError(this.error);
}
class ShowNetWORKError extends MainState {
  String error;

  ShowNetWORKError(this.error);
}


class GetAttendaceModelLoading extends MainState{}
class LoadingState extends MainState{}
class GetAttendaceModelSuccess extends MainState{}


class GetCustomersdLoading extends MainState{}
class GetCustomersdSuccess extends MainState{}

class ErrorGPS extends MainState{}
class PerrmisionError extends MainState{}
class ChangeVisitState extends MainState{}


class GetTodayWorkLoading extends MainState{}
class GetTodayWorkSuccess extends MainState{}


class GetSeachScreen extends MainState{}
class ChangeVisitOrState extends MainState{}
class SeachListState extends MainState{}

class GetUserDataLoading extends MainState{}
class GetUserDataSuccess extends MainState{}
class GetUserDataError extends MainState{}


class SignOutUser extends MainState{}
class UpdateUserImage extends MainState{}


// Location Screen
class updateNotificationTextState extends MainState{}
class ChangeIsRunningState extends MainState{}
class ClearLogState extends MainState{}
