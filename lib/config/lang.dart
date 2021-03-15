import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/pref.dart';

import 'language/langDeu.dart';
import 'language/langArabic.dart';
import 'language/langEsp.dart';
import 'language/langFrench.dart';
import 'language/langKorean.dart';
import 'language/langPort.dart';
import 'language/langRus.dart';

class LangData{
  String name;
  String engName;
  String image;
  bool current;
  int id;
  TextDirection direction;
  LangData({this.name, this.engName, this.image, this.current, this.id, this.direction});
}

class Lang {

  static var english = 1;
  static var german = 2;
  static var espanol = 3;
  static var french = 4;
  static var korean = 5;
  static var arabic = 6;
  static var portugal = 7;
  static var rus = 8;

  var direction = TextDirection.ltr;

  List<LangData> langData = [
    LangData(name: "Inglés", engName: "English", image: "assets/usa.png", current: false, id: english, direction: TextDirection.ltr),
    //LangData(name: "Deutsh", engName: "German", image: "assets/ger.png", current: false, id: german, direction: TextDirection.ltr),
    LangData(name: "Español", engName: "Spanish", image: "assets/esp.png", current: false, id: espanol, direction: TextDirection.ltr),
    //LangData(name: "Français", engName: "French", image: "assets/fra.png", current: false, id: french, direction: TextDirection.ltr),
    //LangData(name: "한국어", engName: "Korean", image: "assets/kor.png", current: false, id: korean, direction: TextDirection.ltr),
    //LangData(name: "عربى", engName: "Arabic", image: "assets/arabic.png", current: false, id: arabic, direction: TextDirection.rtl),
    //LangData(name: "Português", engName: "Portuguese", image: "assets/portugal.png", current: false, id: portugal, direction: TextDirection.ltr),
    //LangData(name: "Русский", engName: "Russian", image: "assets/rus.jpg", current: false, id: rus, direction: TextDirection.ltr),
  ];

  Map<int, String> langEng = {
    0 : "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    1 : "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
    2 : "Lorem ipsum",
    3 : "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ",
    10 : "Food Delivery App",
    11 : "Skip",
    12 : "Down",
    13 : "Let's start with LogIn!",
    14 : "Enter you login details to access your account.",
    15 : "Login",
    16 : "Password",
    17 : "Forgot password",
    18 : "Continue",
    19 : "Don't have an account? Create",
    20 : "Forgot password",
    21 : "E-mail address",
    22 : "LOGIN",
    23 : "SEND",
    24 : "Create an Account!",
    25 : "Confirm Password",
    26 : "CREATE ACCOUNT",
    27 : "To continue enter your phone number",
    28 : "Phone number",
    29 : "CONTINUE",
    30 : "Verify phone number",
    31 : "Almost done!",
    32 : "Code verification success!!!",
    33 : "Home",
    34 : "Search",
    35 : "Notifications",
    36 : "My Orders",
    37 : "Account",
    38 : "Favorites",
    39 : "Restaurants Near Your",
    40 : "Trending this week",
    41 : "Subcategories",
    42 : "Most Popular",
    43 : "Recent Reviews",
    44 : "Not Have Notifications",
    45 : "Notifications",
    46 : "This is very important information",
    47 : "Map",
    48 : "Address",
    49 : "Payment",
    50 : "History",
    51 : "Help & support",
    52 : "Unpaid",
    53 : "Shipped",
    54 : "To be Shipped",
    55 : "In Dispute",
    56 : "Orders List",
    57 : "Username",
    58 : "E-mail",
    59 : "Phone",
    60 : "Gender",
    61 : "Date of birth",
    62 : "Languages",
    63 : "App Language",
    64 : "Products",
    65 : "Services",
    66 : "Delivery",
    67 : "Misc",
    68 : "Term of service",
    69 : "Information",
    70 : "Monday",
    71 : "Tuesday",
    72 : "Wednesday",
    73 : "Thursday",
    74 : "Friday",
    75 : "Saturday",
    76 : "Sunday",
    77 : "Reviews",
    78 : "See Also",
    79 : "Ingredients",
    80 : "Nutrition",
    81 : "Mobile Phone",
    82 : "You can add to cart, only dishes from single restaurant. Do you want to reset cart? And add new dishes.",
    83 : "Reset",
    84 : "Cancel",
    85 : "Comments",
    86 : "There is no item in your cart",
    87 : "Check out our new items and update your collection",
    88 : "Continue Shopping",
    89 : "Extras",
    90 : "Add to cart",
    91 : "Dishes",
    92 : "Menu",
    93 : "Product subtotal",
    94 : "Shopping costs",
    95 : "Product taxes",
    96 : "Total",
    97 : "Checkout",
    98 : "Basket",
    99 : "Shopping Cart",
    100 : "Verify your quantity and click checkout",
    101 : "Delivery Address",
    102 : "Address 1",
    103 : "Address 2",
    104 : "City",
    105 : "Email address",
    106 : "Phone",
    107 : "Next",
    108 : "Credit/Debit Card",
    109 : "Cash On Delivery",
    110 : "PayPal",
    111 : "Google Wallet",
    112 : "Payment",
    113 : "Methods",
    114 : "Choose your payment method",
    115 : "Pay",
    116 : "Success",
    117 : "You Payment Receive to Seller",
    118 : "Done",
    119 : "My Orders",
    120 : "Order received",
    121 : "Order preparing",
    122 : "Order ready",
    123 : "On the way",
    124 : "Delivery",
    125 : "You must sign-in to access to this section",
    126 : "Error!!!",
    127 : "OK",
    128 : "Something went wrong. ",
    129 : "Log Out",
    130 : "This food was added to cart",
    131 : "This food already added to cart",
    132 : "Sign Out",
    133 : "All",
    134 : "Passwords are different.",
    135 : "A letter with a new password has been sent to the specified E-mail",
    136 : "User with this Email was not found!",
    137 : "Failed to send Email. Please try again later.\n",
    138 : "Add Review",
    139 : "Enjoying product?",
    140 : "How would you rate this product?",
    141 : "Enter your review",
    142 : "Enjoying Restaurant?",
    143 : "How would you rate this restaurant?",
    144 : "All fields must be input",
    145 : "Change password",
    146 : "Edit Profile",
    147 : "Change password",
    148 : "Old password",
    149 : "Enter your old password",
    150 : "New password",
    152 : "Enter your new password",
    153 : "Confirm New password",
    154 : "Enter your new password",
    155 : "Cancel",
    156 : "Edit profile",
    157 : "User Name",
    158 : "Enter your User Name",
    159 : "E-mail",
    160 : "Enter your User E-mail",
    161 : "Enter your User Phone",
    162 : "Change",
    163 : "Open Gallery",
    164 : "Open Camera",
    165 : "Change password",
    166 : "Password change",
    167 : "Passwords don't equals",
    168 : "Old password is incorrect",
    169 : "The password length must be more than 5 chars",
    170 : "Enter New Password",
    171 : "User Profile change",
    172 : "Enter Login",
    173 : "Enter Password",
    174 : "Login or Password in incorrect",
    175 : "Enter your Login",
    176 : "Enter your E-mail",
    177 : "Enter your password",
    178 : "You E-mail is incorrect",
    179 : "Not Have Favorites Food",
    180 : "Not Have Orders",
    181 : "Select place on map or find address on Search",
    182 : "Delivery Address:",
    183 : "no address",
    184 : "Select Address",
    185 : "Enter Phone number",
    186 : "Enter Comments",
    187 : "You Payment Receive to Seller",
    188 : "Payment",
    189 : "Cash on delivery",
    190 : "Stripe",
    191 : "Razorpay",
    192 : "Visa, Mastercard",
    193 : "PayPal",
    194 : "All transactions are secure and encrypted.",
    195 : "Id #",
    196 : "Cancelled",
    197 : "and",
    198 : "items",
    199 : "Top Foods this week",
    200 : "Top Restaurants this week",
    201 : "I will take the food myself",
    202 : "When your order will be ready, you will receive a message: \"Your Order was Ready\". Then "
        "when you arrive at the pickup location open application. Open \"My Orders\" and tap on \"Order\" for view details. "
        "Click button \"I've arrived\"",
    203 : "I've arrived",
    204 : "The customer has come to collect the order",
    205 : "Chat",
    206 : "Wallet",
    207 : "Top up and enjoy these benefits",
    208 : "Easy payment",
    209 : "Order food with 1 click",
    210 : "Cashless delivery",
    211 : "Avoid the cash hassle",
    212 : "Instant refunds",
    213 : "When you need to cancel an order",
    214 : "Top Up",
    215 : "BALANCE",
    216 : "Top Up Now",
    217 : "Enter the amount",
    218 : "Note!\nThe delivery distance ",
    219 : "Arriving in 30-60 min",
    220 : "Change >",
    221 : "Now",
    222 : "Later",
    223 : "Confirm",
    224 : "Arriving at ",
    225 : "Enter Vehicle Information",
    226 : "Help us locate your vehicle when you arrive.",
    227 : "Select Vehicle Type:",
    228 : "Select Vehicle Color",
    229 : "SUV",
    230 : "Sedan",
    231 : "Coupe",
    232 : "Track",
    233 : "Bike",
    234 : "Other",
    235 : "Black",
    236 : "Red",
    237 : "White",
    238 : "Gray",
    239 : "Silver",
    240 : "Green",
    241 : "Blue",
    242 : "Brown",
    243 : "Gold",
    244 : "Save Vehicle Information",
    245 : "Vehicle Type:",
    246 : "Vehicle Color",
    247 : "Pickup from restaurant",
    248 : "Select Vehicle Type",
    249 : "PayPal",
    250 : "PayPal Payment",
    251 : "PayStack",
    252 : "It's ordered!",
    253 : "Order No. #",
    254 : "You've successfully placed the order",
    255 : "You can check status of your order by using our delivery status feature. You will receive an order confirmation message.",
    256 : "Show All my orders",
    257 : "Back to shop",
    258 : "Coupon",
    259 : "The Restaurant: ",
    260 : "have maximum delivery distance is ",
    261 : "is very long.",
    262 : "Food",
    263 : "does not participate in the promotion",
    264 : "The minimum purchase amount must be",
    265 : "Yandex.Kassa",
    266 : "Instamojo",
    267 : "Restaurant",
    268 : "Food categories",

    269 : "Sign In with Google",
    270 : "Sign In with Facebook",
    271 : " or ",
    272 : "This email is busy",
    273 : "Log In with Google",
    274 : "Log In with Facebook",
    275 : "Show Delivery Area",
    276 : "This filter will work throughout the application.",
    277 : "Select Address on Map",
    278 : "Add Address",
    279 : "Latitude",
    280 : "Longitude",
    281 : "Home",
    282 : "Work",
    283 : "Other",
    284 : "Default",
    285 : "Addresses not found",
    286 : "Enter address",
    287 : "default", 
    288 : "Billing",
    289 : "RFC",
    290 : "Business Name",
    291 : "RFC Error",
    292 : "Error invalid e-mail",
    293 : "Phone numbre only numeric",
    294 : "RFC format error",
    295 : "Payment details",
    296 : "Invoice the purchase",
    297 : "The invoice has been created",
    298 : "The field is necessary",
    299 : "Billing deadline",
    300 : "Date",
    301 : "Payment method",
    302 : "See more",
    303 : "It is not possible to generate your invoice",
    304 : "The deadline has passed.",
    305 : "Close",
    306 : "Sending the data to the SAT",
    307 : "Your invoice has been generated successfully",
    308 : "We had an error generating your invoices",
    309 : "Product invoice: ",
    310 : "Delivery service invoice: ",
    311 : "Home delivery ",
    312 : "Delivery taxes",
    313 : "Offer",
  };

  //
  //
  //
  setLang(int id){
    pref.set(Pref.language, "$id");
    if (id == english) {
      defaultLang = langEng;
      init = true;
    }
    if (id == german) {
      defaultLang = langDeu;
      init = true;
    }
    if (id == espanol) {
      defaultLang = langEsp;
      init = true;
    }
    if (id == french) {
      defaultLang = langFrench;
      init = true;
    }
    if (id == korean) {
      defaultLang = langKorean;
      init = true;
    }
    if (id == arabic) {
      defaultLang = langArabic;
      init = true;
    }
    if (id == portugal){
      defaultLang = langPort;
      init = true;
    }
    if (id == rus){
      defaultLang = langRus;
      init = true;
    }
    for (var lang in langData) {
      lang.current = false;
      if (lang.id == id) {
        lang.current = true;
        direction = lang.direction;
      }
    }
  }

  Map<int, String> defaultLang;
  var init = false;

  String get(int id){
    if (!init) return "";
    var str = defaultLang[id];
    if (str == null)
      str = "";
    return str;
  }

}

