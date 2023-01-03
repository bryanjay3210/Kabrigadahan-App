import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/mobile_transaction_params.dart';
import 'package:kabrigadan_mobile/src/core/unremitted_donation/unremitted_donation.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/reminder_message/reminder_message.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/warning_message/warning_message.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/core/utils/shared_preferences/get_preferences.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/current_user.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/remitted_donation/remitted_donation.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation/unremitted_donation.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation/unremitted_donation_reference.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation_ui/unremitted_donation_ui.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation_ui_server/unremitted_donation_ui_server.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_donations/donations_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_mobile_transaction/bloc_mobile_transaction_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_mobile_transaction/bloc_mobile_transaction_update/mobile_transaction_update_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/collection_form/collection_form_main.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/community_officer_collections/body/community_community_search.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/qr_scanner/profile_and_case_qr_scanner.dart';
import 'package:logger/logger.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';

class BodyCommunityCollections extends StatefulWidget {
  final VoidCallback? refresh;

  const BodyCommunityCollections({Key? key, this.refresh}) : super(key: key);

  @override
  _BodyCommunityCollectionsState createState() => _BodyCommunityCollectionsState();

}

class _BodyCommunityCollectionsState extends State<BodyCommunityCollections> {
  final unremittedDonationBox = Hive.box('unremittedDonations');
  final unremittedDonationUiBox = Hive.box('unremittedDonationsUi');
  final unremittedDonationUiServerBox = Hive.box('unremittedDonationUiServer');
  final unremittedDonationReferenceBox = Hive.box('unremittedDonationReference');
  final remittedDonationBox = Hive.box('remittedDonations');
  var logger = Logger();

  final currentUserBox = Hive.box('currentUser');


  double totalAmount = 0.00;
  @override
  Widget build(BuildContext context) {
    // MobileTransactionBloc timeBloc = BlocProvider.of<MobileTransactionBloc>(context);
    // try{
    //   timeBloc.timer = Timer.periodic(const Duration(seconds: 30), (timer) async{
    //     ///TODO add API call for update
    //     /// Sync data
    //     var connectivityResult = await (Connectivity().checkConnectivity());
    //     if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
    //       final mobileTransactionBloc = BlocProvider.of<MobileTransactionBloc>(context);
    //       mobileTransactionBloc.add(SyncUnremittedDonationEvent(context));
    //       setState(() { });
    //     }
    //   });
    // } catch(e){ debugPrint('Syncing failed'); }
    return SafeArea(
      child: SizedBox(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [_buildButtons(), _buildListOfUnremittedDonations(context)],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 100.0,
      width: 100.0.w,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(text: 'Collections of Unremitted Donations to \nCommunity Officer', style: GoogleFonts.lato(color: Colors.black, fontSize: 12.0.sp, fontWeight: FontWeight.w900)),
                  textAlign: TextAlign.center,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    var connectivityResult = (Connectivity().checkConnectivity());
    return Container(
      height: 60.0,
      color: kBackgroundColor,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryColor)),
                  onPressed: () {
                    connectivityResult.then((value) {
                      var isConnected = value == ConnectivityResult.mobile || value == ConnectivityResult.wifi ? true : false;

                      showCupertinoModalBottomSheet(
                          context: context,
                          builder: (context) => Material(
                              child: SafeArea(
                                top: false,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const ListTile(
                                      title: Center(child: Text('What do you want to do?')),
                                    ),
                                    ListTile(
                                      title: const Text('Add Collection Form Manually'),
                                      leading: const Icon(CupertinoIcons.pen),
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => CollectionFormMain(isConnected: isConnected, isMember: true,))).then((_) {
                                          setState(() {});
                                        });
                                      },
                                    ),
                                    ListTile(
                                      title: const Text('Scan KaBrigadahan Member ID'),
                                      leading: const Icon(CupertinoIcons.qrcode_viewfinder),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ProfileAndCaseQRScanner(
                                                  isCollectionForm: true,
                                                  isConnected: isConnected,
                                                  refresh: widget.refresh,
                                                )));
                                      },
                                    ),
                                  ],
                                ),
                              )));
                    });
                    setState(() {});
                  },
                  icon: const Icon(Icons.add),
                  label: Text('Add Collection', style: TextStyle(fontSize: 10.0.sp))),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kYellowColor)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileAndCaseQRScanner(
                              isDonorQrScanner: false,
                              refresh: widget.refresh,
                            )));
                  },
                  label: Text(
                    'QR Scanner',
                    style: TextStyle(color: Colors.black, fontSize: 10.0.sp),
                  ),
                  icon: const Icon(Icons.qr_code, color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }

  List<String> bulkMemberList = [];
  List<RemittedDonation> toBeRemittedList = [];

  Widget _buildListOfUnremittedDonations(BuildContext context) {
    addData();
    CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;

    Future<void> _syncData(BuildContext context) async {
      await Future.delayed(const Duration(seconds: 2));
      final mobileTransactionBloc = BlocProvider.of<MobileTransactionBloc>(context);
      mobileTransactionBloc.add(SyncUnremittedDonationEvent(context));
    }

    return StatefulBuilder(builder: (BuildContext _context, StateSetter _setState) {
      final formatCurrency = NumberFormat.simpleCurrency(
          locale: Platform.localeName, name: 'PHP');
      return Expanded(
        child: Container(
          color: kBackgroundColor,
          child: Column(
            children: [
              SizedBox(
                height: 70.0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'List Of Unremitted',
                                style: GoogleFonts.lato(fontWeight: FontWeight.w900, fontSize: 15.0.sp),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: () async {
                                var connectivityResult = await (Connectivity().checkConnectivity());
                                if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
                                  _setState(() {
                                    final mobileTransactionBloc = BlocProvider.of<MobileTransactionBloc>(context);
                                    mobileTransactionBloc.add(const GetCurrentUserRemittanceMasterEvent());
                                    final unremittedDonationUiServerBox = Hive.box('unremittedDonationUiServer');
                                    unremittedDonationUiServerBox.clear();
                                    addData();
                                  });
                                } else {
                                  showDialog(context: context, builder: (context) => const WarningMessage(title: "Warning", content: "No internet connection. Please try again later."));
                                }
                              },
                              icon: const Icon(
                                CupertinoIcons.refresh_thin,
                                color: Colors.black,
                              ))
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Total: ${totalAmount.toStringAsFixed(2)} pesos',
                            style: GoogleFonts.lato(fontWeight: FontWeight.w900, fontSize: 12.0.sp, color: Colors.red),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              BlocBuilder<MobileTransactionBloc, MobileTransactionState>(
                builder: (_, state){
                  return dataUnsync.call() > 0 || dataReadyToBeSync.call() == true ? Container(
                    color: kPrimaryColor,
                    height: 45.0, width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Some data need to be sync!', style: TextStyle(color: Colors.white, fontSize: 12.sp),),
                          const Spacer(),
                          IconButton(
                              onPressed: () async{
                                /// Sync data
                                var connectivityResult = await (Connectivity().checkConnectivity());
                                if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
                                  final mobileTransactionBloc = BlocProvider.of<MobileTransactionBloc>(context);
                                  mobileTransactionBloc.add(SyncUnremittedDonationEvent(context));
                                  mobileTransactionBloc.add(const SyncUnremittedDonationCOEvent());
                                  setState(() {});
                                } else {
                                  showDialog(context: context, builder: (context) => const WarningMessage(title: "Warning", content: "No internet connection. Please try again later."));
                                }
                              }, icon: const Icon(Icons.sync, color: Colors.white,))
                        ],
                      ),
                    ),
                  ) : const SizedBox();
                },
              ),
              BlocBuilder<MobileTransactionBloc, MobileTransactionState>(
                builder: (context, state) {
                  if (state is GetCurrentUserMasterRemittanceDoneState) {
                    return Expanded(
                        child: toBeRemittedList.isNotEmpty
                            ? ListView.builder(
                            itemCount: toBeRemittedList.length,
                            itemBuilder: (context, index) {
                              RemittedDonation toBeRemitted = toBeRemittedList[index];
                              String name = toBeRemitted.name ?? '[BrigadaPay Unpaid]';
                              bool noDate = toBeRemitted.dateRecorded == null ? true : false;
                              return Card(
                                child: ListTile(
                                  isThreeLine: true,
                                  title: Text(name),
                                  subtitle: toBeRemitted.dateRecorded != null
                                      ? Text(
                                    DateFormat.yMMMMd('en_US').format(DateTime.parse(toBeRemitted.dateRecorded.toString())).toString() + '\n' + toBeRemitted.unremittedTempId.toString(),
                                  )
                                      : Text(
                                    '\n' + toBeRemitted.unremittedTempId.toString(),
                                  ),
                                  trailing: Text('${toBeRemitted.amount!.toStringAsFixed(2)} pesos',),
                                ),
                              );
                            })
                            : Center(
                          child: Text(
                            'No data',
                            style: GoogleFonts.lato(fontSize: 12.0.sp, fontWeight: FontWeight.w900, color: Colors.grey),
                          ),
                        ));
                  }
                  return const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
              SizedBox(
                height: 80.0,
                width: 100.0.w,
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 10.0),
                      height: 20.0,
                      child: BlocBuilder<MobileTransactionUpdateBloc, MobileTransactionUpdateState>(builder: (context, state) {
                        if (state is RemitLoadingMobileTransactionState) {
                          return const Center(child: CircularProgressIndicator());
                        } else {
                          return ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(toBeRemittedList.isNotEmpty ? kPrimaryColor : Colors.grey),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
                              ),
                              onPressed: toBeRemittedList.isNotEmpty
                                  ? () async {
                                UnremittedDonations.amount.value = 0;

                                final mobileTransactionUpdateBloc = BlocProvider.of<MobileTransactionUpdateBloc>(context);
                                String? accessToken = await GetPreferences().getStoredAccessToken();

                                MobileTransactionParams mobileTransactionParams =
                                MobileTransactionParams(accessToken: accessToken, agentMemberId: currentUser.memberId, memberUnRemittedDonations: bulkMemberList);

                                var connectivityResult = await (Connectivity().checkConnectivity());
                                if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
                                  for (RemittedDonation remittedDonation in toBeRemittedList) {
                                    UnremittedDonations.amount.value = UnremittedDonations.amount.value + remittedDonation.amount!;
                                  }
                                  mobileTransactionUpdateBloc.add(RemitMobileTransactionEvent(
                                      mobileTransactionParams: mobileTransactionParams, context: context, toBeRemittedList: toBeRemittedList, refresh: widget.refresh!, hasCached: false));
                                  setState(() {});
                                } else {

                                  if(dataUnsync.call() > 0 && dataReadyToBeSync.call() == false){
                                    showDialog(context: context, builder: (context) => const WarningMessage(title: "Warning", content: "No internet connection. Please try again later."));
                                  } else {
                                    ///TODO Display QRcode if has cache Reference Number
                                    for (RemittedDonation remittedDonation in toBeRemittedList) {
                                      UnremittedDonations.amount.value = UnremittedDonations.amount.value + remittedDonation.amount!;
                                    }
                                    mobileTransactionUpdateBloc.add(RemitMobileTransactionEvent(
                                        mobileTransactionParams: mobileTransactionParams, context: context, toBeRemittedList: toBeRemittedList, refresh: widget.refresh!, hasCached: true));
                                    setState(() {});
                                  }
                                }
                              }
                                  : () {},
                              child: Text(
                                'Remit Now',
                                style: GoogleFonts.lato(color: toBeRemittedList.isNotEmpty ? Colors.white : Colors.black),
                              ));
                        }
                      })),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  int dataUnsync(){
    int counter = 0;
    var unremittedDonationUiList = unremittedDonationUiBox.values.toList();
    for(UnremittedDonationUi ds in unremittedDonationUiList){
      if(ds.id == null){
        counter++;
      }
    }
    return counter;
  }
  bool dataReadyToBeSync(){
    bool ready = false;
    var unremittedDonationReferenceList = unremittedDonationReferenceBox.values.toList();
    for(UnremittedDonationReference ds in unremittedDonationReferenceList){
      if(ds.transactionType != null){
        ready = true;
      }
    }
    return ready;
  }

  void addData() {
    totalAmount = 0;
    var logger = Logger();

    bulkMemberList.clear();
    toBeRemittedList.clear();

    List<dynamic> unremittedDonationUiList = unremittedDonationUiBox.values.toList();
    List<dynamic> unremittedDonationUiServerList = unremittedDonationUiServerBox.values.toList();
    logger.i(unremittedDonationUiServerList);

    CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;
    // var i in unremittedDonationUiList
    int totalLength = unremittedDonationUiList.length;
    for (int a=totalLength; a>=1; a--) {
      UnremittedDonationUi unremittedDonationUi = unremittedDonationUiList[a-1] as UnremittedDonationUi;

      if (unremittedDonationUi.creatorId == currentUser.memberId) {
        String createUnremitted = '{'
            '"caseCode": \"${unremittedDonationUi.caseCode}\",'
            '"amount": ${unremittedDonationUi.amount},'
            '"donatedByMemberIdNumber": \"${unremittedDonationUi.donatedByMemberIdNumber}\",'
            '"agentMemberIdNumber": \"${unremittedDonationUi.agentMemberIdNumber}\",'
            '"status": ${unremittedDonationUi.status},'
            '"unremittedTempId": \"${unremittedDonationUi.unremittedTempId}\"'
            '}';

        Map<String, dynamic> unremittedJson = unremittedDonationUi.toJson();
        RemittedDonation remittedDonation = RemittedDonation.fromJson(unremittedJson);

        logger.i(remittedDonation);

        totalAmount += remittedDonation.amount!;
        bulkMemberList.add(createUnremitted);
        toBeRemittedList.add(remittedDonation);
      }
    }

    int totalFromServerLength = unremittedDonationUiServerList.length;
    for (int a=totalFromServerLength; a>=1; a--) {
      UnremittedDonationUiServer unremittedDonationUiServer = unremittedDonationUiServerList[a-1] as UnremittedDonationUiServer;

      bool hasNoDuplicate = true;

      for(var j in toBeRemittedList){
        if(unremittedDonationUiServer.unremittedTempId == j.unremittedTempId){
          hasNoDuplicate = false;
        }
      }

      if(hasNoDuplicate){
        String createUnremitted = '{'
            '"caseCode": \"${unremittedDonationUiServer.caseCode}\",'
            '"amount": ${unremittedDonationUiServer.amount},'
            '"donatedByMemberIdNumber": \"${unremittedDonationUiServer.donatedByMemberIdNumber}\",'
            '"agentMemberIdNumber": \"${unremittedDonationUiServer.agentMemberIdNumber}\",'
            '"status": ${unremittedDonationUiServer.status},'
            '"unremittedTempId": \"${unremittedDonationUiServer.unremittedTempId}\"'
            '}';

        Map<String, dynamic> unremittedJson = unremittedDonationUiServer.toJson();
        RemittedDonation remittedDonation = RemittedDonation.fromJson(unremittedJson);

        logger.i(remittedDonation);

        totalAmount += remittedDonation.amount!;
        bulkMemberList.add(createUnremitted);
        toBeRemittedList.add(remittedDonation);
      }
    }
  }
}
