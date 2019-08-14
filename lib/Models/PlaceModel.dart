import 'package:nerb/Collections/ConstantCollections.dart';

import 'Names.dart';

class PlaceModel{
  
  String forSearch;
  String materialIcon;
  List<String> categories;
  Names section;
  Names name;
  String id;

  PlaceModel.fromFireStore(String id, Map<String,dynamic> data){
    this.id = id;
    forSearch = data['forSearch'] != null ? data['forSearch'] : null ;
    materialIcon = data['materialIcon'] != null ? data['materialIcon'] : null;
    if(data['categories'] != null){
      categories = List();
      data['categories'].forEach((category){
        categories.add(category.toString());
      });
    }
    name = data['name'] != null ? Names.fromJson(data['name']) : null;
    section = data['section'] != null?Names.fromJson(data['section']): null;
  }

  PlaceModel.fromStore(Map<String,dynamic> data){
    id = data['id'] != null ? data['id'] : null;
    forSearch = data['forSearch'] != null ? data['forSearch'] : null ;
    materialIcon = data['materialIcon'] != null ? data['materialIcon'] : null;
    if(data['categories'] != null){
      categories = List();
      data['categories'].forEach((category){
        categories.add(category.toString());
      });
    }
    name = data['name'] != null ? Names.fromJson(data['name']) : null;
    section = data['section'] != null ? Names.fromJson(data['section']) : null;
  }

  PlaceModel.emptyPlace({String prefix}){
    id= ConstantCollections.EMPTY_FAVORITE + prefix;
  }

  PlaceModel.forOperator(){
    id = ConstantCollections.OPERATOR_FAVORITE;
  }

  Map<String,dynamic> getMap(){
    return <String,dynamic>{
      'id':id,
      'forSearch':forSearch,
      'materialIcon':materialIcon,
      'categories' : categories != null ? categories : null,
      'name' : name != null ? name.getMap() : null,
      'section': section != null ? section.getMap() : null
    };
  }
}