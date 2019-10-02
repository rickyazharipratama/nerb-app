import 'package:flutter/material.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/PresenterViews/WebPageView.dart';
import 'package:nerb/Presenters/WebPagePresenter.dart';
import 'package:nerb/Views/Components/misc/WebviewPlaceholder.dart';
import 'package:nerb/Views/Pages/BasePushPage.dart';

class WebPage extends StatefulWidget {
  final String title;
  final String url;
  final WebPagePresenter presenter = WebPagePresenter();

  WebPage({@required this.title, @required this.url}){
    presenter.setUrl = url;
  }

  @override
  _WebPageState createState() => new _WebPageState();
}

class _WebPageState extends State<WebPage> with WebPageView{


  @override
  void initState() {
    super.initState();
    widget.presenter.setView = this;
    widget.presenter.initiateData();
  }

  @override
  Widget build(BuildContext context) {
    CommonHelper.instance.forcePortraitOrientation();
    return BasePushPage(
      title: widget.title,
      child: WebviewPlaceholder(
        onRectChanged: onRectChanged,
        child: Container(),
      ),
      closeAction: () async{
        await widget.presenter.webview.close();
        widget.presenter.webview.dispose();
        Navigator.of(context).pop();
      },
    );
  }

  @override
  requestResize(){
    super.requestResize();
    widget.presenter.resizeWebview();
  }


  @override
  void dispose() {
    widget.presenter.webview.close();
    widget.presenter.webview.dispose();
    super.dispose();
  }
}
