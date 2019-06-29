import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper{

  SharedPreferences _pref;

  PreferenceHelper(){
  }

  static PreferenceHelper instance = PreferenceHelper();
  

  setStringValue({String key, String value}) async{
     _pref =  await SharedPreferences.getInstance();
     await _pref.setString(key, value);
  }
  
  setStringListValue({String key, List<String> value}) async{
     _pref =  await SharedPreferences.getInstance();
     await _pref.setStringList(key, value);
  }

  
  Future<String> getStringValue({String key}) async{
    _pref =  await SharedPreferences.getInstance();
     return _pref.getString(key);
  }

  Future<List<String>> getStringListValue({String key}) async{
      _pref =  await SharedPreferences.getInstance();
     if(_pref.getStringList(key) != null){
       return _pref.getStringList(key);
     }
     return List();
  }
}