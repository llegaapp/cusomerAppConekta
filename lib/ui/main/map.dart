import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/model/server/mainwindowdata.dart';
import 'package:fooddelivery/model/topRestourants.dart';
import 'package:fooddelivery/ui/main/home.dart';
import 'package:fooddelivery/widget/ICard20FileCaching.dart';
import 'package:fooddelivery/widget/wmap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapScreen extends StatefulWidget {
  final Function(String) callback;
  final Color color;
  MapScreen({this.color = Colors.black, this.callback});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //

  _onTopRestaurantClick(String id, String heroId, String image){
    print("User pressed Top Restaurant with id: $id");

    idHeroes = UniqueKey().toString();
    idRestaurant = id;
    route.setDuration(1);
    route.push(context, "/restaurantdetails");

    // idRestaurantOnMap = id;
    // markers.clear();
    // _addMarkers();
    // _navigateToMap();
  }

  _onTopRestaurantNavigateIconClick(String id){
    print("User pressed Top Restaurant Route icon with id: $id");
    idRestaurantOnMap = id;
    // markers.clear();
    markers = {};
    _addMarkers();
    _navigateToMap();
    setState(() {

    });
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  String _mapStyle;

  // _initCameraPosition() async{
  //   Position pos = await homeScreen.location.getCurrent();
  //   _controller?.animateCamera(
  //   CameraUpdate.newCameraPosition(
  //     CameraPosition(
  //       bearing: _bearing,
  //       target: LatLng(pos?.latitude, pos?.longitude),
  //       zoom: 13,
  //     ),
  //   ));
  // }

  @override
  void initState() {
    //_initCameraPosition();
    _addMarkers();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(appSettings.defaultLat, appSettings.defaultLng), zoom: appSettings.defaultZoom,); // paris coordinates
  Set<Marker> markers = {};
  GoogleMapController _controller;
  double _currentZoom = 12;

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    if (_controller != null)
      if (theme.darkMode)
        _controller.setMapStyle(_mapStyle);
      else
        _controller.setMapStyle(null);

    return Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+50),
        child: Stack(children: <Widget>[

          _map(),

          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15,),
                  buttonPlus(_onMapPlus),
                  buttonMinus(_onMapMinus),
                  buttonMyLocation(_getCurrentLocation),
                ],
              )
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                margin: EdgeInsets.only(bottom: 70),
                child: _horizontalTopRestaurants()
            ),
          )


      ]
        )
    );
  }

  _getCurrentLocation() async {
    var position = await homeScreen.location.getCurrent();
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: _currentZoom,
        ),
      ),
    );
  }

  _map(){
    return GoogleMap(
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false, // Whether to show zoom controls (only applicable for Android).
        myLocationEnabled: true,  // For showing your current location on the map with a blue dot.
        myLocationButtonEnabled: false, // This button is used to bring the user location to the center of the camera view.
        initialCameraPosition: _kGooglePlex,
        onCameraMove:(CameraPosition cameraPosition){
          _currentZoom = cameraPosition.zoom;
        },
        onTap: (LatLng pos) {

        },
        onLongPress: (LatLng pos) {

        },
        markers: markers != null ? Set<Marker>.from(markers) : null,
        circles: circles,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          if (theme.darkMode)
            _controller.setMapStyle(_mapStyle);
          if (idRestaurantOnMap != null)
            _navigateToMap();
        });
  }

  _onMapPlus(){
    _controller?.animateCamera(
      CameraUpdate.zoomIn(),
    );
  }

  _onMapMinus(){
    _controller?.animateCamera(
      CameraUpdate.zoomOut(),
    );
  }

  _getDistanceText(Restaurants item){
    var _dist = "";
    if (item.distance != -1) {
      if (appSettings.distanceUnit == "km") {
        if (item.distance <= 1000)
          _dist = "${item.distance.toStringAsFixed(0)} m";
        else
          _dist = "${(item.distance / 1000).toStringAsFixed(0)} km";
      }else{                // miles
        if (item.distance < 1609.34) {
          _dist = "${(item.distance/1609.34).toStringAsFixed(3)} miles";
        }else
          _dist = "${(item.distance / 1609.34).toStringAsFixed(0)} miles";
      }
    }
    return _dist;
  }

  _horizontalTopRestaurants(){
    var list = List<Widget>();
    var height = windowWidth*appSettings.restaurantCardHeight/100;
    for (var item in nearYourRestaurants) {
      var _dist = _getDistanceText(item);
      list.add(Stack(
        children: [
          ICard20FileCaching(
            shadow: appSettings.shadow,
            radius: appSettings.radius,
            color: theme.colorBackground,
            text: item.name,
            text2: item.address,
            width: windowWidth * appSettings.restaurantCardWidth/100,
            height: height,
            image: item.image,
            text3: _dist,
            colorRoute: theme.colorPrimary,
            id: item.id,
            title: theme.text18boldPrimaryUI,
            body: theme.text16UI,
            callback: _onTopRestaurantClick,
            callbackNavigateIcon: _onTopRestaurantNavigateIconClick,
          ),
          Container(
              height: 40,
              margin: EdgeInsets.only(left: 20, right: 10),
              width: windowWidth * appSettings.restaurantCardWidth/100-30,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black.withAlpha(120)),
                borderRadius: BorderRadius.circular(10),
              ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              Container(
                margin: EdgeInsets.all(5),
                child: _route(item.id),
              ),
          Checkbox(
              value: item.areaShowOnMap,
              activeColor: theme.colorPrimary,
              onChanged: (bool value){ //
                item.areaShowOnMap = value;
                if (value)
                  _setCircle(item);
                else
                  _deleteCircle(item);
                setState(() {});
              }
          ),
          Expanded(
              child: Text(strings.get(275), style: theme.text14, overflow: TextOverflow.clip,)) // "Show Delivery Area",
            ],)
          ),
        ],
      ));
      list.add(SizedBox(width: 10,));
    }
    return Container(
      height: height+20,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: list,
      ),
    );
  }


  _route(String id){
    return Stack(
      children: <Widget>[
        Image.asset("assets/route.png",
          fit: BoxFit.cover, color: theme.colorPrimary,
        ),
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  _onTopRestaurantNavigateIconClick(id);
                }
              )),
        )
      ],
    );
  }

  _addMarkers(){
    for (var item in nearYourRestaurants) {
      // if (idRestaurantOnMap != null) {
      //   if (item.id == idRestaurantOnMap) {
      //     _addMarker(item);
      //     break;
      //   }
      // }else
        _addMarker(item);
    }
  }

  MarkerId _lastMarkerId;

  _addMarker(Restaurants item){
    var _dist = _getDistanceText(item);
    print("add marker ${item.id}");
    var _lastMarkerId2 = MarkerId(item.id);
    if (idRestaurantOnMap == item.id)
      _lastMarkerId = _lastMarkerId2;
    dprint("_lastMarkerId=$_lastMarkerId");
    final marker = Marker(
          markerId: _lastMarkerId2,
          position: LatLng(
              item.lat, item.lng
          ),
          infoWindow: InfoWindow(
            title: item.name,
            snippet: _dist,
            onTap: () {
              idHeroes = UniqueKey().toString();
              idRestaurant = item.id;
              route.setDuration(1);
              route.push(context, "/restaurantdetails");
            },
            //snippet: id,
          ),
          //icon: myIcon,
          onTap: () {

          }
      );
      markers.add(marker);
      dprint("marker add ${marker.markerId.value}");
  }
  var _bearing = 0.0;

  _navigateToMap(){
    for (var item in nearYourRestaurants)
        if (item.id == idRestaurantOnMap) {
          _controller.showMarkerInfoWindow(_lastMarkerId);
          _controller.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  bearing: _bearing,
                  target: LatLng(item.lat, item.lng),
                  zoom: _currentZoom,
                ),
              )

          );
        }
  }

  Set<Circle> circles = Set.from([]);

  _deleteCircle(Restaurants rest) {
    circles.removeWhere((item) => item.circleId.value  == rest.id);
  }

  _setCircle(Restaurants item){
    var t = item.area*1000/2;
    if (t < 0) t = 1;
    circles.add(Circle(
      circleId: CircleId(item.id),
      center: LatLng(item.lat, item.lng),
      radius: t,
      fillColor: theme.colorPrimary.withAlpha(30),
      strokeColor: theme.colorPrimary.withAlpha(60)

    ));
  }
}