class ConstantCollections{

static const String VERSION = "1.0.0";
static const int VERSION_INT = 1;
static const int DEFAULT_RADIUS = 500;


//network
 static const int Connectiontimeout = 10000;
  

//firestore
  static const String FIRESTORE_CATEGORY = "kategori";
  static const String FIRESTORE_PLACE = "places";
  static const String FIRESTORE_DEFAULT_FAVORITE = "defaultFavorites";
  static const String FIRESTORE_HERE_KEY = "hereApiKey";

//RemoteConfig
  static const String REMOTE_CONFIG_HERE_API_VERSION = "hereApiVersion";
  static const String REMOTE_CONFIG_PLACES_VERSION = "placesVersion";
  static const String REMOTE_CONFIG_CATEGORY_VERSION = "categoryVersion";
  static const String REMOTE_CONFIG_IS_MAINTENANCE = "isMaintenance";
  static const String REMOTE_CONFIG_UPDATE_VERSION = "versionProduction";


//preferences
  static const String PREF_MY_FAVORITE = 'prefMyFavorite';
  static const String PREF_LANGUAGE = "prefLanguage";
  static const String PREF_RADIUS = "prefRadius";
  static const String PREF_IS_DARK_THEME = "isDarkTheme";
  static const String PREF_APP_ID = "nerbAppId";
  static const String PREF_APP_CODE = "nerbAppCode";
  static const String PREF_LAST_CATEGORY_VERSION = 'lastCategoryVersion';
  static const String PREF_LAST_PLACE_VERSION = "lastPlaceVersion";
  static const String PREF_LAST_HERE_API_VERSION = "hereApiVersion";
  static const String PREF_LAST_CATEGORY = "lastCategory";
  static const String PREF_LAST_PLACE = "lastPlace";
  static const String PREF_NEARBY_PLACE = "nearbyPlace";
  static const String PREF_LAST_LOCATION = "lastLocation";
  static const String PREF_IS_MINOR_UPDATE = "isMinorUpdate";


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