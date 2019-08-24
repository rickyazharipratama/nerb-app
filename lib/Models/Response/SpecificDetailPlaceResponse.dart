import 'package:nerb/Models/Response/CategoryPlaceResponse.dart';

class SpecificDetailPlaceResponse{

  SpecificLocation location;
  String name;
  String placeId;
  String view;
  CategoryPlaceResponse category;
  String icon;
  SpecificDetailPlaceRelated related;
  SpecificDetailPlaceContact contact;
  SpecificDetailPlaceExtended extended;

  SpecificDetailPlaceResponse.fromJson(Map<String,dynamic> data){
    name = data['name'];
    placeId = data['placeId'];
    view = data['view'];
    if(data['location'] != null){
      location = SpecificLocation.fromJson(data['location']);
    }
    if(data['contacts'] != null){
      contact = SpecificDetailPlaceContact.fromJson(data['contacts'] as Map<String,dynamic>);
    }
    if(data['categories'] != null){
      category = CategoryPlaceResponse.fromJson(data['categories']);
    }
    icon = data['icon'];
    if(data['related'] != null){
      related = SpecificDetailPlaceRelated.fromJson(data['related']);
    }
    if(data['extended'] != null){
      extended = SpecificDetailPlaceExtended.fromJson(data['extended']);
    }
  }
}

class SpecificLocation{
  List<String> position;
  SpecificAddress address;
  List<SpecificDetailAccess> access;

  SpecificLocation.fromJson( Map<String,dynamic> data){
    position = List();
    if(data['position'] != null){
      (data['position'] as List<dynamic>).forEach((pos){
        position.add(pos.toString());
      });
    }
    address = data['address'] != null ? SpecificAddress.fromJson(data['address']) : null;
    access = List();
    if(data['access'] != null){
      (data['access'] as List<dynamic>).forEach((acc){
        access.add(SpecificDetailAccess.fromJson(acc as Map<String,dynamic>));
      });
    }
  }
}

class SpecificAddress{

  String text;
  String street;
  String postalCode;
  String city;
  String county;
  String state;
  String country;
  String countryCode;

  SpecificAddress.fromJson(Map<String,dynamic> data){
    text = data['text'];
    street = data['street'];
    postalCode = data['postalCode'];
    city = data['city'];
    county = data['county'];
    state = data['state'];
    country = data['country'];
    countryCode = data['countryCode'];
  }
}



class SpecificAccess{

  List<SpecificDetailAccess> access;
  
  SpecificAccess.fromJson(Map<String,dynamic> json){
    access = List();
    if(json['access'] != null){
      (json['access'] as List<dynamic>).forEach((acc){
        access.add(SpecificDetailAccess.fromJson(acc as Map<String,dynamic>));
      });
    }
  }
}

class SpecificDetailAccess{

  String accessType;
  List<String> position;

  SpecificDetailAccess.fromJson(Map<String,dynamic> data){
    accessType = data['accessType'];
    position = List();
    if(data['position'] != null){
      (data['position'] as List<dynamic>).forEach((pos){
        position.add(pos.toString());
      });
    }
  }
}

class SpecificDetailPlaceRelated{
  SpecificDetailPlaceDetailRelated recommended;
  SpecificDetailPlaceDetailRelated publicTransport;

  SpecificDetailPlaceRelated.fromJson(Map<String,dynamic> data){
    if(data['recommended'] != null){
      recommended = SpecificDetailPlaceDetailRelated.fromJson(data['recommended']);
    }
    if(data['public-transport'] != null){
      publicTransport = SpecificDetailPlaceDetailRelated.fromJson(data['public-transport']);
    }
  } 
}

class SpecificDetailPlaceDetailRelated{
  String title;
  String href;
  String type;

  SpecificDetailPlaceDetailRelated.fromJson(Map<String,dynamic> data){
    title = data['title'];
    href = data['href'] != null ? Uri.encodeComponent(data['href']) : null;
    type = data['type'];
  }
}

class SpecificDetailPlaceContact{
  List<SpecificDetailPlaceDetailContact> phone;
  List<SpecificDetailPlaceDetailContact> email;
  List<SpecificDetailPlaceDetailContact> website;

  SpecificDetailPlaceContact.fromJson(Map<String,dynamic> data){
    if(data != null){
      phone = List();
      if(data['phone'] != null){
        (data['phone'] as List<dynamic>).forEach((phn){
          phone.add(SpecificDetailPlaceDetailContact.fromJson(phn));
        });
      }
      email = List();
      if(data['email'] != null){
        (data['email'] as List<dynamic>).forEach((em){
           email.add(SpecificDetailPlaceDetailContact.fromJson(em));
        });
      }
      website = List();
      if(data['website'] != null){
        (data['website'] as List<dynamic>).forEach((wb){
          website.add(SpecificDetailPlaceDetailContact.fromJson(wb));
        });
      }
    }
  }
}

class SpecificDetailPlaceDetailContact{
  String label;
  String value;

  SpecificDetailPlaceDetailContact.fromJson(Map<String,dynamic> data){
    label = data['label'];
    value = data['value'];
  }
}

class SpecificDetailPlaceExtended{
  SpecificDetailPlaceExtendedOpeningHours openingHours;

  SpecificDetailPlaceExtended.fromJson(Map<String, dynamic> data){
    if(data['openingHours'] != null){
      openingHours = SpecificDetailPlaceExtendedOpeningHours.fromJson(data['openingHours']);
    }
  }

}

class SpecificDetailPlaceExtendedOpeningHours{

  String text;
  String label;
  bool isOpen;
  SpecificDetailPlaceExtendedOpeningHours.fromJson(Map<String,dynamic> data){
    text = data['text'];
    label = data['label'];
    isOpen  = data['isOpen'];
  }
}