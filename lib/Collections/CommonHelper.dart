import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/DistanceHelper.dart';
import 'package:nerb/Collections/NerbNavigator.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Models/Response/AppVersion.dart';
import 'package:nerb/Views/Pages/Maintenance.dart';
import 'package:nerb/Views/Pages/MajorUpdate.dart';

class CommonHelper{

  static CommonHelper instance = CommonHelper();


  String getPlaceImagebyIconName({String icon}){
      if(icon.contains("geocode")){
        return "assets/placeholder_geocode.png";
      }else if(icon.toLowerCase().contains("atm") || icon.toLowerCase().contains("bank")){
        return "assets/placeholder_bank.png";
      }else if(icon.toLowerCase().contains("restaurant")){
        return "assets/placeholder_restaurant.png";
      }else if(icon.toLowerCase().contains("business") || icon.toLowerCase().contains("post_office")){
        return "assets/placeholder_business.png";
      }else if(icon.toLowerCase().contains("shopping") || icon.toLowerCase().contains("civic_building")){
        return "assets/placeholder_shopping.png";
      }else if(icon.toLowerCase().contains("school")){
        return "assets/placeholder_school.png";
      }else if(icon.toLowerCase().contains("lodging")){
        return "assets/placeholder_lodging.png";
      }
      return null;
  }

  String getPlaceImageByCategory({String category}){
    List<String> restaurant = ["restaurant","casual dining","fine dining","take out & delivery only", "food market-stall","market-stall", "taqueria", "deli", "cafeteria", "bistro", "fast food"];//done
    List<String> drinks = ["coffee-tea","coffee shop","tea house"];//done
    
    List<String> nightLifeEntertainment = ["nightlife-entertainment","bar or pub","night club","dancing", "karaoke", "live entertainment-music", "billiards-pool hall", "video arcade-game room", "jazz club", "beer garden", "adult entertainment", "cocktail lounge","going out"];//done
    List<String> cinema = ["cinema"];//done
    List<String> theatreMusicCulture = ["theatre, music & culture", "performing arts","music","arts"];//done
    List<String> gamblingLotteryBetting =["gambling-lottery-betting", "casino", "lottery booth"];//done
    
    List<String> landmarkAttarction = ["landmark-attraction","tourist attraction","gallery","historical monument","winery","named intersection-chowk","brewery","distillery"];//done
    List<String> museum =["museum","science museum","children's museum","history museum","art museum"];//done
    List<String> religiousPlaces = ["religious place", "church","temple", "synagogue", "ashram", "mosque", "other place of worship","gurdwara"];//done
    
    List<String> bodyOfWater= ["body of water", "reservoir", "waterfall", "bay-harbor", "river", "canal", "lake","undersea feature"];//done
    List<String> montainHill =["mountain or hill", "mountain passes", "mountain peaks"];//done
    List<String> forestVegetation=["forest, heath or other vegetation"];//done
    List<String> natureNGeogaphical=["natural & geographical"];//done

    List<String> airport=["public sports airport","airport","airport terminal"];//done
    List<String> publicTransportation=["public transport","train station","bus station","underground train-subway","commuter rail station","commuter train","public transit access","transportation service","bus stop","local transit","ferry terminal","boat ferry","rail ferry","taxi stand","highway exit","tollbooth","lightrail","water transit","monorail","aerial tramway","bus rapid transit","inclined rail","bicycle sharing location","bicycle parking"];//done
    List<String> cargoTransportation=["cargo transportation","weigh station","cargo center","rail yard","seaport-harbour","airport cargo","couriers","cargo transportation","delivery entrance","loading dock","loading zone"];//done
    List<String> restArea=["rest area","complete rest area","parking & restroom only rest area","parking only rest area","motorway service rest area","scenic overlook rest area"];//done

    List<String> hotel =["hotel-motel,hotel or motel","hotel","motel"];//done
    List<String> lodging=["lodging","hostel","campground","guest house","bed & breakfast","holiday park","short-time motel"];//done

    List<String> outdoorRecreation = ["outdoor-recreation","park-recreation area","sports field","garden","beach","recreation center","ski lift","scenic point","off road trailhead","trailhead","off-road vehicle area","campsite","outdoor service","ranger station","bicycle service"];//done
    List<String> leisure = ["leisure","amusement park","theme park","zoo","wild animal park","wildlife refuge","aquarium","ski resort","animal park","water park"];//done

    List<String> generalStore = ["store","convenience store","shopping mall","department-store","department store,mall-shopping complex","mall-shopping","mall","shopping center","shop"];//done
    List<String> foodnDrink =["food & drink","food-beverage specialty store","food-beverage","grocery","specialty food store","wine & liquor","bakery & baked goods store","sweet shop","butcher","dairy goods"];//done
    List<String> drugStorePharmacy =["drugstore-pharmacy","drugstore or pharmacy","drugstore","pharmacy"];//done
    List<String> electronic=["electronics","consumer electronics store","hardware-house-garden-shop","mobile retailer","mobile service center","computer & software","entertainment electronics"];//done
    List<String> hardwareHouseGarden = ["hardware, house & garden","home improvement-hardware store","home specialty store","floor & carpet","furniture store","garden center","glass & window","lumber","major appliance","power equipment dealer","paint store"];//done
    List<String> bookStore =["other bookshop","bookstore","bookshop"];
    List<String> clothingAccessories = ["clothing & accessories","men's apparel","women's apparel","children's apparel","shoes-footwear","specialty clothing store"];//done
    List<String> consumerGoods =["consumer goods","sporting goods store","office supply & services store","specialty store","pet supply","warehouse-wholesale store","general merchandise","discount store","flowers & jewelry","variety store","gift, antique & art","record, cd & video","video & game rental","bicycle & bicycle accessories shop","market","motorcycle accessories","non-store retailers","pawnshop","used-second hand merchandise stores","adult shop","arts & crafts supplies","florist","jeweler","toy store","hunting-fishing shop","running-walking shop","skate shop","ski shop","snowboard shop","surf shop","bmx shop","camping-hiking shop","camping-hiking","canoe-kayak shop","cross country ski shop","tack shop"];
    List<String> hairNBeauty = ["hair & beauty","barber","nail salon","hair salon"];//done

    List<String> moneyCashService =["banking","bank","atm","money-cash","money-cash services","money transferring service","check cashing service-currency exchange","service-currency"];//done
    List<String> communicationMedia = ["communication-media","telephone service"];//done
    List<String> commercialServices =["service","commercial services","advertising-marketing, pr & market research","catering & other food services","construction","customer care-service center","care-service","engineering & scientific services","farming","food production","human resources & recruiting services","investigation services","it & office equipment services","landscaping services","locksmiths & security systems services","management & consulting services","manufacturing","mining","modeling agencies","motorcycle service & maintenance","organizations & societies","entertainment & recreation","finance & insurance","healthcare","healthcare & healthcare support services","rental & leasing","repair & maintenance services","printing & publishing","specialty trade contractors","towing service","translation & interpretation services","apartment rental-flat rental","b2b sales & services","b2b restaurant services","aviation","interior & exterior design","property management","financial investment firm"];//done
    List<String> businessIndustry =["business facility","business & services","business","services"];//done
    List<String> policeFireEmergency =["police-fire-emergency","police station","solice services-security","services-security","fire department","ambulance services"];
    List<String> consumerServices =["consumer services","travel agent-ticketing","travel-agency","agent-ticketing","dry cleaning & laundry","attorney","boating","business service","business service","funeral director","mover","photography","real estate services","repair service","social service","storage","tailor & alteration","tax service","utilities","waste & sanitary","bicycle service & maintenance","bill payment service","body piercing & tattoos","Wedding services & bridal studio","internet cafe","kindergarten & childcare","maid services","marriage & match making services","public administration","wellness center & services","pet care","legal services","tanning salon","recycling center","electrical","plumbing"];
    List<String> postOffice=["post office"];
    List<String> touristInformation =["tourist information"];
    List<String> fuelStation =["fueling station","petrol-gasoline station","ev charging station"];
    List<String> carDealerSales =["car dealer-sales","dealer-sales","car-dealer-repair","automobile dealership-new cars","dealership-new","automobile dealership-used cars","motorcycle dealership"];
    List<String> carRepairServices =["car repair-service","repair-service","car wash-detailing","wash-detailing","car repair","auto parts","emission testing","tire repair","truck repair","van repair","road assistance","automobile club"];
    List<String> carRental =["car rental","rental car agency"];
    List<String> truckSemiDealerService=["truck-semi dealer-services","dealer-services","truck dealership","truck parking","truck stop-plaza","stop-plaza","truck wash"];
    
    List<String> healthCare =["hospital or health care facility","hospital or healthcare facility","dentist-dental office","dentist-dental","family-general practice physicians","family-general","psychiatric institute","nursing home","medical services-clinics","services-clinics","hospital","optical","veterinarian","hospital emergency room","therapist","chiropractor","blood bank"];
    List<String> governmentOrCommunityFacilities = ["government or community facility","city hall","embassy","military base","county council","civic-community center","civic-community","court house","government office","border crossing"];
    List<String> educationalFacilities =["educational facility","education facility","higher education","school","training & development","coaching institute","fine arts","language studies"];
    List<String> libraries=["other library","library"];
    List<String> eventSpaces =["event spaces","banquet hall","convention-exhibition center"];
    List<String> parking =["parking","parking facility","parking garage-parking house","garage-parking","parking lot","park & ride","cellphone parking lot"];
    List<String> sportFacilityVanue=["sports facility-venue","facility-venue","sports complex-stadium","complex-stadium","ice skating rink","swimming pool","tennis court","bowling center","indoor ski","hockey","racquetball court","shooting range","soccer club","squash court","fitness-health club","fitness-health","indoor sports","golf course","golf practice range","race track","sporting instruction & camps","sports activities","basketball","badminton","rugby","diving center","bike park","bmx track","running track"];
    List<String> facilities =["facilities","cemetery","crematorium","public restroom-toilets","restroom-toilets","clubhouse","registration office"];
    
    List<String> cityTownVillage = ["city, town or village","hamlet","named place","neighborhood"];
    List<String> outdoorAreaComplex = ["outdoor area-complex","area-complex","industrial zone","marina","rv parks","collective community","island","meeting point"];
    List<String> buildings = ["building","residential area-building","area-building"];
    List<String> administrativeRegionStreet = ["administrative region-streets","region-streets","administrative region","postal area","street or square","intersection"];

    if(airport.contains(category)){
      return "assets/airport.jpg";
    }else if(restaurant.contains(category)){
      return "assets/restaurant.jpg";
    }else if(drinks.contains(category)){
      return "assets/drinks.jpg";
    }else if(nightLifeEntertainment.contains(category)){
      return "assets/nightlife.jpg";
    }else if(cinema.contains(category)){
      return "assets/cinema.jpg";
    }else if(theatreMusicCulture.contains(category)){
      return "assets/Theatre.jpg";
    }else if(gamblingLotteryBetting.contains(category)){
      return "assets/gambling.jpg";
    }else if(landmarkAttarction.contains(category)){
      return "assets/historical-monument.jpg";
    }else if(museum.contains(category)){
      return "assets/museum.jpg";
    }else if(religiousPlaces.contains(category)){
      return "assets/religious-place.jpg";
    }else if(bodyOfWater.contains(category)){
      return "assets/body-of-water.jpg";
    }else if(montainHill.contains(category)){
      return "assets/montain-hill.jpg";
    }else if(forestVegetation.contains(category)){
      return "assets/forest.jpg";
    }else if(natureNGeogaphical.contains(category)){
      return "assets/national-park.jpg";
    }else if(publicTransportation.contains(category)){
      return "assets/public transportation.jpg";
    }else if(cargoTransportation.contains(category)){
      return "assets/cargo transportation.jpg";
    }else if(restArea.contains(category)){
      return "assets/Rest Area.jpg";
    }else if(lodging.contains(category)){
      return "assets/lodging.jpg";
    }else if(hotel.contains(category)){
      return "assets/hotel.jpg";
    }else if(outdoorRecreation.contains(category)){
      return "assets/outdoor recreation.jpg";
    }else if(leisure.contains(category)){
      return "assets/leisure.jpg";
    }else if(generalStore.contains(category)){
      return "assets/mall.jpg";
    }else if(foodnDrink.contains(category)){
      return "assets/grocery.jpg";
    }else if(drugStorePharmacy.contains(category)){
      return "assets/pharmacist.jpg";
    }else if(electronic.contains(category)){
      return "assets/ecom.jpg";
    }else if(hardwareHouseGarden.contains(category)){
      return "assets/furniture.jpg";
    }else if(bookStore.contains(category)){
      return "assets/books-store.jpg";
    }else if(clothingAccessories.contains(category)){
      return "assets/clothing store.jpg";
    }else if(consumerGoods.contains(category)){
      return "assets/consumer-goods.jpg";
    }else if(hairNBeauty.contains(category)){
      return "assets/barber.jpg";
    }else if(moneyCashService.contains(category)){
      return "assets/atm.jpg";
    }else if(communicationMedia.contains(category)){
      return "assets/social-media.jpg";
    }else if(commercialServices.contains(category)){
      return "assets/commercial.jpg";
    }else if(businessIndustry.contains(category)){
      return "assets/business facility.jpg";
    }else if(policeFireEmergency.contains(category)){
      return "assets/emergency-service.jpg";
    }else if(consumerServices.contains(category)){
      return "assets/consumer-service.jpg";
    }else if(postOffice.contains(category)){
      return "assets/post.jpg";
    }else if(touristInformation.contains(category)){
      return "assets/map.jpg";
    }else if(fuelStation.contains(category)){
      return "assets/fuel.jpg";
    }else if(carDealerSales.contains(category)){
      return "assets/dealer.jpg";
    }else if(carRepairServices.contains(category)){
      return "assets/car-repair.jpg";
    }else if(carRental.contains(category)){
      return "assets/car-rental.jpg";
    }else if(truckSemiDealerService.contains(category)){
      return "assets/truck-dealer.jpg";
    }else if(healthCare.contains(category)){
      return "assets/healthCare.jpg";
    }else if(governmentOrCommunityFacilities.contains(category)){
      return "assets/city-hall.jpg";
    }else if(educationalFacilities.contains(category)){
      return "assets/school.jpg";
    }else if(libraries.contains(category)){
      return "assets/library.jpg";
    }else if(eventSpaces.contains(category)){
      return "assets/convention.jpg";
    }else if(parking.contains(category)){
      return "assets/parking.jpg";
    }else if(sportFacilityVanue.contains(category)){
      return "assets/sport facility.jpg";
    }else if(facilities.contains(category)){
      return "assets/restrom.jpg";
    }else if(cityTownVillage.contains(category)){
      return "assets/town.jpg";
    }else if(outdoorAreaComplex.contains(category)){
      return "assets/construction.jpg";
    }else if(buildings.contains(category)){
      return "assets/building.jpg";
    }else if(administrativeRegionStreet.contains(category)){
      return "assets/road.jpg";
    }
    return null;
  }

  Future<RemoteConfig> fetchRemoteConfig() async{
    RemoteConfig rc = await RemoteConfig.instance;
    int lastFetch = rc.lastFetchTime.millisecondsSinceEpoch;
    int tfh = 5 * 60 * 1000; // refresh in 5 minutes
    if(!(rc.lastFetchStatus == LastFetchStatus.success)){
      await rc.fetch(
        expiration: const Duration(minutes: 5)
      );
      await rc.activateFetched();
    }else{
      if(DateTime.now().millisecondsSinceEpoch > (lastFetch + tfh)){
        await rc.fetch(
          expiration: const Duration(minutes: 5)
        );
        await rc.activateFetched();
      }
    }
    return rc;
  }

  forcePortraitOrientation(){
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  getTitleErrorByStatus({
    @required String status,
    @required BuildContext context
  }){
    if(status == ConstantCollections.RESPONSE_TIMEOUT){
      return UserLanguage.of(context).errorTitle("general");
    }else if(status == ConstantCollections.RESPONSE_INVALID_REQUEST){
      return UserLanguage.of(context).errorTitle("general");
    }else if(status == ConstantCollections.RESPONSE_INTERNAL_SERVER_ERROR){
      return UserLanguage.of(context).errorTitle("general");
    }
    return UserLanguage.of(context).errorTitle("general");
  }

  getDescErrorByStatus({
    @required String status,
    @required BuildContext context
  }){
    if(status == ConstantCollections.RESPONSE_TIMEOUT){
      return UserLanguage.of(context).errorDesc("general");
    }else if(status == ConstantCollections.RESPONSE_INVALID_REQUEST){
      return UserLanguage.of(context).errorDesc("general");
    }else if(status == ConstantCollections.RESPONSE_INTERNAL_SERVER_ERROR){
      return UserLanguage.of(context).errorDesc("general");
    }
    return UserLanguage.of(context).errorDesc("general");
  }

  getTitleErrorByCode({
    @required int code,
    @required BuildContext context
  }){
    if(code == ConstantCollections.STATUS_CODE_TIMEOUT_CLIENT){
      // no internet Connection
      return UserLanguage.of(context).errorTitle("noInternet");
    }else if (code == ConstantCollections.STATUS_CODE_TIMEOUT_SERVER){
      // server timeout
      return UserLanguage.of(context).errorTitle("serverTimeOut");
    }else if (code == ConstantCollections.STATUS_INTERNAL_SERVER_ERROR){
      //internal sever error
      return UserLanguage.of(context).errorTitle("general");
    }
    return UserLanguage.of(context).errorTitle("general");
  }

  getDescErrorByCode({
    @required int code,
    @required BuildContext context
  }){
    if(code == ConstantCollections.STATUS_CODE_TIMEOUT_CLIENT){
      // no internet Connection
      return UserLanguage.of(context).errorDesc("noInternet");
    }else if (code == ConstantCollections.STATUS_CODE_TIMEOUT_SERVER){
      // server timeout
      return UserLanguage.of(context).errorDesc("serverTimeOut");
    }else if (code == ConstantCollections.STATUS_INTERNAL_SERVER_ERROR){
      //internal sever error
      return UserLanguage.of(context).errorDesc("general");
    }
    return UserLanguage.of(context).errorDesc("general");
  }

  Future<bool> isNeedToRefreshNearbyPlace(int lastFetch) async{
    String lastLocation = await PreferenceHelper.instance.getStringValue(
      key: ConstantCollections.PREF_LAST_LOCATION
    );
    Location loc = Location();
    LocationData currLoc = await loc.getLocation();
    int radius = await PreferenceHelper.instance.getIntValue(key: ConstantCollections.PREF_RADIUS);

    if(DateTime.now().millisecondsSinceEpoch > lastFetch + (5 * 60 *1000)){
      return true;
    }else{
      if(lastLocation == null){
        return true;
      }else{
        List<String> lastLocations = lastLocation.split(",");
        double lastLat = double.parse(lastLocations[0]);
        double lastLong = double.parse(lastLocations[1]);
        double distance = DistanceHelper.instance.getDistance(
          fromLat: lastLat,
          fromLong: lastLong,
          toLat: currLoc.latitude,
          toLong: currLoc.longitude
        );
        if(distance > radius){
          return true;
        }
        return false;
      }
    }
  }

  Future<bool>checkMaintenance(BuildContext context) async{
    try{
      showLog("maintenance request");
      RemoteConfig rc = await fetchRemoteConfig();
      bool isMaintenance = rc.getBool(ConstantCollections.REMOTE_CONFIG_IS_MAINTENANCE);
      if(isMaintenance){
        showLog("is maintenance");
        NerbNavigator.instance.newClearRoute(context,
          child: Maintenance()
        );
      }
      return isMaintenance;
    }on Exception catch(e){
      showLog("failed to fetch : "+ e.toString());
      return false;
    }
  }
  Future<bool> isMajorUpdateVersion(BuildContext context) async{
    try{
    RemoteConfig rc = await fetchRemoteConfig();
    String tmp = rc.getString(ConstantCollections.REMOTE_CONFIG_UPDATE_VERSION);
    showLog(tmp);
    if(tmp != null){
      AppVersion vrs = AppVersion.fromJson(jsonDecode(tmp));
      if(vrs.minVersion > ConstantCollections.VERSION_INT){
        NerbNavigator.instance.newClearRoute(context,
          child: MajorUpdate()
        );
        return true;
      }else{
        if(vrs.currVersion > ConstantCollections.VERSION_INT){
          PreferenceHelper.instance.setBoolValue(
            key: ConstantCollections.PREF_IS_MINOR_UPDATE,
            val: true
          );
        }
      }
    }
    return false;
    }on Exception catch(e){
      showLog("failed to fetch major version : "+e.toString());
      return false;
    }
  }

  settingSystemUi() async{
    bool isDarkMode = await PreferenceHelper.instance.isHaveVal( key :ConstantCollections.PREF_IS_DARK_THEME);
    if(isDarkMode){
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xff252525),
        systemNavigationBarIconBrightness: Brightness.light
      ));
    }else{
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: Color(0x55000000),
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xfffefefe),
        systemNavigationBarIconBrightness: Brightness.dark
      ));
    }
  }

  showLog(String log){
    if(ConstantCollections.ENVIRONMENT == ConstantCollections.DEV){
      debugPrint(log);
    }
  }
}