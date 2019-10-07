import 'dart:ui';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:nerb/Collections/FirebaseAnalyticHelper.dart';
import 'package:nerb/PresenterViews/WebPageView.dart';
import 'package:nerb/Presenters/BasePresenter.dart';

class WebPagePresenter extends BasePresenter{

  WebPageView _view;
  FlutterWebviewPlugin _webview;
  String _url;

  WebPageView get view => _view;
  set setView( WebPageView vw){
    _view = vw;
  }

  FlutterWebviewPlugin get webview => _webview;

  String get url => _url;
  set setUrl(String url){
    _url = url;
  }

  @override
  void initiateData() {
    super.initiateData();
    _webview = FlutterWebviewPlugin()
    ..onUrlChanged.listen(onUrlChanged)
    ..onStateChanged.listen(onWebViewStateChanged);
    FirebaseAnalyticHelper.instance.setScreen(
      screen: "webview"
    );
    launchWebview();
  }

  launchWebview(){
    webview.launch(url,
      clearCache: true,
      clearCookies: true,
      rect: Rect.fromLTWH(0, 0, 100, 100)
    );
  }

  onWebViewStateChanged(WebViewStateChanged changed){
    if(changed.type == WebViewState.startLoad){
      resizeWebview();
    }
  }

  onUrlChanged(String url){

  }

  resizeWebview(){
    webview.resize(view.rect);
  }
}