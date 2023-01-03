import 'package:flutter/material.dart';

const String kMaterialAppTitle = 'Kabrigadahan Mobile';

// API
const String kBaseUrl = 'https://gensan-staging.brigadahan.org';
// const String kBaseUrl = 'http://574a-120-28-222-6.ngrok.io';
const String kApiKey = 'a62357e73d9542998803b8573ccd8db4';

//Colors
const Color kBackgroundColor = Color(0xFFebebf6);
const Color kChipColor = Color(0xFFff4040);
const kPrimaryColor = Color(0xFFED1C24);
const kPastelRed = Color(0xFF810000);
const kWhiteColor = Color(0xFFFFFFFF);
const kYellowColor = Color(0xFFF2C85B);
const Color kPrimaryLight = Color(0xfffde4e4);
const Color kPrimaryLightTrans = Color.fromARGB(128, 253, 228, 228);

const kYellowColorLight = Color(0xfaefeeac);
const Color kSettingsBackgroundColor = Color(0xFFdcdedd);

//Screen Size
String getDeviceType() {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
  return data.size.shortestSide < 600 ? 'phone' :'tablet';
}

double getScreenSize(BuildContext context){
  double fullScreenHeight = MediaQuery.of(context).size.height;
  var padding = MediaQuery.of(context).padding;

  var result = fullScreenHeight - padding.top - (fullScreenHeight * 0.28);
  return result;
}

const kAnimationDuration = Duration(milliseconds: 200);
//images for no profile picture
const List<String> knoImagesBoys = [
  'assets/images/boys/1.png',
  'assets/images/boys/2.png',
  'assets/images/boys/3.png',
  'assets/images/boys/4.png',
  'assets/images/boys/5.png',
];

const List<String> knoImagesGirls = [
  'assets/images/girls/1.png',
  'assets/images/girls/2.png',
  'assets/images/girls/3.png',
  'assets/images/girls/4.png',
  'assets/images/girls/5.png',
];

const String kConsolidateDonationsPermission = "Pages.Mobile.ConsolidateDonationsFromOfficers";
const String kReceiveDonationsPermission = "Pages.Mobile.ReceivedDonationsFromOthers";
