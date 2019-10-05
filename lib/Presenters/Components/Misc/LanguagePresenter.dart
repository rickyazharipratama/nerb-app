import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/PresenterViews/Components/Miscs/LanguageView.dart';
import 'package:nerb/Presenters/Components/BaseComponentPresenter.dart';

class LanguagePresenter extends BaseComponentPresenter{

  LanguageView _view;
  List<String> _langs = [ConstantCollections.LANGUAGE_EN, ConstantCollections.LANGUAGE_ID];
  List<String> _images = ["assets/ic_usa.png","assets/ic_id.png"];

  LanguageView get view => _view;
  set setView(LanguageView vw){
    _view = vw;
  }

  List<String> get langs => _langs;
  List<String> get images => _images;
}