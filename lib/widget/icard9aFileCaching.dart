import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//      17.10.2020 - radius shadow
//      19.11

class ICard9aFileCaching extends StatefulWidget {
  final Color color;
  final Color colorArrows;
  final Color colorBorder;
  final double width;
  final double height;
  final String title1;
  final TextStyle title1Style;
  final TextStyle title2Style;
  final String price;
  final TextStyle priceTitleStyle;
  final String image;
  final Function(String) press;
  final Function(String) delete;
  final Function(String, int) incDec;
  final Function(String) getCount;
  final String id;
  final String heroTag;
  final int count;
  final Color colorProgressBar;
  final double radius;
  final int shadow;

  ICard9aFileCaching({this.color = Colors.grey, this.price = "", this.priceTitleStyle, this.title1 = "", this.title1Style,
    this.title2Style, this.press, this.id, this.count = 1, this.colorArrows = Colors.black, this.colorBorder = Colors.white,
    this.colorProgressBar = Colors.black, this.getCount, this.delete,
    this.image, this.width = 100, this.heroTag, this.incDec, this.height = 120,
    this.radius, this.shadow});

  @override
  ICard9aFileCachingState createState() {
    return ICard9aFileCachingState();
  }
}

class ICard9aFileCachingState extends State<ICard9aFileCaching>{

  Widget _image = Container();
  var _title1Style = TextStyle(fontSize: 16);
  var _title2Style = TextStyle(fontSize: 16);
  var _priceTitleStyle = TextStyle(fontSize: 16);

  String _heroTag = UniqueKey().toString();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.title1Style != null)
      _title1Style = widget.title1Style;
    if (widget.title2Style != null)
      _title2Style = widget.title2Style;
    if (widget.priceTitleStyle != null)
      _priceTitleStyle = widget.priceTitleStyle;
    if (widget.image != null)
      _image = ClipRRect(
          borderRadius: new BorderRadius.only(topLeft: Radius.circular(widget.radius)),
          child: Container(
        child: CachedNetworkImage(
          placeholder: (context, url) =>
              CircularProgressIndicator(),
          imageUrl: widget.image,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          errorWidget: (context,url,error) => new Icon(Icons.error),
        ),
      ));

    if (widget.heroTag != null)
      _heroTag = widget.heroTag;

    return Container(
      child: _item2(),
    );
  }

  _item2(){
    return InkWell(
        onTap: () {
          if (widget.press != null)
            widget.press(widget.id);
        }, // needed
        child:Container(
//          decoration: BoxDecoration(
//              color: widget.color,
//              border: Border.all(color: Colors.black.withAlpha(100)),
//              borderRadius: new BorderRadius.circular(widget.radius),
//              boxShadow: [
//                BoxShadow(
//                  color: Colors.grey.withAlpha(widget.shadow),
//                  spreadRadius: 2,
//                  blurRadius: 2,
//                  offset: Offset(2, 2), // changes position of shadow
//                ),
//              ]
//          ),
          child: Row(
            children: <Widget>[
              UnconstrainedBox(
                  child: Container(
                      height: widget.height,
                      width: widget.width*0.30,
                      child: Hero(
                          tag: _heroTag,
                          child: _image)
                  )),

              SizedBox(width: 10,),
              Expanded(child: Container(
                  height: widget.height,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(child: Text(widget.title1, style: _title1Style, maxLines: 3,), ),
                      Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: UnconstrainedBox(
                                child: Container(
                                    height: 25,
                                    color: widget.colorProgressBar.withAlpha(100),
                                    width: 25,
                                    child: Icon(
                                      Icons.delete_outline,
                                      color: Colors.white,
                                      size: 20,
                                    )
                                )),
                            ),

                          Positioned.fill(
                            child: Material(
                                color: Colors.transparent,
                                shape: CircleBorder(),
                                clipBehavior: Clip.hardEdge,
                                child: InkWell(
                                  splashColor: Colors.grey[400],
                                  onTap: (){
                                    setState(() {
                                      if (widget.delete != null)
                                        widget.delete(widget.id);
                                    });
                                  }, // needed
                                )),
                          )

                            ],

                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text(widget.price, style: _priceTitleStyle,)),    // price
                          _plusMinus(),
                          SizedBox(width: 10,)
                        ],
                      )
                    ],
                  )))
            ],
          ),
        ));
  }

  _plusMinus(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [

          Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: UnconstrainedBox(
                    child: Container(
                        height: 25,
                        color: widget.colorProgressBar,
                        width: 25,
                        child: Icon(
                          Icons.keyboard_arrow_up,
                          color: Colors.white,
                          size: 20,
                        )
                    )),
              ),
              Positioned.fill(
                child: Material(
                    color: Colors.transparent,
                    shape: CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Colors.grey[400],
                      onTap: (){
                        setState(() {
                          if (widget.incDec != null)
                            widget.incDec(widget.id, widget.getCount(widget.id)+1);
                        });
                      }, // needed
                    )),
              )
            ],
          ),

          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Text(widget.getCount(widget.id).toString(),
                textAlign: TextAlign.left,
                style: _title2Style
            ),
          ),

          Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: UnconstrainedBox(
                    child: Container(
                        height: 25,
                        color: widget.colorProgressBar,
                        width: 25,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 20,
                        )
                    )),
              ),
              Positioned.fill(
                child: Material(
                    color: Colors.transparent,
                    shape: CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Colors.grey[400],
                      onTap: (){
                        if (widget.getCount(widget.id) > 1) {
                          setState(() {
                            if (widget.incDec != null)
                              widget.incDec(widget.id, widget.getCount(widget.id)-1);
                          });
                        }
                      }, // needed
                    )),
              )
            ],
          ),
      ],
    );
  }
}