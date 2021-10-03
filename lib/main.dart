import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:appbar_textfield/appbar_textfield.dart';
import 'package:slim/slim.dart';

import 'search_building.dart';
import 'apikey.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Komaba map',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home:Scaffold(
          body:MapScreen(),
        )
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  //double _originLatitude = 35.8430015, _originLongitude = 139.4497358;家
  double _originLatitude = 35.6587374, _originLongitude = 139.6840927;//駒場東大前駅
  //double _destLatitude = dest_lat(cn), _destLongitude = dest_long(cn);
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
//目的地の緯度経度

  @override
  void initState() {
    super.initState();

    /// origin marker
    _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
        BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(dest_lat(cn), dest_long(cn)), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar:AppBarTextField(
              title:Text("教室番号"),
              onChanged:(text){
                cn = text;
                _addMarker(LatLng(dest_lat(cn), dest_long(cn)), "destination", BitmapDescriptor.defaultMarkerWithHue(90));
                //_getPolyline();
                //MapScreen();
                mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: LatLng(dest_lat(cn), dest_long(cn)), zoom: 17.0),
                  ),
                );
                //_getPolyline.setMap(null);

                polylines = {};
                polylineCoordinates = [];
                main();
                _getPolyline();
              }
          ),
          body: GoogleMap(
            initialCameraPosition: CameraPosition(
                target: LatLng(dest_lat(cn),dest_long(cn)), zoom: 17),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: _onMapCreated,
            markers: Set<Marker>.of(markers.values),
            polylines: Set<Polyline>.of(polylines.values),
          )),
    );
  }
  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(
        markerId: markerId, icon: descriptor, position: position,infoWindow: InfoWindow(title: mark_name(cn))
    );
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    //clearOverlay;
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(_originLatitude, _originLongitude),
      PointLatLng(dest_lat(cn), dest_long(cn)),
      travelMode: TravelMode.walking,
      //wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
}