part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}
class ChangePasswordVisibiltyState extends LoginState {}

class LoginSuccessState extends LoginState {}
class LoginSuccessButBannedState extends LoginState {}
class LoginFromAnthorPhone extends LoginState {}
class LoginLoadingState extends LoginState {}
class LoginErrorState extends LoginState {
  String errorMsg;
  LoginErrorState({required this.errorMsg});
}
