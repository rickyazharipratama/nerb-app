import 'package:nerb/Collections/ConstantCollections.dart';

import 'Names.dart';

class PlaceModel{
  
  String forSearch;
  String materialIcon;
  Names name;
  String id;

  PlaceModel.fromFireStore(String id, Map<String,dynamic> data){
    this.id = id;
    forSearch = data['forSearch'] != null ? data['forSearch'] : null ;
    materialIcon = data['materialIcon'] != null ? data['materialIcon'] : null;
    name = data['name'] != null ? Names.fromJson(data['name']) : null;
  }

  PlaceModel.fromStore(Map<String,dynamic> data){
    id = data['id'] != null ? data['id'] : null;
    forSearch = data['forSearch'] != null ? data['forSearch'] : null ;
    materialIcon = data['materialIcon'] != null ? data['materialIcon'] : null;
    name = data['name'] != null ? Names.fromJson(data['name']) : null;
  }

  PlaceModel.emptyPlace(){
    id= ConstantCollections.EMPTY_FAVORITE;
  }

  Map<String,dynamic> getMap(){
    return <String,dynamic>{
      'id':id,
      'forSearch':forSearch,
      'materialIcon':materialIcon,
      'name' : name.getMap()
    };
  }

}