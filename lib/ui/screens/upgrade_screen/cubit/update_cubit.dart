import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'update_state.dart';

class UpdateCubit extends Cubit<UpdateState> {
  UpdateCubit() : super(UpdateInitial());

  static UpdateCubit get(context) => BlocProvider.of(context);

  String? link;

  void getLink() {
    emit(GetLinkLoading());
    FirebaseFirestore.instance
        .collection("admin")
        .doc("admin")
        .get()
        .then((value) {
      link = value.data()!['link'];
      print(link);
      emit(GetLinkSuccess());
    }).catchError((error) {});
  }
}
