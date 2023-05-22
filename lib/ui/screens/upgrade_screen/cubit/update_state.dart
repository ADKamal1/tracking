part of 'update_cubit.dart';

@immutable
abstract class UpdateState {}

class UpdateInitial extends UpdateState {}
class GetLinkLoading extends UpdateState {}
class GetLinkSuccess extends UpdateState {}
class GetLinkFailure extends UpdateState {}
