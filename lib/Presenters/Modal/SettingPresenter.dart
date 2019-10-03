import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/NerbApp.dart';
import 'package:nerb/PresenterViews/Modal/SettingView.dart';
import 'package:nerb/Presenters/BasePresenter.dart';

class SettingPresenter extends BasePresenter{

  SettingView _view;

  SettingView get view => _view;
  set setView(SettingView vw){
    _view = vw;
  }

  @override
  void initiateData() async{
    super.initiateData();
     view.setDarkTheme = await PreferenceHelper.instance.isHaveVal(key: ConstantCollections.PREF_IS_DARK_THEME);
     view.notifyState();
  }

  changingTheme(isVal){
    view.setDarkTheme = isVal;
    NerbApp.of(view.currentContext()).changingTheme(isVal);
    view.notifyState();
  }
}