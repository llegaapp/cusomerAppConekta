import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';

//
// v2.0 08.10.2020
//      17.10.2020 - radius shadow
//

class ICard14FileCaching extends StatefulWidget {
  final Color color;
  final double width;
  final double height;
  final String image;
  final String id;
  final Color colorProgressBar;
  final Function(String id, String hero) callback; 
  final String ticketCode;
  final String text;
  final TextStyle textStyle;
  final String text2;
  final TextStyle textStyle2;
  final String text3;
  final TextStyle textStyle3;
  final String text4;
  final TextStyle textStyle4;
  final String text5;
  final TextStyle textStyle5;
  final String text6;
  final String text6Cancelado;
  final TextStyle textStyle6;
  final TextStyle textStyle7;
  final String heroId;

  final String image1;
  final String image2;
  final String image3;

  final double radius;
  final int shadow;

  ICard14FileCaching({this.color = Colors.white, this.width = 100, this.height = 100,
    this.id = "", this.callback, this.image = "",this.ticketCode = "",
    this.text = "",this.textStyle,
    this.text2 = "", this.textStyle2,
    this.text3 = "", this.textStyle3,
    this.text4 = "", this.textStyle4,
    this.text5 = "", this.textStyle5,
    this.text6 = "", this.text6Cancelado = "", this.textStyle6,this.textStyle7,
    this.image1, this.image2, this.image3,
    this.heroId, this.colorProgressBar,
    this.radius = 15, this.shadow = 10
  });

  @override
  _ICard14FileCachingState createState() => _ICard14FileCachingState();
}

class _ICard14FileCachingState extends State<ICard14FileCaching>{

  var _textStyle = TextStyle(fontSize: 16);
  var _textStyle2 = TextStyle(fontSize: 16);
  var _textStyle3 = TextStyle(fontSize: 16);
  var _textStyle4 = TextStyle(fontSize: 16);
  var _textStyle5 = TextStyle(fontSize: 10);
  var _textStyle6 = TextStyle(fontSize: 16);
  var _textStyle7 = TextStyle(fontSize: 13);
  var _image1 = '';
  var _image2 = '';
  var _image3 = '';

  @override
  Widget build(BuildContext context) {
    var _id = widget.heroId == null ? UniqueKey().toString() : widget.heroId;
    if (widget.textStyle != null)
      _textStyle = widget.textStyle;
    if (widget.textStyle2 != null)
      _textStyle2 = widget.textStyle2;
    if (widget.textStyle3 != null)
      _textStyle3 = widget.textStyle3;
    if (widget.textStyle4 != null)
      _textStyle4 = widget.textStyle4;
    if (widget.textStyle5 != null)
      _textStyle5 = widget.textStyle5;
    if (widget.textStyle6 != null)
      _textStyle6 = widget.textStyle6;
    if (widget.textStyle7 != null)
      _textStyle7 = widget.textStyle7;

    _image1 = widget.image1;
    _image2 = widget.image2;
    _image3 = widget.image3;

    var flex61 = 4;
    var flex62 = 6;
    if ( widget.text6Cancelado =='6'){ // si es cancelado
      flex61 = 10;
      flex62 = 0;
    }
    print('widget.text6Cancelado: '+widget.text6Cancelado);
    return InkWell(
        onTap: () {
      if (widget.callback != null)
        widget.callback(widget.id, _id);
    }, // needed
    child: Container(
          width: widget.width-10,
          height: widget.height,
          decoration: BoxDecoration(
              color: widget.color,
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
          child: Row(
            children: <Widget>[
            Hero(
            tag: _id,
            child: Container(
               
                  width: widget.width*0.3,
                  height: widget.height,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(widget.radius), bottomLeft: Radius.circular(widget.radius)),
                        child:Container(
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
                      )

                    ),
                  )
                )),

        SizedBox(width: 10,),
        InkWell(
                onTap: () {
                  if (widget.callback != null)
                    widget.callback(widget.id, _id);
                }, // needed
                child: Container(
                  width: widget.width*0.6,
                  height: widget.height,
                  //margin: EdgeInsets.only(top: 5, left: widget.width*0.3+5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(height: 5,),
                      Row(children: [
                        Expanded(child: Text('Ticket  '+ widget.ticketCode, style: _textStyle5, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,)),  // name
                        Text(widget.text5, style: _textStyle7, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,)
                      ],),
                      SizedBox(height: 3,),
                      Text(widget.text, style: _textStyle, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,),

                      Row(children: [
                        Expanded(flex: 8 , child: Text(widget.text2, style: _textStyle2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,),),
                        Expanded( flex: 2 , child: _image_2(_image2) ),  // name
                      ],),
                      // _image

                      Row(children: [
                        Expanded( flex: flex61 , child: Text(widget.text6, style: _textStyle3, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,), ),
                        Expanded( flex: flex62 , child: _image(_image1) ),  // name
                      ],),  
                      Row(children: [
                        Expanded(flex: 5, child: Text(widget.text3, style: TextStyle(
                          color: theme.colorHeaderPedidos,
                          fontSize: 10,
                          fontFamily: 'Avenir Light',
                          fontStyle: FontStyle.normal
                        ), overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,), ),  // name
                        Expanded(flex: 1, child: _image_3(_image3)),  // name
                        Expanded(flex: 4 , child: Text(widget.text4, style: _textStyle4, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end,)),  // name
                      ],),
                      SizedBox(height: 3,)
                    ],
                  ),
                  )),

            ],
          ),
    ));
  }
  Widget _image(String image){
    print('image '+image);
    if(image!=''){
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[ Image.asset( image ,
        // fit: BoxFit.contain,
        height: 25,
        width: 25,
      )]);

    }else{
      return  Text('');

    }
  }
  Widget _image_3(String image){
    print('image '+image);
    if(image!=''){
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[ Image.asset( image ,
        // fit: BoxFit.contain,
        height: 15,
        width: 15,
      )]);

    }else{
      return  Text('');

    }
  }
  Widget _image_2(String image){
    print('image '+image);
    if(image!=''){
      return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[ Image.asset( image ,
        // fit: BoxFit.contain,
        height: 25,
        // width: 35,
      )]);

    }else{
      return  Text('');

    }
  }
}