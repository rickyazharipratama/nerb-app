import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/NerbTheme.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Models/FirestoreCategory.dart';
import 'package:nerb/Views/Components/Collections/WrapperPlacesByCategory.dart';
import 'package:nerb/Views/Components/Images/ImagePlaceholder.dart';

class PlacesByCategory extends StatefulWidget {

  final String imageUrl;
  final FirestoreCategory category;

  PlacesByCategory({@required this.imageUrl, @required this.category});

  @override
  _PlacesByCategoryState createState() => new _PlacesByCategoryState();
}

class _PlacesByCategoryState extends State<PlacesByCategory> {

  String image;

  @override
  void initState() {
    super.initState();
    image = widget.imageUrl;
    initiateData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.of(context).pop();
        return false;
      },
      child: Material(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height / 2,
              child: Stack(
                children: <Widget>[
                  
                  Positioned.fill(
                    child: Hero(
                      tag: widget.category.id,
                      child: image != null ? CachedNetworkImage(
                        imageUrl: widget.imageUrl,
                        fit: BoxFit.cover,
                        color: Color(0x77000000),
                        colorBlendMode: BlendMode.srcATop,
                        placeholder: (context,_)=> ImagePlaceholder(),
                        errorWidget: (context,_,__)=> ImagePlaceholder(),
                      ) : ImagePlaceholder(),
                    )
                  ),

                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[

                          Hero(
                            tag: "icon-"+widget.category.id,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: ColorCollections.wrapCategoryIcon,
                                borderRadius: BorderRadius.circular(25)
                              ),
                              child: Center(
                                child: widget.category.icon != null ?
                                    Image.asset(
                                      "assets/"+widget.category.icon,
                                      fit: BoxFit.fitHeight,
                                      width: 25,
                                      height: 25,
                                      color: Colors.black,
                                      colorBlendMode: BlendMode.srcIn,
                                    )
                                    : Icon(
                                      Icons.landscape,
                                      size: 25,
                                      color: ColorCollections.titleColor,
                                    ),
                              ),
                            ),
                          ),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Hero(
                                tag: "title-"+widget.category.id,
                                child: Text(
                                  UserLanguage.of(context).currentLanguage == ConstantCollections.LANGUAGE_ID ? widget.category.name.id : widget.category.name.en,
                                  style: Theme.of(context).textTheme.title,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            Positioned(
              top: (MediaQuery.of(context).size.height /2),
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Theme.of(context).backgroundColor,
                      offset: Offset(0,-5),
                      spreadRadius: 5
                    ),
                    BoxShadow(
                      blurRadius: 10,
                      color: Theme.of(context).brightness == Brightness.dark ? NerbTheme.instance.backDarkGradient[1] : NerbTheme.instance.backLightGradient[1],
                      offset: Offset(0,-15),
                      spreadRadius: 5
                    ),
                  ]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: WrapperPlacesBycategory(
                    category: widget.category.id,
                  ),
                ),
              ),
            ),

            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 10,
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons. close,
                  color: Colors.red,
                  size: 25,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  initiateData() async{
    if(image == null){
      String uri = await FirebaseStorage
        .instance
        .ref()
        .child(widget.category.imageStorage.replaceAll(ConstantCollections.FIREBASE_STORAGE_URL,""))
        .getDownloadURL();
      if(mounted){
        setState(() {
          image = uri;
        });
      }
    }
  }

}