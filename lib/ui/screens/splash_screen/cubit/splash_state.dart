part of 'splash_cubit.dart';

@immutable
abstract class SplashState {}

class SplashInitial extends SplashState {}
class ErrorInConnection extends SplashState {}
class SplashMainLayouState extends SplashState {}
class SplashLoginState extends SplashState {}
class SplashMainButBannedState extends SplashState {}
