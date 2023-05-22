import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../model/location_model.dart';
import 'cubit/animated_map_cubit.dart';

class AnimatedMapScreen extends StatefulWidget {
  List<LocationModel> locationList;
  LatLng initialPostion;

  AnimatedMapScreen(this.locationList, this.initialPostion);

  @override
  State<AnimatedMapScreen> createState() => _AnimatedMapScreenState();
}

class _AnimatedMapScreenState extends State<AnimatedMapScreen> {
  Polyline? polyine;
  List<LatLng> points = [];

  @override
  void initState() {
    super.initState();

    print(widget.locationList.length);
    for (int i = 0; i < widget.locationList.length; i++) {
      LatLng latLng = LatLng(widget.locationList[i].lat ?? 0.0, widget.locationList[i].lon ?? 0.0);
      points.add(latLng);
    }

    polyine =
        Polyline(polylineId: PolylineId("value"), points: points, width: 3);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnimatedMapCubit(),
      child: BlocConsumer<AnimatedMapCubit, AnimatedMapState>(
        listener: (context, state) {
          if (state is AddMarkers) {}
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              await Future.delayed(Duration(milliseconds: 800));
              Navigator.of(context).pop();
              return Future.value(false);
            },
            child: Scaffold(
                body: GoogleMap(
                    mapType: MapType.terrain,
                    polylines: {polyine!},
                    onMapCreated: (controller) async {
                      AnimatedMapCubit.get(context).addMarker(
                          locationList: widget.locationList,
                          controller: controller);
                    },
                    markers: AnimatedMapCubit.get(context).markers,
                    initialCameraPosition: CameraPosition(
                        target: widget.initialPostion, zoom: 14))),
          );
        },
      ),
    );
  }
}
