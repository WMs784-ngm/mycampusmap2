import 'package:flutter/material.dart';

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
String dfl = "教室番号を入力してください";
String cn = ec;
int e = 100,d = 1000;
double ori_lat = 35.6587374, ori_long = 139.6840927;//デフォルトのカメラ位置として使用する駒場東大前駅

int search(cn){
  if(cn == null) return d;
  else if(cn.length == 0)return d;
  if(cn == null) return e;//cn=class number
  else if(cn.length<4){
    if(cn[0] == 'E'){
      try{//文字列から数値への変換を試す
        int i = int.parse(cn.substring(1));
        if(min[1]<= i && i <= max[1])return 1;//教室番号の最大値と最小値の間ならあるという判定(もちろん不正確)
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