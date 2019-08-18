import 'package:flutter/material.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Views/Components/misc/NerbPushAppBar.dart';


class BasePushPage extends StatefulWidget {

  final String title;
  final Widget child;
  final bool isAvoidBottomInset;
  final VoidCallback closeAction;
  BasePushPage({@required this.title, @required this.child, this.isAvoidBottomInset : false, this.closeAction});

  @override
  BasePushPageState createState() => BasePushPageState();
}
class BasePushPageState extends State<BasePushPage>{

  @override
  void initState() {
    super.initState();
    initiateData();
  }
    
  @override
  Widget build(BuildContext context) {
    CommonHelper.instance.forcePortraitOrientation();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
          child: NerbPushAppBar(
          title: widget.title, 
          action: widget.closeAction,
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: widget.isAvoidBottomInset,
      resizeToAvoidBottomPadding: widget.isAvoidBottomInset,
      body: Builder(
        builder: (context) => WillPopScope(
          onWillPop: () async{
            if(widget.closeAction != null){
              widget.closeAction();
            }else{
              Navigator.of(context).pop();
            }
            return false;
          },
          child: widget.child,
        ),
      ),
    );
  }

  initiateData()async{
    await CommonHelper.instance.checkMaintenance(context);
  }
}