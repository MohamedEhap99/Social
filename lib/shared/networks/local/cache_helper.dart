import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper{
  static SharedPreferences?preferences;
  static  init()async{
    preferences=await SharedPreferences.getInstance();
  }

  static Future<bool> saveData({
  required String key,
  required dynamic value,
})async{
    if(value is int)return await preferences!.setInt(key, value);
     if(value is String)return await preferences!.setString(key, value);
    if(value is bool)return await preferences!.setBool(key, value);
    return await preferences!.setDouble(key, value);
  }

  static dynamic getData({
    required String key,
  }){
    return preferences!.get(key);
  }


}
