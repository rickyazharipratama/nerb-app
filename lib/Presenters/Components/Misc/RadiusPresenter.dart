import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/FirebaseAnalyticHelper.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/PresenterViews/Components/Miscs/RadiusView.dart';
import 'package:nerb/Presenters/Components/BaseComponentPresenter.dart';

class RadiusPresenter extends BaseComponentPresenter{

  RadiusView _view;
  int _radius;
  int _oldRadius;
  
  RadiusView get view => _view;
  set setView(RadiusView vw){
    _view = vw;
  }

  int get radius => _radius;

  @override
  void initiateData() async{
    super.initiateData();
    _radius = await PreferenceHelper.instance.getIntValue(key: ConstantCollections.PREF_RADIUS);
    _oldRadius = _radius;
  }

  onChanged(double val){
    _radius = val.floor();
    view.notifyState();
  }

  onValueChangeEnd(double val) async{
    FirebaseAnalyticHelper.instance.sendEvent(
      event: ConstantCollections.EVENT_UPDATING_RADIUS,
      params: {
        'date': DateTime.now().toString(),
        'old-value': _oldRadius.toString(),
        'new-value': _radius.toString()
      }
    );
    PreferenceHelper.instance.setIntValue(key: ConstantCollections.PREF_RADIUS, value: _radius);
    _oldRadius = _radius;
  }
}