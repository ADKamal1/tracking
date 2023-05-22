import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreenDistance extends StatefulWidget {
  LatLng myPos;
  LatLng customerPos;

  MapScreenDistance({required this.customerPos,required this.myPos });

  @override
  State<MapScreenDistance> createState() => _MapScreenDistanceState();
}

class _MapScreenDistanceState extends State<MapScreenDistance> {
  Polyline? polyine;
  List<LatLng> points = [];

  @override
  void initState() {
    super.initState();
    points.add(widget.customerPos);
    points.add(widget.myPos);
    polyine = Polyline(polylineId: PolylineId("value"), points: points, width: 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: GoogleMap(
              myLocationEnabled: true,
              mapType: MapType.normal,
              polylines: {polyine!},
              circles: {
                Circle(
                  circleId: CircleId("id"),
                  strokeWidth: 2,
                  fillColor: Colors.blue.withOpacity(0.7),
                  strokeColor: Colors.lightBlueAccent,
                  center: LatLng(widget.customerPos.latitude, widget.customerPos.longitude),
                  radius: 70,
                )
              },
              markers: {
                Marker(
                    markerId: MarkerId(""),
                    position: widget.customerPos,
                    infoWindow: InfoWindow(snippet: "Me", title: "Me")),
              },
              initialCameraPosition: CameraPosition(
                target: widget.myPos,
                zoom: 14.47,
              )),
        ),
      ),
    );
  }
}
