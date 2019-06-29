class Names{
  String en;
  String id;

  Names.fromJson(Map<dynamic,dynamic> json){
     en = json['en'] != null ? json['en'].toString() : "";
     id = json['id'] != null ? json['id'].toString() : "";
  }

  Map<String,dynamic> getMap(){
    return <String,dynamic>{
      'en' : en,
      'id' : id
    };
  }
}