import 'dart:collection';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

import '../../../../model/location_model.dart';

part 'animated_map_state.dart';

class AnimatedMapCubit extends Cubit<AnimatedMapState> {
  AnimatedMapCubit() : super(AnimatedMapInitial());

  static AnimatedMapCubit get(context) => BlocProvider.of(context);

  var markers = HashSet<Marker>();

  void addMarker(
      {required List<LocationModel> locationList,
      required GoogleMapController controller}) async {
    print(locationList.length);
    markers.clear();

    for (int i = 0; i < locationList.length; i++) {
      LatLng latLng = LatLng(locationList[i].lat ?? 0.0, locationList[i].lon ?? 0.0);
      markers.add(Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(
              setupIcon(locationList[i].description ?? "")),
          infoWindow: InfoWindow(
              title: "${locationList[i].time} / ${locationList[i].userName}",
              snippet: "${i + 1} => ${locationList[i].description}"),
          position: LatLng(latLng.latitude, latLng.longitude),
          markerId: MarkerId("${locationList[i].lat}")));
    }
    emit(AddMarkers());
  }

  double setupIcon(String desc) {
    if (desc == "attend") {
      return BitmapDescriptor.hueGreen;
    } else if (desc == "last") {
      return BitmapDescriptor.hueRed;
    } else if (desc == "Check Point") {
      return BitmapDescriptor.hueYellow;
    } else {
      return BitmapDescriptor.hueBlue;
    }
  }
}
