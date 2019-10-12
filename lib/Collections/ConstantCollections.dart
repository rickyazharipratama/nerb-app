class ConstantCollections{

static const String VERSION = "1.1.0";
static const int VERSION_INT = 2;
static const int DEFAULT_RADIUS = 500;
static const String PREFIX = "nerb-mobile";
static const ENVIRONMENT = PROD;


//env
static const String DEV = "development";
static const String PROD = "production";

//network
 static const int Connectiontimeout = 25000;
  
//permission
  static const String PERMISSION_LOCATION = "permissionLocation";

//firestore
  static const String FIRESTORE_CATEGORY = "kategori";
  static const String FIRESTORE_PLACE = "places";
  static const String FIRESTORE_DEFAULT_FAVORITE = "defaultFavorites";
  static const String FIRESTORE_HERE_KEY = "hereApiKey";

//RemoteConfig
  static const String REMOTE_CONFIG_HERE_API_VERSION = ENVIRONMENT == PROD ? "hereApiVersion" : "hereApiVersionDevelopment";
  static const String REMOTE_CONFIG_PLACES_VERSION = "placesVersion";
  static const String REMOTE_CONFIG_CATEGORY_VERSION = "categoryVersion";
  static const String REMOTE_CONFIG_IS_MAINTENANCE = ENVIRONMENT == PROD ? "isMaintenance" : "isMaintenanceDevelopment";
  static const String REMOTE_CONFIG_UPDATE_VERSION = ENVIRONMENT == PROD ? "versionProduction" : "versionDevelopment";


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
  static const String RELATED_NEARBY = "nearby";
  static const String RELATED_TRANSPORTATION = "transportation";
  

//status response
  static const String RESPONSE_OK = "OK";
  static const String RESPONSE_INVALID_REQUEST = "INVALID_REQUEST";
  static const String RESPONSE_INTERNAL_SERVER_ERROR = "INTERNAL_SERVER_ERROR";
  static const String RESPONSE_TIMEOUT = "TIMEOUT";
  static const String STATUS_SUCCESS = "SUCCESS";
  static const String STATUS_FAILED = "FAILED";

//status code
  static const int STATUS_CODE_UNAUTHORIZE = 401;
  static const int STATUS_CODE_TIMEOUT_CLIENT = 408;
  static const int STATUS_CODE_TIMEOUT_SERVER = 504;
  static const int STATUS_INTERNAL_SERVER_ERROR = 500;
  static const int STATUS_BAD_GATEWAY = 400;

//event analytical
  static const String EVENT_OPEN_DETAIL_PLACES = "open_detail_places";
  static const String EVENT_OPEN_DETAIL_PLACES_BY_NEAR_YOU = " open_detail_places_by_near_you";
  static const String EVENT_LOOK_ON_MAP = "look_on_map";
  static const String EVENT_OPEN_DETAIL_PLACES_BY_NEARBY = "open_detail_places_by_nearby";
  static const String EVENT_OPEN_DETAIL_PLACES_BY_TRANSPORT = "open_detail_places_by_transport";
  static const String EVENT_OPEN_DETAIL_PLACES_BY_PLACE_LIST = "open_detail_places_by_places_list";
  static const String EVENT_OPEN_SECTION_BY_CATEGORY = "open_sections_by_category";
  static const String EVENT_SECTION_CLICKED = "section_clicked";
  static const String EVENT_PLACE_LIST_MODE = "place_list_mode";
  static const String EVENT_SELECT_FAVORITE_SECTION = "select_favorite_section";
  static const String EVENT_REMOVE_FAVORITE_SECTION = "remove_favorite_section";
  static const String EVENT_START_UPDATING_FAVORITE = "start_updating_favorite";
  static const String EVENT_FINISH_UPDATING_FAVORITE = "finish_updating_favorite";
  static const String EVENT_UPDATING_RADIUS = "updating_radius";
  static const String EVENT_SELECT_LANGUAGE = "select_language";
  static const String EVENT_USING_THEME = "using_theme";
  static const String EVENT_OPENING_WEB = "opening_web";
}