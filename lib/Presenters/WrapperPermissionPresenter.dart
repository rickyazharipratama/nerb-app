import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/PresenterViews/WrapperPermissionView.dart';
import 'package:nerb/Presenters/BasePresenter.dart';

class WrapperPermissionPresenter extends BasePresenter{

  WrapperPermissionView _view;

  WrapperPermissionView get view => _view;
  set setView(WrapperPermissionView vw){
    _view = vw;
  }

  @override
  void initiateData() {
    super.initiateData();
    view.initiatePageController();
    CommonHelper.instance.settingSystemUi();
  }
}