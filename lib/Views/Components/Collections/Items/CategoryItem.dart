import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/NerbNavigator.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Models/FirestoreCategory.dart';
import 'package:nerb/Views/Components/Images/ImagePlaceholder.dart';
import 'package:nerb/Views/Components/misc/NerbCacheImage.dart';
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
                 child: Hero(
                    tag: widget.category.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(
                        widget.category.imageStorage,
                        height: 115,
                        width: 220,
                        fit: BoxFit.cover,
                        color: ColorCollections.wrapperCategory,
                        colorBlendMode: BlendMode.srcATop,
                      ),
                    )
                 ),
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
                            Icon(
                              IconData(int.parse(widget.category.icon),fontFamily: 'MaterialIcons'),
                              size: 25,
                              color: ColorCollections.titleColor,
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
                       style: Theme.of(context).textTheme.headline
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
}