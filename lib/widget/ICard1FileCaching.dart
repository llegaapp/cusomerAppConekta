import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/widget/ilabelWithIcon.dart';
import 'package:fooddelivery/widget/iline.dart';

//
// 03.10.2020 v2
// 11.10.2020 radius
//

class ICard1FileCaching extends StatefulWidget {
  final Color color;
  final String title;
  final Color colorProgressBar;
  final TextStyle titleStyle;
  final String date;
  final TextStyle dateStyle;
  final String text;
  final TextStyle textStyle;
  final String userAvatar;
  final double rating;
  final double radius;
  final Function(String) delete;
  final String id;
  final String userName;

  ICard1FileCaching({this.color = Colors.grey, this.text = "", this.textStyle, this.title = "", this.titleStyle,
    this.colorProgressBar = Colors.black,
    this.date = "", this.dateStyle, this.userAvatar, this.rating = 5,
    this.radius,this.delete,this.id,this.userName
  });

  @override
  _ICard1FileCachingState createState() => _ICard1FileCachingState();
}

class _ICard1FileCachingState extends State<ICard1FileCaching> {
  @override
  Widget build(BuildContext context) {
    var _titleStyle = TextStyle(fontSize: 16);
    if (widget.titleStyle != null)
      _titleStyle = widget.titleStyle;
    var _textStyle = TextStyle(fontSize: 16);
    if (widget.textStyle != null)
      _textStyle = widget.textStyle;
    var _dateStyle = TextStyle(fontSize: 16);
    if (widget.dateStyle != null)
      _dateStyle = widget.dateStyle;

    var _avatar = Container();
    try {
      _avatar = Container(
        width: 30,
        height: 30,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            child: CachedNetworkImage(
              placeholder: (context, url) =>
                  CircularProgressIndicator(),
              imageUrl: widget.userAvatar,
              imageBuilder: (context, imageProvider) =>
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              errorWidget: (context, url, error) => new Icon(Icons.error, color: widget.colorProgressBar,),
            ),
          ),
        ),
      );
    } catch(_){

    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              _avatar,
            SizedBox(width: 10,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.title, style: _titleStyle,),
                  Row(
                    children: <Widget>[
                      UnconstrainedBox(
                          child: Container(
                              height: 20,
                              width: 20,
                              child: Image.asset("assets/date.png",
                                  fit: BoxFit.contain
                              )
                          )),
                      SizedBox(width: 10,),
                      Text(widget.date, style: _dateStyle, textAlign: TextAlign.start,),
                    ],
                  )
                ],
              ),
            ),
              
              Row(
                children: [
                  ILabelIcon(radius: widget.radius, text: widget.rating.toStringAsFixed(1), color: Colors.white, colorBackgroud: widget.color,
                    icon: Icon(Icons.star_border, color: Colors.white,),),
                  
                   _deleteBtn(), 
                  
                ],
              ),

            ],
          ),
          Text(widget.text, style: _textStyle, textAlign: TextAlign.start,),
          ILine(),
        ],
      ),
    );
  }

  Widget _deleteBtn()
  {
    if(widget.userName == widget.title)
         return Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: UnconstrainedBox(
                                child: Container(
                                    height: 30,
                                    color: Colors.redAccent,
                                    width: 30,
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

                          );

    return Container();
  }
}