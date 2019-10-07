import 'package:flutter/material.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/PresenterViews/WebPageView.dart';
import 'package:nerb/Presenters/WebPagePresenter.dart';
import 'package:nerb/Views/Components/misc/WebviewPlaceholder.dart';
import 'package:nerb/Views/Pages/BasePushPage.dart';

class WebPage extends StatefulWidget {
  final String title;
  final String url;

  WebPage({@required this.title, @required this.url});

  @override
  _WebPageState createState() => new _WebPageState();
}

class _WebPageState extends State<WebPage> with WebPageView{

  WebPagePresenter presenter = WebPagePresenter();

  @override
  void initState() {
    super.initState();
    presenter.setUrl = widget.url;
    presenter.setView = this;
    presenter.initiateData();
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
        await presenter.webview.close();
        presenter.webview.dispose();
        Navigator.of(context).pop();
      },
    );
  }

  @override
  requestResize(){
    super.requestResize();
    presenter.resizeWebview();
  }


  @override
  void dispose() {
    presenter.webview.close();
    presenter.webview.dispose();
    super.dispose();
  }
}
