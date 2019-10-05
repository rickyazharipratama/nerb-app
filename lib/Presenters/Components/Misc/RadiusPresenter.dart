import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/PresenterViews/Components/Miscs/RadiusView.dart';
import 'package:nerb/Presenters/Components/BaseComponentPresenter.dart';

class RadiusPresenter extends BaseComponentPresenter{

  RadiusView _view;
  int _radius;
  
  RadiusView get view => _view;
  set setView(RadiusView vw){
    _view = vw;
  }

  int get radius => _radius;

  @override
  void initiateData() async{
    super.initiateData();
    _radius = await PreferenceHelper.instance.getIntValue(key: ConstantCollections.PREF_RADIUS);
  }

  onChanged(double val){
    _radius = val.floor();
    view.notifyState();
  }

  onValueChangeEnd(double val){
    PreferenceHelper.instance.setIntValue(key: ConstantCollections.PREF_RADIUS, value: _radius);
  }
}