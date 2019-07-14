class StringHelper{

  static StringHelper instance = StringHelper();

  Map<String, Map<String,String>> _collections = 
    {
      'en' : {
        //title
        'titleFavorite' : 'Most Recently Used',
        'titleErrFavoriteIsEmpty': 'Favorite Place Is Empty',
        'titlePlaceIsAlreadyExist': "Place Type Is Already Exist",
        'titleCategories': 'Categories',
        'titlePlacesNearYou': 'Places Near You',
        
        //desc
        'descErrFavoriteIsEmpty':'You can update popular places if you have one or several popular places on your list. Please add your popular place first.',
        'descErrPlaceIsAlreadyExist':'The type of place you choose is already in your popular list.',
        'descRadiusSetting':'You can set the range of places you want to find from your current location.',
        'descLanguageSetting':'Set the language that you prefer to use this application.',

        //label
        'labelPlaces' : 'Places',
        'labelSetting': 'Settings',
        'labelAbout': 'About',
        'labelRadius':'Radius',
        'labelLanguage':'Language',
        'labelVersion':'Version',

        //btn
        'btnRetry' : 'Retry',

        //errTitle
        'errTitleGeneral':'Ups!',
        //errDesc
        'errDescGeneral':'It seems you can not get information properly. Please try again in a few moment.'
      },
      'id' :{
        //title
        'titleFavorite' : 'Paling Sering Digunakan',
        'titleErrFavoriteIsEmpty': 'Tempat Populer Kosong',
        'titlePlaceIsAlreadyExist': "Tipe Tempat Sudah Ada",
        'titleCategories': 'Categories',
        'titlePlacesNearYou': 'Tempat Didekat Kamu',

        //desc
        'descErrFavoriteIsEmpty':'Kamu dapat melakukan pembaruan tempat populer bila telah memiliki satu atau beberapa tempat populer didalam daftar tipe tempat populer kamu. Silahkan tambahkan tempat populer kamu terlebih dahulu.',
        'descErrPlaceIsAlreadyExist':'Tipe tempat yang kamu pilih sudah ada di dalam daftar tipe tempat populer kamu.',
        'descRadiusSetting':'Kamu bisa atur jangkauan  tempat-tempat yang ingin kamu temukan dari lokasi kamu.',
        'descLanguageSetting':'Atur bahasa yang lebih kamu sukai dalam menggunakan aplikasi ini',

        //label
        'labelPlaces': 'Tempat',
        'labelSetting': 'Pengaturan',
        'labelAbout': 'Tentang',
        'labelRadius':'Radius',
        'labelLanguage':'Bahasa',
        'labelVersion':'Versi',

        //btn
        'btnRetry' : 'Retry',
        //errTitle
        'errTitleGeneral':'Ups!',
        //errDesc
        'errDescGeneral':'Sepertinya kamu tidak bisa mendapatkan informasi dengan benar. Silahkan coba lagi dalam beberapa saat.'
      }
    };

  Map<String,Map<String,String>> get getCollections => _collections;
}