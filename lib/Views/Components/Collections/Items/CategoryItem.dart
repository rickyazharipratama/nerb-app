import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/FontSizeHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Models/FirestoreCategory.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nerb/Views/Components/Images/ImagePlaceholder.dart';

class CategoryItem extends StatefulWidget {

  final FirestoreCategory category;

  CategoryItem({this.category});

  @override
  _CategoryItemState createState() => new _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {


  String image = "";
  int viewState = 1;

  @override
  void initState() {
    super.initState();
    retrieveImage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 113,
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Hero(
        tag: widget.category.id,
        child: Material(
          borderRadius: BorderRadius.circular(5),
          color: ColorCollections.placeholderCategory,
          elevation: 2,
          shadowColor: ColorCollections.shimmerHighlightColor,
          child: Stack(
            children: <Widget>[

             Positioned.fill(
               child: viewState == 0 ?
               ClipRRect(
                 borderRadius: BorderRadius.circular(5),
                 child: CachedNetworkImage(
                   imageUrl: image,
                   fit: BoxFit.cover,
                   color: ColorCollections.wrapperCategory,
                   colorBlendMode: BlendMode.srcATop,
                   placeholder: (context,_)=> ImagePlaceholder(),
                   errorWidget: (context,_,__)=> ImagePlaceholder(),
                 ),
               ): ImagePlaceholder(),
             ),

             Positioned(
               left: 0,
               top: 0,
               child: Padding(
                 padding: const EdgeInsets.only(left: 10, top: 10),
                 child: Container(
                   width: 30,
                   height: 30,
                   decoration: BoxDecoration(
                     color: ColorCollections.wrapCategoryIcon,
                     borderRadius: BorderRadius.circular(15)
                   ),
                   child: Center(
                     child: widget.category.icon != null ?
                        Image.asset(
                          "assets/"+widget.category.icon,
                          fit: BoxFit.fitHeight,
                          width: 15,
                          height: 15,
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
             ),

             Positioned(
               left: 0,
               right: 0,
               bottom: 0,
               child: Padding(
                 padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                 child: Text(
                   UserLanguage.of(context).currentLanguage == ConstantCollections.LANGUAGE_ID ? widget.category.name.id : widget.category.name.en,
                   textAlign: TextAlign.left,
                   style: TextStyle(
                     color: ColorCollections.titleWhite,
                     fontWeight: FontWeight.w500,
                     fontSize: FontSizeHelper.titleList(scale : MediaQuery.of(context).textScaleFactor)
                   ),
                 ),
               ),
             )

            ],
          ),
        ),
      )
    );
  }

  retrieveImage() async{
    String uri = await  FirebaseStorage
      .instance
      .ref()
      .child(widget.category.imageStorage.replaceAll(ConstantCollections.FIREBASE_STORAGE_URL, ""))
      .getDownloadURL();
    if(mounted){
      setState((){
        image = uri != null ? uri : "";
        viewState = 0;
      });
    }
  }
}