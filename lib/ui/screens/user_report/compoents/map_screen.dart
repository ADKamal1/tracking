import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  String name;
  String time;
  LatLng _initialPosition;

  MapScreen(this.name, this._initialPosition  , this.time);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        await Future.delayed(Duration(milliseconds: 800));
        Navigator.of(context).pop();
        return Future.value(false);
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: GoogleMap(
                myLocationEnabled: true,
                mapType: MapType.normal,
                onMapCreated: (GoogleMapController controller) async {
                  await controller.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(target: _initialPosition, zoom: 13.47)));
                },
                markers: {
                  Marker(markerId: MarkerId(name), position: _initialPosition,infoWindow: InfoWindow(title: name,snippet: time)),
                },
                initialCameraPosition: CameraPosition(
                  target: _initialPosition,
                  zoom: 13.47,
                )),
          ),
        ),
      ),
    );
  }
}
