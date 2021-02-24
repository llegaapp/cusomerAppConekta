import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';

//
// 02.10.2020 rtl
// 11.10.2020 radius and shadow
// 11.10.2020 callback add string image
//

class ICard20FileCaching extends StatefulWidget {
  final Color color;
  final Color colorProgressBar;
  final TextDirection direction;
  final double width;
  final double height;
  final String text;
  final String text2;
  final String text3;
  final String image;
  final Color colorRoute;
  final String id;
  final bool active;
  final TextStyle title;
  final TextStyle body;
  final Function(String id, String hero, String) callback;
  final Function(String id) callbackNavigateIcon;
  final double radius;
  final int shadow;

  ICard20FileCaching({this.color = Colors.white, this.width = 100, this.height = 100, this.colorProgressBar = Colors.black,
    this.text = "", this.text2 = "", this.image = "", this.colorRoute = Colors.black,
    this.id = "", this.active = true, this.title, this.body, this.callback, this.callbackNavigateIcon,
    this.text3 = "", this.direction,
    this.radius, this.shadow,
  });

  @override
  _ICard20FileCachingState createState() => _ICard20FileCachingState();
}

class _ICard20FileCachingState extends State<ICard20FileCaching>{

  var _titleStyle = TextStyle(fontSize: 16);
  var _bodyStyle = TextStyle(fontSize: 14);

  @override
  Widget build(BuildContext context) {
    
    if (widget.title != null)
      _titleStyle = widget.title;
    var colorFilter;

    if(widget.active == false){
        _titleStyle = TextStyle(fontSize: 16, color: theme.colorOfRestaurant, fontWeight: FontWeight.bold); 
        colorFilter = ColorFilter.mode(Colors.grey, BlendMode.color);
    }else{
      colorFilter= null;
    }
        

    var _id = UniqueKey().toString();
    
    if (widget.body != null)
      _bodyStyle = widget.body;
    return Container(
          margin: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
          width: widget.width-10+2,
          height: widget.height-20,
          decoration: BoxDecoration(
              color: widget.color,
              border: Border.all(color: Colors.black.withAlpha(100)),
              borderRadius: new BorderRadius.circular(widget.radius),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(widget.shadow),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(2, 2), // changes position of shadow
                ),
              ]
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded( child: InkWell(
                      onTap: () {
                        if (widget.callback != null)
                          widget.callback(widget.id, _id, widget.image);
                      }, // needed
                      child: Hero(
                          tag: _id,
                          child: Container(
                            width: widget.width-10,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(widget.radius), topRight: Radius.circular(widget.radius)),
                              child: Container(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  imageUrl: widget.image,
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        colorFilter: colorFilter,
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context,url,error) => new Icon(Icons.error),
                                ),
                              ),
                            ),
                          )
                      ))
                  ),

                  InkWell(
                      onTap: () {
                        if (widget.callback != null)
                          widget.callback(widget.id, _id, widget.image);
                      }, // needed
                      child: Container(
                        padding: EdgeInsets.only(left: 5, right: 5),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(widget.text, style: _titleStyle, overflow: TextOverflow.ellipsis,),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                Container(
                                width: widget.width-50,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                    Text(widget.text2, maxLines: 1, style: _bodyStyle, overflow: TextOverflow.ellipsis,),
                                    Text(widget.text3, style: _bodyStyle, overflow: TextOverflow.ellipsis,),
                                  ],)),
                                  Container(
                                      height: 30,
                                      width: 30,
                                      child: _route(widget.active)
                                  ),

                                ],
                      ),
                              SizedBox(height: 5,)
                            ],
                          ))),

                ],
              ),

//              if (widget.direction == TextDirection.ltr)
//                UnconstrainedBox(
//                    child: Container(
//                        margin: EdgeInsets.only(left: widget.width-70, top: widget.height-50),
//                        height: 40,
//                        width: 40,
//                        child: _route()
//                    )),
//
//              if (widget.direction == TextDirection.rtl)
//                UnconstrainedBox(
//                    child: Container(
//                        margin: EdgeInsets.only(right: widget.width-70, top: widget.height-55),
//                        height: 40,
//                        width: 40,
//                        child: _route()
//                    )),

            ],
          )




    );
  }

  _route(bool active){

    Widget imageroute =  Image.asset("assets/route.png",
          fit: BoxFit.cover, color: widget.colorRoute,
        );

    if(active == false)
       imageroute = Icon(Icons.visibility_off_outlined);
    

    return Stack(
      children: <Widget>[
        imageroute,
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  if (widget.callbackNavigateIcon != null)
                    widget.callbackNavigateIcon(widget.id);
                }, // needed
              )),
        )
      ],
    );
  }
}