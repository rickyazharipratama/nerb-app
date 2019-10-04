import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Models/FirestoreCategory.dart';
import 'package:nerb/PresenterViews/Components/Collections/Items/CategoryItemView.dart';
import 'package:nerb/Presenters/Components/Collections/Items/CategoryItemPresenter.dart';

class CategoryItem extends StatefulWidget {

  final FirestoreCategory category;
  final CategoryItemPresenter presenter = CategoryItemPresenter();

  CategoryItem({this.category}){
    presenter.setCategory = category;
  }

  @override
  _CategoryItemState createState() => new _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> with CategoryItemView{


  @override
  void initState() {
    super.initState();
    widget.presenter.setView = this;
  }

  @override
  BuildContext currentContext() => context;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        goToPlacesByCategory(widget.presenter.category);
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
                              size: 17,
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
                       UserLanguage.of(context).currentLanguage == ConstantCollections.LANGUAGE_ID ? widget.presenter.category.name.id : widget.presenter.category.name.en,
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