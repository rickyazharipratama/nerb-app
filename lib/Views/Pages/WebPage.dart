import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Views/Components/misc/WebviewPlaceholder.dart';
import 'package:nerb/Views/Pages/BasePushPage.dart';

class WebPage extends StatefulWidget {
  final String title;
  final String url;

  WebPage({@required this.title, @required this.url});

  @override
  _WebPageState createState() => new _WebPageState();
}

class _WebPageState extends State<WebPage> {

  Rect _rect;
  FlutterWebviewPlugin wv;

  @override
  void initState() {
    super.initState();
    wv = FlutterWebviewPlugin()
      ..onUrlChanged.listen(urlChanged)
      ..onStateChanged.listen(onStateChanged);  
    wv.launch(
      widget.url,
      clearCache: true,
      clearCookies: true,
      rect: Rect.zero 
    );
  }

  @override
  Widget build(BuildContext context) {
    CommonHelper.instance.forcePortraitOrientation();
    return BasePushPage(
      title: widget.title,
      child: WebviewPlaceholder(
        onRectChanged: onRectchanged,
        child: Container(),
      ),
      closeAction: () async{
        await wv.close();
        wv.dispose();
        Navigator.of(context).pop();
      },
    );
  }

  urlChanged(url){
    //url changed
  }

  onStateChanged(WebViewStateChanged state){
    if(state.type == WebViewState.startLoad){
      wv.resize(_rect);
    }
  }

  onRectchanged(rect){
    if(_rect == null){
      _rect = rect;
    }else{
      if(_rect != rect){
        _rect = rect;
        wv.resize(_rect);
      }
    }
  }

  @override
  void dispose() {
    wv.close();
    wv.dispose();
    super.dispose();
  }
}
