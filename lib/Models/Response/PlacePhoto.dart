class PlacePhoto{

  int height;
  List<String> htmlAttributions;
  String photoReference;
  int width;

  PlacePhoto.fromJson(Map<String,dynamic> data){
    height = data['height']!= null ? data['height'] : 0;
    htmlAttributions = data['html_attributions'].cast<String>();
    photoReference = data['photo_reference'];
    width = data['width'] != null ? data['width'] :0;
  }

  Map<String,dynamic>getMap(){
    return{
      'height' : height,
      'html_attributions': htmlAttributions,
      'photo_reference' : photoReference,
      'width' : width
    };
  }

}