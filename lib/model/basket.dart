import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/server/addToBasket.dart';
import 'package:fooddelivery/model/server/basketReset.dart';
import 'package:fooddelivery/model/server/deleteFromBasket.dart';
import 'package:fooddelivery/model/server/getBasket.dart';
import 'package:fooddelivery/model/server/mainwindowdata.dart';
import 'package:fooddelivery/model/server/setCountinBasket.dart';
import 'package:fooddelivery/model/utils.dart';
import 'dprint.dart';
import 'homescreenModel.dart';

class Basket{
  List<DishesData> basket = [];
  double taxes = 0.0;
  String restaurant;
  String orderid;
  String ticketCode;
  double fee = 0.0;
  String _percentage;
  String defCurrency = "";
  Coupon _coupon;

  init(OrderData order, List<OrderDetailsData> orderdetails, String currency, double defaultTax, String _fee, String percentage){
    fee = double.parse(_fee);
    defCurrency = currency;
    _percentage = percentage;
    orderid = order.id;
    restaurant = order.restaurant;
    ticketCode = order.ticketCode;
    taxes = defaultTax;
    basket.clear();
    for (var item in orderdetails){
      if (item.count != 0)
        basket.add(
           // this.price,  this.precioUnit,  this.taxFood, this.tax,
          DishesData(
            image: item.image,
            name: item.food,
            price: item.foodprice,
            precioUnit: item.foodprecioUnit,
            taxFood: item.foodtax,
            tax: item.foodtax,
            id: item.foodid,
            idDetails: item.id,
            hashid: item.hashid,
            desc: "",
            ingredients: null,
            nutritions: null,
            restaurantName: "",
            restaurant: order.restaurant,
            restaurantPhone: "",
            restaurantMobilePhone: "",
            extras: List<Extras>(),
            foodsreviews: null,
            // currency: currency,
            delivered: true,
            count: item.count,
            category: item.category,
        ));
      else{   // extras add
        var extras = Extras(id: item.id, desc: "", name: item.extras, image: item.image,
            price: double.parse(item.extrasprice),
            precioUnit: double.parse(item.extrasprecioUnit),
            taxFood: double.parse(item.extrastaxFood),
            tax: double.parse(item.extrastax),
            select: true);

                   // Extras({this.id, this.name, this.desc, this.price, this.precioUnit, this.taxFood,this.tax, this.image, this.select = false});
        for (var i in basket)
          if (i.id == item.foodid)
            i.extras.add(extras);
      }
    }
  }

  bool restaurantCheck(String id){
    for (var item in basket)
      if (item.count != 0)
        if (item.restaurant != id)
          return false;
      return true;
  }

  bool dishInBasket(DishesData dish){
    
    for (var item in basket){
      if (item.count != 0)
        if (item.id == dish.id){   
           
          String permutation = '';
          for (var extra in item.extras)
          { 
             if(extra.select)
               permutation = permutation + '1';
             else{
               permutation = permutation + '0';
             } 
            
          }
          
          String permutation2 = '';
          for (var extra in dish.extras)
          { 
            if(extra.select)
              permutation2 = permutation2 + '1';
            else{
              permutation2 = permutation2 + '0';
            }      
          }

          if(permutation == permutation2)
            return true;

        } 
     
    }
 

    return false;
  }


  int inBasket(){
    var lenght = 0;
    for (var item in basket)
      if (item.count != 0)
        lenght++;
    return lenght;
  }

  reset(Function callback){
    basketReset(account.token, () {
      basket.clear();
      _coupon = null;
      callback();
    }, (String _) {});
  }

  delete(DishesData item){
    deleteFromBasket(account.token, orderid, item.id,item.hashid, () {
        }, (String _) {});
  }

  add(DishesData item){
    item.hashid = sha1Ticketcode(limit:14);
    var t = DishesData().from(item);
    basket.add(t);
    restaurant = t.restaurant;
    String ticketCode = sha1Ticketcode();
    addToBasket(basket, account.token, '10', "hint", restaurant, "Cash on Delivery", "0", "0",
        "", "",  0.0, "0.0", "0.0", "false", "", "0.0",ticketCode,
        (String id, String _fee, String percent) {
          fee = double.parse(_fee);
          _percentage = percent;
          orderid = id;
          for (var item in basket)
            item.delivered = true;
        }, (String _) {});
  }

  deleteFrmBasket(String id){
    DishesData _current;
    for (var d in basket)
      if (d.hashid == id) {
        delete(d);
        d.count = 0;
        _current = d;
        break;
      }
    if (_current != null)
      basket.remove(_current);
  }

  setCount(String id, int value){
    for (var d in basket)
      if (d.hashid == id) {
        d.count = value;
        setCountInBasket(account.token, orderid, d.id, d.hashid, value.toString(), () {
        }, (String _) {});
        break;
      }
  }

  double getShoppingCost(bool needCoupons){
    if (_percentage == '1') {
      double total = getSubTotal(needCoupons) * fee / 100;
      return total;
    }else
      return fee;
  }

  /*getTaxes(bool needCoupons){
    double t = getSubTotal(needCoupons) * taxes/100;
    return t;
  }*/

  getTaxes(bool needCoupons){ 
    //double t = (getShoppingCost(needCoupons) + getSubTotal(needCoupons)) * taxes/100;
    //return t;
    double _totalTax = 0;
    for (var item in basket)
      _totalTax += getItemPriceTaxes(item);
    return _totalTax;
  }
  
  double getTotal(bool needCoupons){
    double _subTotal = getSubTotal(needCoupons);

    var _fee = 0.0;
    if (_percentage == '1')
      _fee = _subTotal * fee/100;
    else
      _fee = fee;
    
    var _taxes = (_fee + _subTotal) * (taxes/100);
    var _total = _subTotal + _fee + _taxes;

    if (!needCoupons)
      return _total;

    if (_coupon != null){
       return _total- getCoupons();
    }
     
    return _total;
  }

  setCoupon(Coupon coupon) {
    _coupon = coupon;
  }

  _getSubTotal(){
    double _total = 0;
    for (var item in basket)
      _total += getItemPrice(item);
    return _total;
  }

  getItemPrice(DishesData item){
    //print('total item');
    //print(item.toJSON());
    if (item == null)
      return 0;
    var t = item.precioUnit * item.count;
    if (item.discountprice != null && item.discountprice != 0)
      t = item.discountprice * item.count;
    for (var ex in item.extras)
      if (ex.select)
        t += (ex.precioUnit * item.count);
    return t;
  }
  getItemPriceTotal(DishesData item){
    //print('total item');
    //print(item.toJSON());
    if (item == null)
      return 0;
    var t = item.price * item.count;
    if (item.discountprice != null && item.discountprice != 0)
      t = item.discountprice * item.count;
    for (var ex in item.extras)
      if (ex.select)
        t += (ex.price * item.count);
    return t;
  }
  getItemPriceTaxes(DishesData item){
    //print('total item');
    //print(item.toJSON());
    if (item == null)
      return 0;
    var t = item.taxFood * item.count;
    if (item.discountprice != null && item.discountprice != 0)
      t = item.discountprice * item.count;
    for (var ex in item.extras)
      if (ex.select)
        t += (ex.taxFood * item.count);
    return t;
  }

  _getItemPriceDEBUG(DishesData item){
    var t = item.price * item.count;
    String td = "price*count (${item.price}*${item.count}=$t)";
    for (var ex in item.extras)
      if (ex.select) {
        t += (ex.price * item.count);
        td = "$td and Extras ${ex.id}:${ex.name} price*count (${ex.price}*${item.count}=${ex.price * item.count})";
      }
    return "$td. TOTAL: $t";
  }

  String couponComment = "";

  getSubTotal(bool needCoupons){
    var _total = _getSubTotal();
    return _total;

    /*if (!needCoupons)
      return _total;
    if (_coupon != null){
      dprint("getSubTotal coupon present");
      couponComment = "";
      if (_total > _coupon.amount){
        //
        var total = 0.0;
        for (var food in basket){
          var price = getItemPrice(food);
          var priceCoupon = price;

          if (_coupon.allRestaurants == '1') {
            priceCoupon = _couponCalculate(price);
            if (_coupon.allCategory != '1' && !_coupon.categoryList.contains(food.category)) {
              priceCoupon = price;
              dprint("getSubTotal not present in category list=${_coupon.categoryList} need=${food.category}");
            }else
              dprint("getSubTotal present in category list=${_coupon.categoryList} need=${food.category}");

            if (_coupon.allFoods != '1' && !_coupon.foodsList.contains(food.id)) {
              priceCoupon = price;
              dprint("getSubTotal not present in foods list=${_coupon.foodsList} need=${food.id}");
            }else
              dprint("getSubTotal present in foods list=${_coupon.foodsList} need=${food.id}");

          }else{
            if (_coupon.restaurantsList.contains(food.restaurant)) {
              priceCoupon = _couponCalculate(price);
              if (_coupon.allCategory != '1' && !_coupon.categoryList.contains(food.category)) {
                priceCoupon = price;
                dprint("getSubTotal not present in category list=${_coupon.categoryList} need=${food.category}");
              }else
                dprint("getSubTotal present in category list=${_coupon.categoryList} need=${food.category}");

              if (_coupon.allFoods != '1' && !_coupon.foodsList.contains(food.id)){
                priceCoupon = price;
                dprint("getSubTotal not present in foods list=${_coupon.foodsList} need=${food.id}");
              }else
                dprint("getSubTotal present in foods list=${_coupon.foodsList} need=${food.id}");

            }else
              priceCoupon = price;
          }
          if (priceCoupon != price)
            dprint("getSubTotal food ${food.id}:${food.name} IN ACTION. ${_getItemPriceDEBUG(food)} WITH COUPON=${_couponCalculateDEBUG(price)}");
          else{
            dprint("getSubTotal food ${food.id}:${food.name} NO IN ACTION. ${_getItemPriceDEBUG(food)}");
            couponComment = "$couponComment${strings.get(262)} ${food.name} ${strings.get(263)}\n"; // Food does not participate in the promotion",
          }
          total += priceCoupon;
        }
        if (total != _total)
          if (_coupon.inpercents != '1')
            total = _total - _coupon.discount;
        return total;
      }else{
        couponComment = "${strings.get(264)} ${_coupon.amount}\n";  // "The minimum purchase amount must be",
      }
    }
    return _total;*/
  }

  getCoupons()
  {
    var _total = _getSubTotal();
    if (_coupon != null){
      dprint("getSubTotal coupon present");
      couponComment = "";
      if (_total > _coupon.amount){
        //
        var total = 0.0;
        for (var food in basket){
          var price = getItemPrice(food);
          var priceCoupon = price;

          if (_coupon.allRestaurants == '1') {
            priceCoupon = _couponCalculate(price);
            if (_coupon.allCategory != '1' && !_coupon.categoryList.contains(food.category)) {
              priceCoupon = price;
              dprint("getSubTotal not present in category list=${_coupon.categoryList} need=${food.category}");
            }else
              dprint("getSubTotal present in category list=${_coupon.categoryList} need=${food.category}");

            if (_coupon.allFoods != '1' && !_coupon.foodsList.contains(food.id)) {
              priceCoupon = price;
              dprint("getSubTotal not present in foods list=${_coupon.foodsList} need=${food.id}");
            }else
              dprint("getSubTotal present in foods list=${_coupon.foodsList} need=${food.id}");

          }else{
            if (_coupon.restaurantsList.contains(food.restaurant)) {
              priceCoupon = _couponCalculate(price);
              if (_coupon.allCategory != '1' && !_coupon.categoryList.contains(food.category)) {
                //priceCoupon = price;
                priceCoupon = 0;
                dprint("getSubTotal not present in category list=${_coupon.categoryList} need=${food.category}");
              }else
                dprint("getSubTotal present in category list=${_coupon.categoryList} need=${food.category}");

              if (_coupon.allFoods != '1' && !_coupon.foodsList.contains(food.id)){
                //priceCoupon = price;
                priceCoupon = 0;
                dprint("getSubTotal not present in foods list=${_coupon.foodsList} need=${food.id}");
              }else
                dprint("getSubTotal present in foods list=${_coupon.foodsList} need=${food.id}");

            }else
              priceCoupon = 0;
              //priceCoupon = price;
          }
          if (priceCoupon != price)
            dprint("getSubTotal food ${food.id}:${food.name} IN ACTION. ${_getItemPriceDEBUG(food)} WITH COUPON=${_couponCalculateDEBUG(price)}");
          else{
            dprint("getSubTotal food ${food.id}:${food.name} NO IN ACTION. ${_getItemPriceDEBUG(food)}");
            couponComment = "$couponComment${strings.get(262)} ${food.name} ${strings.get(263)}\n"; // Food does not participate in the promotion",
          }
          total += priceCoupon;
        }
        if (total != _total)
          if (_coupon.inpercents != '1')
            total =  _coupon.discount;
        return total;
      }else{
        couponComment = "${strings.get(264)} ${_coupon.amount}\n";  // "The minimum purchase amount must be",
        return 0; 
      }
    }
    return 0; 
  }

  _couponCalculate(var _total){
    if (_coupon.inpercents == '1')
      _total = (_coupon.discount)/100*_total;
    else
      _total -= _coupon.discount;
    return _total;
  }

   /*_couponCalculate(var _total){
    if (_coupon.inpercents == '1')
      _total = (100-_coupon.discount)/100*_total;
    else
      _total -= _coupon.discount;
    return _total;
  }*/

  _couponCalculateDEBUG(var _total){
    if (_coupon.inpercents == '1')
      return "$_total-${_coupon.discount}% = ${(100-_coupon.discount)/100*_total}";
    else
      return "$_total-${_coupon.discount} = ${_total - _coupon.discount}";
  }

  getDesc(){
    var _text = "";
    for (var item in basket) {
      _text = "${item.name} and other";
      break;
    }
    return _text;
  }

  String _paymentid = "";
  createOrder(String id, String addr, String phone, String hint, String lat, String lng, String curbsidePickup,
      String couponName,String couponTotal,String pticketCode,
      Function() _success, Function(String) _error){
    _paymentid = id;
    for (var item in basket)
      item.delivered = false;
      basketReset(account.token, (){
      var _total = getTotal(true);
      addToBasket(basket, account.token, taxes.toString(), hint, restaurant, _paymentid, "0", "1", addr, phone,
          _total, lat, lng, curbsidePickup, couponName,couponTotal, pticketCode,
              (String id, String _fee, String percent) {
            fee = double.parse(_fee);
            _percentage = percent;
              orderid = id;
              ticketCode = pticketCode;
            _success();
            basket.clear();
          }, _error);
    }, _error);
  }

  getCount(String id){
    for (var item in basket)
      if (item.hashid == id)
        if (item.count != 0)
          return item.count;
  }

  // basket.makePriceSctring(item.price),
  makePriceSctring(double price){
    return (appSettings.rightSymbol == "false") ? "$defCurrency${price.toStringAsFixed(appSettings.symbolDigits)}" :
        "${price.toStringAsFixed(appSettings.symbolDigits)}$defCurrency";
  }

}

