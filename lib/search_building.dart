import 'package:flutter/material.dart';

List<int> min = [101,21,101,011,511,1,721,110,900,101,1101,1211,1311,1];//教室番号の最小値
List<int> max = [192,49,502,214,534,4,762,422,900,405,1109,1233,1341,3];//教室番号の最大値
List<String> name = ["1号館","情報教育棟","21KOMCEE West","21KOMCEE East","5号館",
  "コミニケーションプラザ(北)","7号館","8号館","講堂","10号館","11号館","12号館","13号館"];
String e = "正しい教室番号を入力してください";

String search(cn){
  if(cn.length<4){
    if(cn[0] == 'E'){
      try{//文字列から数値への変換を試す
        int i = int.parse(cn.substring(1));
        if(min[1]<= i && i <= max[1])return "情報教育棟";
        else return e;
      }catch(exception){//変換不可能な場合例外としてここに入る
        return e;
      }
    }
    else if(cn == "実験室")return name[3];
    else if(cn == "剣道場")return "第一体育館";
    try {
      int i = int.parse(cn[0]);
      if(i == 2 || i == 3 || i == 4 || i == 6 || i == 8 || i == 0)return e;
      else{
        try{
          int j = int.parse(cn);
          if(min[i-1] <= j && j <= max[i-1])return name[i-1];
          else return e;
        }catch(exception){
          return e;
        }
      }
    }catch(exception){
      return e;
    }
  }
  else if(cn == "KALS")return "17号館";
  else if(cn[0] == "K"){
    try {
      int n = int.parse(cn.substring(2, 3));
      if (n == 0)
        return name[2];
      else if (n == 1) return name[3];
      else return e;
    }catch(exception){
      return e;
    }
  }
  else if(cn.substring(0,3) == "実験室")return name[3];
  else if(cn.length > 4){
    if(cn == "18号館ホール")return "18号館";
    else if(cn.substring(2,5) == "実験室")return name[3];
    else if(cn.substring(0,2) == '8-') {
      try {
        int i = int.parse(cn.substring(2));
        if(min[7] <= i && i <= max[7])return name[7];
        else return e;
      }catch(exception) {
        return e;
      }
    }
    try{
      int n = int.parse(cn.substring(0,2));
      if(n == 10){
        int i = int.parse(cn.substring(3));
        if(min[n-1] <= i && i <= max[n-1])return name[n-1];
        else return e;
      }
      else return e;
    }catch(exception){
      if(cn == "音楽練習室" || cn == "舞台芸術実習室") return name[5];
      else if(cn.substring(0,5) == "多目的教室") {
        try {
          int i = int.parse(cn.substring(5));
          if (min[5] <= i && i <= max[5])
            return name[5];
          else
            return e;
        } catch (exception) {
          return e;
        }
      }
      else if(cn.substring(0,7) == "身体運動実習室"){
        try{
          int i = int.parse(cn.substring(7));
          if(min[13] <= i && i <= max[13])return name[5];
          else return e;
        }catch(exception){
          return e;
        }
      }
      else if(cn == "学際交流ホール")return "アドミニストレーション棟";
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
            return name[d - 1];
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