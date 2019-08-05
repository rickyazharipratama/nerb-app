import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/NerbNavigator.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Models/FirestoreCategory.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nerb/Views/Components/Images/ImagePlaceholder.dart';
import 'package:nerb/Views/Pages/PlacesByCategory.dart';

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
    return GestureDetector(
      onTap: (){
        NerbNavigator.instance.push(context,
          child: PlacesByCategory(
            category: widget.category,
            imageUrl: image,
          )
        );
      },
      child: Container(
        width: 220,
        height: 115,
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: Material(
            borderRadius: BorderRadius.circular(2),
            color: Theme.of(context).highlightColor,
            elevation: 2,
            shadowColor: ColorCollections.shimmerHighlightColor,
            child: Stack(
              children: <Widget>[

               Positioned.fill(
                 child: viewState == 0 ?
                 ClipRRect(
                   borderRadius: BorderRadius.circular(5),
                    child: Hero(
                      tag: widget.category.id,
                      child: CachedNetworkImage(
                        imageUrl: image,
                        fit: BoxFit.cover,
                        color: Color(0x77000000),
                        colorBlendMode: BlendMode.srcATop,
                        placeholder: (context,_)=> ImagePlaceholder(),
                        errorWidget: (context,_,__)=> ImagePlaceholder(),
                      ),
                    ),
                 ): ImagePlaceholder(),
               ),

               Positioned(
                 left: 0,
                 top: 0,
                 child: Padding(
                   padding: const EdgeInsets.only(left: 10, top: 10),
                   child: Hero(
                     tag: "icon-"+widget.category.id,
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
               ),

               Positioned(
                 left: 0,
                 right: 0,
                 bottom: 0,
                 child: Padding(
                   padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                   child: Hero(
                     tag: "title-"+widget.category.id,
                     child: Text(
                       UserLanguage.of(context).currentLanguage == ConstantCollections.LANGUAGE_ID ? widget.category.name.id : widget.category.name.en,
                       textAlign: TextAlign.left,
                       style: Theme.of(context).primaryTextTheme.subhead
                     ),
                   ),
                 ),
               )
              ],
            ),
          ),
      ),
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