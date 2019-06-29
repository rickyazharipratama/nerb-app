import 'Names.dart';

class FirestoreCategory{
  
  String id;
  Names name;
  String imageStorage;
  String icon;

  FirestoreCategory(String id, Map<String,dynamic> data){
    this.id = id;
    name = data['name'] != null ? Names.fromJson(data['name']) : null;
    imageStorage = data['imageStorage'] != null ? data['imageStorage'] : null;
    icon = data['icon'] != null ? data['icon'] : null;
  }
}