class CategoryPlaceResponse{

  String id;
  String title;
  String href;
  String type;
  String system;

  CategoryPlaceResponse.fromJson(Map<String,dynamic> data){
    id = data['id'];
    title = data['title'];
    href = data['href'];
    type = data['type'];
    system = data['system'];
  }

  Map<String,dynamic> getMap(){
    return{
      'id':id,
      'title':title,
      'href':href,
      'type':type,
      'system':system
    };
  }
}