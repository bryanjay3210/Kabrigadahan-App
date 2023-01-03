import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/core/utils/enums/reason/enum_fundraising_reasons.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/current_user.dart';
import 'package:kabrigadan_mobile/src/domain/entities/newsfeed/newsfeed.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_fundraising/fundraising_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/widgets/donation/amount_reusable.dart';
import 'package:kabrigadan_mobile/src/presentation/widgets/fundraising/fundraising_photo_widget.dart';
import 'package:logger/logger.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sizer/sizer.dart';

class FundRaisingDescription extends StatefulWidget {
  final NewsFeed newsFeed;
  final CurrentUser? currentUser;
  const FundRaisingDescription({Key? key, required this.newsFeed, this.currentUser}) : super(key: key);

  @override
  _FundRaisingDescriptionState createState() => _FundRaisingDescriptionState();
}

class _FundRaisingDescriptionState extends State<FundRaisingDescription> {
  double defFontSize = getDeviceType() == 'phone' ? 11.0.sp : 7.0.sp;
  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller;
    _controller = PersistentTabController(initialIndex: 0);
    FundraisingBloc fund = BlocProvider.of<FundraisingBloc>(context);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            color: Colors.black,
            onPressed: (){
              fund.currentIndex = 0;
              Navigator.pop(context,true);
            }
        ),
        title: const Text("Fundraising Details", style: TextStyle(color: Colors.black),),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsetsDirectional.only(start: 14, end: 14, bottom: 7, top: 7),
        child: Card(
            shadowColor: Colors.grey,
            elevation: 5.0,
            child: _buildContainer(context, widget.newsFeed, widget.currentUser, defFontSize)
        ),
      ),
    );
  }

  Widget _buildContainer(BuildContext context, NewsFeed? newsFeed, CurrentUser? currentUser, double defFontSize) {
    DateTime endDate = DateTime.parse(newsFeed!.fundraisingItem!.fundRaising!.fundraising!.endDate.toString());
    DateTime now = DateTime.now();
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildImage(),
              Card(color: Colors.white70,child: _buildTitleAndDescription(context, defFontSize)),
              _buildHeader(defFontSize),
              // _buildAmountRaised(defFontSize),
              const Divider(),
              // currentUser != null && endDate.compareTo(now) > 0 ? AmountReusable(newsFeed: newsFeed, currentUser: currentUser) : const SizedBox(height: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double defFontSize) {
    var random = Random();

    var randomNumber = random.nextInt(5);
    int gender = widget.newsFeed.fundraisingAttachment!.fundraiser!.member!.gender!;
    Widget image = gender == 1 ? Image.asset(knoImagesBoys[randomNumber]) : Image.asset(knoImagesGirls[randomNumber]);

    DateTime now = DateTime.now();
    DateTime dateFiled = DateTime.parse(widget.newsFeed.fundraisingAttachment!.fundraisingAttachmentDetails!.fundraising!.dateFiled!);
    int dateDifference = now.difference(dateFiled).inDays;

    String timeOfPosting = dateDifference > 30 ? '${dateDifference ~/ 30} Months ago' : '$dateDifference Days ago';

    int? reasonenum = widget.newsFeed.fundraisingItem!.fundRaising!.fundraising!.reason;
    var reason = FundraisingReasons.values[reasonenum! - 1];
    int _recipientLength = widget.newsFeed.fundraisingItem!.fundRaising!.fundraising!.recipient!.length;


    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0, top: 10.0),
          child: CircleAvatar(
            backgroundColor: kBackgroundColor,
            child: image,
            radius: 16.0,
          ),
        ),
        Wrap(
          children: [
            SizedBox(
              width: 40.0.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.newsFeed.fundraisingItem!.fundRaising!.fundraising!.recipient ?? '',
                    style: GoogleFonts.lato(fontWeight: FontWeight.w900, fontSize: defFontSize, color: Colors.grey),
                  ),
                  Text(
                    timeOfPosting,
                    style: GoogleFonts.lato(fontWeight: FontWeight.w500, fontSize: defFontSize-5, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Spacer(),
        Wrap(
          children: [
            reason.toString().split('.').last.isNotEmpty ?
            Container(
              width: 26.0.w,
              decoration: BoxDecoration(color: kPrimaryColor, borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  reason.toString().split('.').last.toUpperCase(),
                  style: GoogleFonts.lato(fontWeight: FontWeight.w900, fontSize: defFontSize-5, color: Colors.white),textAlign: TextAlign.center,
                ),
              ),
            ) : const SizedBox(),
          ],
        )
        //TODO: ADD CHIP SHOWING WHAT IS IN NEED OF
      ],
    );
  }

  Widget _buildImage() {
    var logger = Logger();
    var _listLatestPhoto = widget.newsFeed.fundraisingAttachment!.photos;
    var l = widget.newsFeed.fundraisingItem!.fundRaising!.fundraising!.status;

    List<String?> _listPhoto = [];

    for (var i in _listLatestPhoto!) {
      _listPhoto.add(i.fileUrl);
    }

    return _listPhoto.isNotEmpty
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
    ) : const SizedBox(height: 0);
  }

  Widget _buildTitleAndDescription(BuildContext context, double defFontSize) {
    DateTime dateFiled = DateTime.parse(widget.newsFeed.fundraisingAttachment!.fundraisingAttachmentDetails!.fundraising!.dateFiled!);
    String dateTime = DateFormat('yyyy-MM-dd').format(dateFiled);
    String diagnosis = widget.newsFeed.fundraisingItem!.fundRaising!.fundraising!.diagnosis ?? '(no case description)';
    String caseDescription = widget.newsFeed.fundraisingItem!.fundRaising!.fundraising!.caseDescription ?? diagnosis;
    String inNeedOf = widget.newsFeed.fundraisingItem!.fundRaising!.fundraising!.inNeedOf != null ? widget.newsFeed.fundraisingItem!.fundRaising!.fundraising!.inNeedOf!.trim().toString() : '';
    int _recipientLength = widget.newsFeed.fundraisingItem!.fundRaising!.fundraising!.recipient!.length;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 5.0),
                  child:  Text('In need Of :', style: TextStyle(fontWeight: FontWeight.bold, fontSize: defFontSize+2,),),
              ),
              inNeedOf.isNotEmpty ?
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 10.0),
                child:  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: inNeedOf,
                        style: TextStyle(
                          fontFamily: 'Butler',
                          color: Colors.black87,
                          fontSize: defFontSize,
                        ),
                      ),
                    ])),
              ) : const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 10.0),
                child:  Text('Description :', style: TextStyle(fontWeight: FontWeight.bold, fontSize: defFontSize+2,),),
              ),
              caseDescription.isNotEmpty ?
              Padding(
                  padding: const EdgeInsets.only(left: 8.0,),
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
              ) : const SizedBox(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 10.0, bottom: 5.0),
                        child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: 'Recipient: ',
                                style: TextStyle(
                                  fontFamily: 'Butler',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black87,
                                  fontSize: defFontSize
                                ),
                              ),
                            ])),
                      ),
                      Wrap(
                        children: [
                          widget.newsFeed.fundraisingItem!.fundRaising!.fundraising!.recipient!.isNotEmpty ?
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 10.0, bottom: 5.0),
                            child: SizedBox(
                              width: 55.0.w,
                              child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: widget.newsFeed.fundraisingItem!.fundRaising!.fundraising!.recipient,
                                      style: TextStyle(
                                        fontSize: defFontSize,
                                        fontFamily: 'Butler',
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ])),
                            ),
                          ) : const SizedBox(),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0,top: 10.0, bottom: 10.0),
                    child: Row(
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
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRaised(double defFontSize){
    double amountRaised = widget.newsFeed.fundraisingItem!.fundRaising!.fundraising!.amount ?? 0.00;
    List<String> decimal =  widget.newsFeed.fundraisingItem!.fundRaising!.fundraising!.amount.toString().split('.');
    String amountInString = amountRaised.toString() + (decimal[1].length == 1 ? '0' : '');


    if(amountRaised>=1000&&amountRaised<10000){
      amountInString = amountInString.substring(0,1)+','+amountInString.substring(1);
    }
    if(amountRaised>=10000&&amountRaised<100000){
      amountInString = amountInString.substring(0,2)+','+amountInString.substring(2);
    }
    if(amountRaised>=100000&&amountRaised<1000000){
      amountInString = amountInString.substring(0,3)+','+amountInString.substring(3);
    }
    return
      Column(
      children: [
        amountRaised > 0.00 ?
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 10.0, bottom: 10.0),
          child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Amount to be raised: ',
                  style: TextStyle(
                    fontFamily: 'Butler',
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    fontSize: defFontSize,
                  ),
                ),
              ])),
        ) : const SizedBox(),
        amountRaised > 0.00 ?
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 2.0),
          child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Php '+ amountInString,
                  style: TextStyle(
                    fontSize: defFontSize+6,
                    fontFamily: 'Butler',
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
              ])),
        ) : const SizedBox(),
      ],
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
