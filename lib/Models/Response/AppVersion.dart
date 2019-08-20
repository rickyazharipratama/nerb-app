class AppVersion{

  int minVersion;
  int currVersion;
  List<AppDescVersion> descs;

  AppVersion.fromJson(Map<String,dynamic> data){
    minVersion = data['minVersion'];
    currVersion = data['currVersion'];
    descs = List();
    if(data['desc'] != null){
      (data['desc'] as List<dynamic>).forEach((ds){
        descs.add(AppDescVersion.fromJson(ds as Map<String,dynamic>));
      });
    }
  }
}

class AppDescVersion{
  String desc;

  AppDescVersion.fromJson(Map<String,dynamic> data){
    desc = data['desc'];
  }
}