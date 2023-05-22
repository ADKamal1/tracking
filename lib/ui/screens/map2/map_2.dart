import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class Map2 extends StatefulWidget {
  LatLng myPos;
  String name;
  LatLng customerPos;


  Map2({required this.myPos,required  this.name,required this.customerPos});

  @override
  State<Map2> createState() => _Map2State();
}

class _Map2State extends State<Map2> {
  Polyline? polyine;
  List<LatLng> points = [];

  @override
  void initState() {
    super.initState();
    points.add(widget.myPos);
    points.add(widget.customerPos);
    polyine = Polyline(polylineId: PolylineId("value"), points: points, width: 3);
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: ()async{
          await Future.delayed(Duration(milliseconds: 800));
          Navigator.of(context).pop();
          return Future.value(false);
        },
        child: SafeArea(
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
                onMapCreated: (GoogleMapController controller) async {
                  await controller.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(target: widget.myPos, zoom: 13.47)));
                },
                markers: {
                  Marker(
                      markerId: MarkerId("name"),
                      position: widget.customerPos,
                      infoWindow: InfoWindow(title: widget.name)),
                },
                initialCameraPosition: CameraPosition(
                  target: widget.myPos,
                  zoom: 13.47,
                )),
          ),
        ),
      ),
    );
  }
}
