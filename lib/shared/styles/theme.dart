import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/shared/styles/colors.dart';

ThemeData lightTheme=ThemeData(
  primarySwatch: defaultColor, //اللون الاساسي للابلكيشن
  scaffoldBackgroundColor:Colors.white,
  appBarTheme:AppBarTheme(
    backwardsCompatibility:false,//بلغي خاصية عدم الاتاحة في تعديل status appBar عشان اعرف اعدل فيها برحتي
    systemOverlayStyle:SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
    titleSpacing: 20.0,
    backgroundColor:Colors.white,
    elevation: 0.0,
    titleTextStyle:TextStyle(
        fontFamily:'Signatra',
        fontSize:30.0,
        fontWeight:FontWeight.bold,
        color:Colors.indigo
    ),
    iconTheme:IconThemeData(
      color:Colors.black,
    ),
  ),
  bottomNavigationBarTheme:BottomNavigationBarThemeData(
    type:BottomNavigationBarType.fixed,
    selectedItemColor:defaultColor,
    unselectedItemColor:Colors.grey,
    elevation:20.0,
    backgroundColor:Colors.teal,
  ),
  textTheme:TextTheme(
    bodyText1:TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    subtitle1:TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
      height: 1.3,
    ),
  ),

);

ThemeData darkTheme=ThemeData(
  primarySwatch:defaultColor,
  scaffoldBackgroundColor:HexColor('333739'),
  appBarTheme:AppBarTheme(
    backwardsCompatibility:false,
    systemOverlayStyle:SystemUiOverlayStyle(
      statusBarColor:HexColor('333739'),
      statusBarIconBrightness:Brightness.light,
    ),
    titleSpacing:20.0,
    backgroundColor:Colors.black,
    elevation:0.0,
    titleTextStyle:TextStyle(
      fontFamily:'Signatra',
      fontSize:30.0,
      fontWeight:FontWeight.bold,
      color:Colors.white,

    ),
    iconTheme:IconThemeData(
      color:Colors.white,
    ),
  ),
  bottomNavigationBarTheme:BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: defaultColor,
    unselectedItemColor: Colors.grey,
    elevation: 20.0,
    backgroundColor:Colors.black,
  ),
  textTheme:TextTheme(
    bodyText1:TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    subtitle1:TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      height: 1.3,
    ),
    caption:TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      height: 1.3,
    ),
  ),

);