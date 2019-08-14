class ConstantCollections{

static const String VERSION = "0.0.1";
static const int DEFAULT_RADIUS = 500;


//network
 static const int Connectiontimeout = 10000;

  

//firestore
  static const String FIRESTORE_CATEGORY = "kategori";
  static const String FIRESTORE_PLACE = "places";
  static const String FIRESTORE_DEFAULT_FAVORITE = "defaultFavorites";

//preferences
  static const String PREF_MY_FAVORITE = 'prefMyFavorite';
  static const String PREF_LANGUAGE = "prefLanguage";
  static const String PREF_RADIUS = "prefRadius";
  static const String PREF_IS_DARK_THEME = "isDarkTheme";


//FLAG
  static const String EMPTY_FAVORITE = "emptyFav";
  static const String OPERATOR_FAVORITE = "operatorFav";
  static const String SEE_ALL = "seeAll";
  
  static const String LANGUAGE_ID = "id";
  static const String LANGUAGE_EN = "en";
  

//status response
  static const String RESPONSE_OK = "OK";
  static const String RESPONSE_INVALID_REQUEST = "INVALID_REQUEST";
  static const String RESPONSE_INTERNAL_SERVER_ERROR = "INTERNAL_SERVER_ERROR";
  static const String RESPONSE_TIMEOUT = "TIMEOUT";
}