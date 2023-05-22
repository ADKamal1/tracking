import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class MapScreen extends StatelessWidget {
  String name;
  LatLng _initialPosition;
  String time;

  MapScreen(this.name, this._initialPosition ,this.time);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Marker(
                    markerId: MarkerId(name),
                    position: _initialPosition,
                    infoWindow: InfoWindow(snippet: time,title: name)),
              },
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 13.47,
              )),
        ),
      ),
    );
  }
}
