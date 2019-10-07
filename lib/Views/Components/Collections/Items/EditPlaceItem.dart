import 'package:flutter/material.dart';
import 'package:nerb/Models/PlaceModel.dart';
import 'package:nerb/PresenterViews/Components/Collections/Items/EditPlaceItemView.dart';
import 'package:nerb/Presenters/Components/Collections/Items/EditPlaceItemPresenter.dart';
import 'package:nerb/Views/Components/Collections/Items/PlaceItem.dart';

class EditPlaceItem extends StatefulWidget {

  final PlaceModel place;
  final ValueChanged onDeleteClick;

  EditPlaceItem({this.place, @required this.onDeleteClick});

  @override
  _EditPlaceItemState createState() => new _EditPlaceItemState();
}

class _EditPlaceItemState extends State<EditPlaceItem> with SingleTickerProviderStateMixin,EditPlaceItemView{

  EditPlaceItemPresenter presenter = EditPlaceItemPresenter();

  @override
  void initState() {
    super.initState();
    presenter.setView = this;
    presenter.setPlace = widget.place;
    presenter.setOnDeleteClick = widget.onDeleteClick;
    presenter.initiateData();
    setAnimController(this);
  }

  @override
  notifyState() {
    if(mounted){
      setState(() {
        
      });
    }
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
              child: PlaceItem(place: presenter.place, callback: (place){}),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: (){
                  presenter.onDeleteClick(presenter.place);
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