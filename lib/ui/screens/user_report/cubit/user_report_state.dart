part of 'user_report_cubit.dart';

@immutable
abstract class UserReportState {}

class UserReportInitial extends UserReportState {}

class GetUserReportLoading extends UserReportState {}
class GetUserReportSuccess extends UserReportState {}
class GetUserReportError extends UserReportState {}
