import 'package:flutter/material.dart';
import 'package:nerb/Models/PlaceModel.dart';
import 'package:nerb/Views/Components/Collections/Items/PlaceItem.dart';

class EditPlaceItem extends StatefulWidget {

  final PlaceModel place;
  final String language;
  final ValueChanged onDeleteClick;

  EditPlaceItem({this.place, this.language,this.onDeleteClick});

  @override
  _EditPlaceItemState createState() => new _EditPlaceItemState();
}

class _EditPlaceItemState extends State<EditPlaceItem> with SingleTickerProviderStateMixin{

  AnimationController animController;
  Animation anim;
  
  @override
  void initState() {
    super.initState();
    animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    anim = Tween<double>(begin: -0.02 , end: 0.02).animate(CurvedAnimation(
      parent: animController,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut
    ))..addListener((){
      if(mounted){
        setState((){
          
        });
      }
    })..addStatusListener((status){
      if(status == AnimationStatus.completed){
        animController.reverse();
      }else if(status == AnimationStatus.dismissed){
        animController.forward();
      }
    });
    animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: anim.value,
      child: Container(
        width: 65,
        height: 90,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: PlaceItem(place: widget.place, callback: (place){}, language: widget.language),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: (){
                  widget.onDeleteClick(widget.place);
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle
                  ),
                  child: Center(
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 10,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }
}