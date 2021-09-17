import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:appbar_textfield/appbar_textfield.dart';

//import 'search_building.dart';

void main() => runApp(MyApp());
//var lat = new List.generate(18, (i)=>35.6598812);//駒場図書館
//var long = new List.generate(18,(i)=>139.6865876);
List<double> lat = [35.6598397,35.6593117,35.6607411,35.6605338,35.6610601,35.6599659,
  35.6607347,35.6605018,35.659832,35.6606455,35.6603639,35.660281,35.6605001,35.6591107,
  35.6605044,35.6598812,35.6611821,35.6611838];
List<double> long = [139.6848356,139.6836729, 139.6860089,139.6863858,139.6844503,139.6873125,
  139.6845799,139.6854947,139.6838042,139.6849458,139.684239,139.683548,139.6837391,139.6853381,
  139.6877397,139.6865876,139.6836969,139.6851203];
List<int> min = [101,21,101,011,511,1,721,110,900,101,1101,1211,1311,1];//教室番号の最小値
List<int> max = [192,49,502,214,534,4,762,422,900,405,1109,1233,1341,3];//教室番号の最大値
List<String> name = ["1号館","情報教育棟","21KOMCEE West","21KOMCEE East","5号館",
  "コミニケーションプラザ(北)","7号館","8号館","講堂","10号館","11号館","12号館","13号館",
  "アドミニストレーション棟","第一体育館","駒場図書館","17号館","18号館"];
String ec = "正しい教室番号を入力してください";
String cn = ec;
int e = 100;
double ori_lat = 35.6587374, ori_long = 139.6840927;

int search(cn){
  if(cn.length<4){
    if(cn[0] == 'E'){
      try{//文字列から数値への変換を試す
        int i = int.parse(cn.substring(1));
        if(min[1]<= i && i <= max[1])return 1;
        else return e;
      }catch(exception){//変換不可能な場合例外としてここに入る
        return e;
      }
    }
    else if(cn == "実験室")return 3;
    else if(cn == "剣道場")return 14;
    try {
      int i = int.parse(cn[0]);
      if(i == 2 || i == 3 || i == 4 || i == 6 || i == 8 || i == 0)return e;
      else{
        try{
          int j = int.parse(cn);
          if(min[i-1] <= j && j <= max[i-1])return i-1;
          else return e;
        }catch(exception){
          return e;
        }
      }
    }catch(exception){
      return e;
    }
  }
  else if(cn == "KALS")return 16;
  else if(cn[0] == "K"){
    try {
      int n = int.parse(cn.substring(2, 3));
      if (n == 0)
        return 2;
      else if (n == 1) return 3;
      else return e;
    }catch(exception){
      return e;
    }
  }
  else if(cn.substring(0,3) == "実験室")return 3;
  else if(cn.length > 4){
    if(cn == "18号館ホール")return 17;
    else if(cn.substring(2,5) == "実験室")return 3;
    else if(cn.substring(0,2) == '8-') {
      try {
        int i = int.parse(cn.substring(2));
        if(min[7] <= i && i <= max[7])return 7;
        else return e;
      }catch(exception) {
        return e;
      }
    }
    try{
      int n = int.parse(cn.substring(0,2));
      if(n == 10){
        int i = int.parse(cn.substring(3));
        if(min[n-1] <= i && i <= max[n-1])return n-1;
        else return e;
      }
      else return e;
    }catch(exception){
      if(cn == "音楽練習室" || cn == "舞台芸術実習室") return 5;
      else if(cn.substring(0,5) == "多目的教室") {
        try {
          int i = int.parse(cn.substring(5));
          if (min[5] <= i && i <= max[5])
            return 5;
          else
            return e;
        } catch (exception) {
          return e;
        }
      }
      else if(cn.substring(0,7) == "身体運動実習室"){
        try{
          int i = int.parse(cn.substring(7));
          if(min[13] <= i && i <= max[13])return 5;
          else return e;
        }catch(exception){
          return e;
        }
      }
      else if(cn == "学際交流ホール")return 13;
      else return e;
    }
  }
  else{
    try {
      int d = int.parse(cn.substring(0, 2));
      if (9 < d && d < 14) {
        try {
          int i = int.parse(cn);
          if (min[d - 1] <= i && i <= max[d - 1])
            return d - 1;
          else
            return e;
        } catch (exception) {
          return e;
        }
      }
      else return e;
    } catch (exception) {
      return e;
    }
  }
}
double dest_lat(text){
  if(search(text) >= lat.length)return ori_lat;
  else return lat[search(text)];
}
double dest_long(text){
  if(search(text) >= long.length)return ori_long;
  else return long[search(text)];
}
String mark_name(text){
  if(search(text) >= long.length)return ec;
  else return name[search(text)];
}

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
        /*appBar:AppBarTextField(
            title:Text("教室番号"),
            onChanged:(text){
              cn = text;
              //createState();
              _MapScreenState();
            }
      ),*/
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
  String googleAPiKey = "AIzaSyDSEFIrVbRPeaFm2W_585Sn07nTWqciPho";

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
            //main();
            //_MapScreenState();
            _addMarker(LatLng(dest_lat(cn), dest_long(cn)), "destination", BitmapDescriptor.defaultMarkerWithHue(90));
            //_getPolyline();
            //MapScreen();
            main();
            //runApp(MyApp());
            //_getPolyline();
          }
        ),
          body: GoogleMap(
            initialCameraPosition: CameraPosition(
                target: LatLng(_originLatitude, _originLongitude), zoom: 17),
            myLocationEnabled: true,
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
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
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