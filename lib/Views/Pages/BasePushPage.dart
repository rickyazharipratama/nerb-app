import 'package:flutter/material.dart';
import 'package:nerb/Views/Components/misc/NerbPushAppBar.dart';

class BasePushPage extends StatelessWidget {

  final String title;
  final Widget child;
  final bool isAvoidBottomInset;
  final VoidCallback closeAction;
  BasePushPage({@required this.title, @required this.child, this.isAvoidBottomInset : false, this.closeAction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
          child: NerbPushAppBar(
          title: title, 
          action: closeAction,
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: isAvoidBottomInset,
      resizeToAvoidBottomPadding: isAvoidBottomInset,
      body: Builder(
        builder: (context) => WillPopScope(
          onWillPop: () async{
            if(closeAction != null){
              closeAction();
            }else{
              Navigator.of(context).pop();
            }
            return false;
          },
          child: child,
        ),
      ),
    );
  }
}