import 'package:flutter/material.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';

class Radius extends StatefulWidget {

  Radius();
  
  @override
  _RadiusState createState() => new _RadiusState();
}

class _RadiusState extends State<Radius> {

  int rad = 0;

  @override
  void initState() {
    super.initState();
    initiateData();
  }

  initiateData() async{
    rad = await PreferenceHelper.instance.getIntValue(key: ConstantCollections.PREF_RADIUS);
    if(mounted){
      setState(() { 
      });
    }
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
                  value: rad.toDouble(),
                  activeColor: Theme.of(context).buttonColor,
                  inactiveColor: Theme.of(context).highlightColor,
                  label: rad.toString()+" m",
                  min: 100,
                  max: 1000,
                  onChanged: onChanged,
                  onChangeEnd: onValueChangeEnd,
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
              rad == 1000 ? "1 KM": rad.toString()+" M",
              textAlign: TextAlign.center,
              style: Theme.of(context).primaryTextTheme.subhead
            ),
          )

        ],
      ),
    );
  }

  onChanged(double val){
    if(mounted){
      setState(() {
        rad  = val.floor();
      });
    }
  }

  onValueChangeEnd(double val){
    PreferenceHelper.instance.setIntValue(key: ConstantCollections.PREF_RADIUS, value: rad);
  }
}