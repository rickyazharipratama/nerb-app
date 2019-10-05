import 'package:flutter/material.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/PresenterViews/Components/Miscs/RadiusView.dart';
import 'package:nerb/Presenters/Components/Misc/RadiusPresenter.dart';

class Radius extends StatefulWidget {

  Radius();
  
  @override
  _RadiusState createState() => new _RadiusState();
}

class _RadiusState extends State<Radius> with RadiusView{
  RadiusPresenter presenter;

  @override
  void initState() {
    super.initState();
    presenter = RadiusPresenter();
    presenter.setView = this;
    presenter.initiateData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          Text(
            UserLanguage.of(context).label('radius'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).primaryTextTheme.subtitle
          ),

          Padding(
            padding: const EdgeInsets.only(top: 5 ,bottom: 10),
            child: Text(
              UserLanguage.of(context).desc("radiusSetting"),
              style: Theme.of(context).primaryTextTheme.body1
            ),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Text(
                "100 M",
                style: Theme.of(context).primaryTextTheme.body1
              ),

              Expanded(
                child: Slider(
                  value: presenter.radius.toDouble(),
                  activeColor: Theme.of(context).buttonColor,
                  inactiveColor: Theme.of(context).highlightColor,
                  label: presenter.radius.toString()+" m",
                  min: 100,
                  max: 1000,
                  onChanged: presenter.onChanged,
                  onChangeEnd: presenter.onValueChangeEnd,
                ),
              ),

              Text(
                "1 KM",
                style: Theme.of(context).primaryTextTheme.body1
              ),
            ],
          ),

          Center(
            child: Text(
              presenter.radius == 1000 ? "1 KM": presenter.radius.toString()+" M",
              textAlign: TextAlign.center,
              style: Theme.of(context).primaryTextTheme.subhead
            ),
          )
        ],
      ),
    );
  }

  @override
  notifyState(){
    if(mounted){
      setState(() {
        
      });
    }
  }
}