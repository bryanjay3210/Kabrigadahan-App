import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/core/utils/enums/reason/enum_fundraising_reasons.dart';
import 'package:kabrigadan_mobile/src/core/utils/text_checker/text_checker.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/current_user.dart';
import 'package:kabrigadan_mobile/src/domain/entities/newsfeed/newsfeed.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_fundraising/fundraising_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/fundraising/fundraising_description.dart';
import 'package:kabrigadan_mobile/src/presentation/widgets/donation/amount_reusable.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sizer/sizer.dart';

import 'fundraising_photo_widget.dart';

class FundraisingWidget extends StatelessWidget {
  final NewsFeed newsFeed;
  final CurrentUser? currentUser;

  const FundraisingWidget({Key? key, required this.newsFeed, this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FundraisingBloc fund = BlocProvider.of<FundraisingBloc>(context);
    PersistentTabController _controller;
    _controller = PersistentTabController(initialIndex: 0);

    return GestureDetector(
      onTap: (){
        fund.currentIndex = 0;
        Navigator.push(context, MaterialPageRoute(builder: (context) => FundRaisingDescription(newsFeed: newsFeed, currentUser: currentUser)));
      },
      child: Container(
        padding: const EdgeInsetsDirectional.only(start: 14, end: 14, bottom: 7, top: 7),
        child: _buildContainer(context, newsFeed, currentUser),
      ),
    );
  }

  Widget _buildContainer(BuildContext context, NewsFeed? newsFeed, CurrentUser? currentUser) {
    double defFontSize = getDeviceType() == 'phone' ? 10.0.sp : 9.0.sp;
    DateTime endDate = DateTime.parse(newsFeed!.fundraisingItem!.fundRaising!.fundraising!.endDate.toString());
    DateTime now = DateTime.now();
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(defFontSize),
              _buildTitleAndDescription(context, defFontSize),
              _buildImage(context),
              // _buildAmount(),
              // currentUser != null && endDate.compareTo(now) > 0 ? AmountReusable(newsFeed: newsFeed, currentUser: currentUser) : const SizedBox(height: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmount(){
    double? amount = newsFeed.fundraisingItem!.fundRaising!.fundraising!.amount;
    final formatCurrency = NumberFormat.simpleCurrency(
        locale: Platform.localeName, name: 'PHP');

    return Padding(
    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
    child: amount! > 0 ?
        Column(children: [
          Text('Amount to be raised', style: TextStyle(color: kPrimaryColor, fontSize: 10.sp),),
          Text(formatCurrency.format(amount).toString(), style: TextStyle(color: kPrimaryColor, fontSize: 15.sp, fontWeight: FontWeight.bold),)
        ],)
        : const SizedBox()
    );
  }

  Widget _buildHeader(double defFontSize) {
    var random = Random();

    var randomNumber = random.nextInt(5);
    int gender = newsFeed.fundraisingAttachment!.fundraiser!.member!.gender!;
    Widget image = gender == 1 ? Image.asset(knoImagesBoys[randomNumber]) : Image.asset(knoImagesGirls[randomNumber]);

    DateTime now = DateTime.now();
    DateTime dateFiled = DateTime.parse(newsFeed.fundraisingAttachment!.fundraisingAttachmentDetails!.fundraising!.dateFiled!);
    int dateDifference = now.difference(dateFiled).inDays;

    String timeOfPosting = dateDifference > 30 ? '${dateDifference ~/ 30} Months ago' : '$dateDifference Days ago';
    String inNeedOf = newsFeed.fundraisingItem!.fundRaising!.fundraising!.inNeedOf != null ? newsFeed.fundraisingItem!.fundRaising!.fundraising!.inNeedOf.toString() : 'Donation';

    int? reasonenum = newsFeed.fundraisingItem!.fundRaising!.fundraising!.reason;
    var reason = FundraisingReasons.values[reasonenum! - 1];

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: CircleAvatar(
            backgroundColor: kBackgroundColor,
            child: image,
            radius: 20.0,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              textLenghtChecker(newsFeed.fundraisingItem!.fundRaising!.fundraising!.recipient!, 15),
              style: GoogleFonts.lato(fontWeight: FontWeight.w900, fontSize: defFontSize, color: Colors.grey),
            ),
            Text(
              timeOfPosting,
              style: GoogleFonts.lato(fontWeight: FontWeight.w500, fontSize: defFontSize, color: Colors.grey),
            ),
          ],
        ),
        const Spacer(),
        reason.toString().split('.').last.isNotEmpty ?
        Container(
          decoration: BoxDecoration(color: kChipColor, borderRadius: BorderRadius.circular(20.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              textLenghtChecker(reason.toString().split('.').last.toUpperCase(), 15),
              style: GoogleFonts.lato(fontWeight: FontWeight.w900, fontSize: 8.0.sp, color: Colors.white),
            ),
          ),
        ) : const SizedBox()
      ],
    );
  }

  Widget _buildImage(BuildContext context) {
    FundraisingBloc fund = BlocProvider.of<FundraisingBloc>(context);
    var _listLatestPhoto = newsFeed.fundraisingAttachment!.photos;

    List<String?> _listPhoto = [];

    for (var i in _listLatestPhoto!) {
      _listPhoto.add(i.fileUrl);
    }

    return GestureDetector(
      onTap: (){
        fund.currentIndex = 0;
        Navigator.push(context, MaterialPageRoute(builder: (context) => FundRaisingDescription(newsFeed: newsFeed, currentUser: currentUser,)));
      },
      child: _listPhoto.isNotEmpty
          ? ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          width: 90.0.w,
          height: 40.0.h,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.08),
          ),
          child: FundraisingPhotoWidget(listPhoto: _listPhoto,),
        ),
      )
          : const SizedBox(height: 0),
    );
  }

  Widget _buildTitleAndDescription(BuildContext context, double defFontSize) {
    FundraisingBloc fund = BlocProvider.of<FundraisingBloc>(context);
    DateTime dateFiled = DateTime.parse(newsFeed.fundraisingAttachment!.fundraisingAttachmentDetails!.fundraising!.dateFiled!);
    String dateTime = DateFormat('yyyy-MM-dd').format(dateFiled);

    String diagnosis = newsFeed.fundraisingItem!.fundRaising!.fundraising!.diagnosis ?? '(no case description)';
    String caseDescription = newsFeed.fundraisingItem!.fundRaising!.fundraising!.caseDescription ?? diagnosis;
    TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 2.0.sp);
    TextStyle linkStyle = TextStyle(color: Colors.blue, fontSize: defFontSize);

    return GestureDetector(
      onTap: (){
        fund.currentIndex = 0;
        Navigator.push(context, MaterialPageRoute(builder: (context) => FundRaisingDescription(newsFeed: newsFeed, currentUser: currentUser)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Html(
                  data: '<p>'+caseDescription.trim().replaceAll('<br>', '')+'</p>',
                  style: {
                    "div": Style(
                      fontSize: FontSize(defFontSize+2),
                    ),
                    "p": Style(
                      fontSize: FontSize(defFontSize+2),
                    ),
                  },
                ),
            ),
            // Description
            RichText(
              text: TextSpan(
                style: defaultStyle,
                children: <TextSpan>[
                  TextSpan(
                      text: 'See More...',
                      style: linkStyle,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          fund.currentIndex = 0;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => FundRaisingDescription(newsFeed: newsFeed, currentUser: currentUser)));
                        }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 5.0),
              child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Recipient: ',
                      style: TextStyle(
                        fontFamily: 'Butler',
                        fontWeight: FontWeight.w300,
                        color: Colors.black87,
                        fontSize: defFontSize+2,
                      ),
                    ),
                    TextSpan(
                      text: newsFeed.fundraisingItem!.fundRaising!.fundraising!.recipient ?? '',
                      style: TextStyle(
                        fontFamily: 'Butler',
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                        fontSize: defFontSize+2,
                      ),
                    ),
                  ])),
            ),
            // Datetime
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Ionicons.time_outline, size: 16),
                const SizedBox(width: 4),
                Text(
                  dateTime,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(), // bottom part
        // Positioned(),// top part
      ],
    );
  }
}
