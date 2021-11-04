import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:appbar_textfield/appbar_textfield.dart';
import 'package:styled_text/styled_text.dart';
import 'dart:math';

import 'search_building.dart';
import 'apikey.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
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
  double _originLatitude = ori_lat, _originLongitude = ori_long;//駒場東大前駅
  double _destLatitude = dest_lat(cn), _destLongitude = dest_long(cn);
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = api_key;
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
            title:Text(guide),
            onChanged:(text){
              cn = text;
              _addMarker(LatLng(dest_lat(cn), dest_long(cn)), "destination", BitmapDescriptor.defaultMarkerWithHue(90));
              if(search(cn) >= 100){
                mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(dest_lat(cn),dest_long(cn)),
                      zoom:17.5,
                    ),
                  ),
                );
              }
              else {
                mapController.animateCamera(
                    CameraUpdate.newLatLngBounds(
                        LatLngBounds(
                          southwest: LatLng(ori_lat, min(ori_long,_destLongitude)),
                          northeast: LatLng(dest_lat(cn), max(ori_long,_destLongitude)),
                        ),
                        100.0
                    )
                );
              }
                polylines = {};
                polylineCoordinates = [];
                main();
                _getPolyline();
            }
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: StyledText(
                  text: '<set/>&space;'+setting,
                  style: TextStyle(
                    fontSize: 24
                  ),
                  tags: {
                    'set': StyledTextIconTag(
                      Icons.settings,
                      size: 30,
                    ),
                  },
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              ListTile(
                title: Text("日本語"),
                onTap: (){
                  guide = "教室番号";
                  ec = "正しい教室番号を入力してください";
                  setting = "言語設定";
                  Navigator.pop(context);
                  main();
                },
              ),
              ListTile(
                title: Text("English"),
                onTap: (){
                  guide = "classroom number";
                  ec = "Enter the correct classroom number.";
                  setting = "language setting";
                  Navigator.pop(context);
                  main();
                },
              ),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(dest_lat(cn),dest_long(cn)), zoom: 17.5),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              tiltGesturesEnabled: true,
              compassEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              onMapCreated: _onMapCreated,
              markers: Set<Marker>.of(markers.values),
              polylines: Set<Polyline>.of(polylines.values),
            ),
            Container(
                color: Colors.white,
                //width: double.infinity,
                height: 40,
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(5.0),
                alignment: Alignment.topCenter,
                child:Text(mark_name(cn),
                    style: TextStyle(
                        fontSize:20
                    )
                )
            )
          ],
        ),
      ),
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