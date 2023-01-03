import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/get_remittance_master_donation_details/get_remittancer_master_donation_details_master.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/core/utils/enums/remittance/enum_remittance.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/reminder_message/reminder_message.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/success_message/success_message.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/warning_message/warning_message.dart';
import 'package:kabrigadan_mobile/src/core/utils/mobile_transaction/show_member_remittance_master_helper.dart';
import 'package:kabrigadan_mobile/src/core/utils/shared_preferences/get_preferences.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/area_officer_master-in_progress/area_officer_master_in_progress.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/current_user.dart';
import 'package:kabrigadan_mobile/src/domain/entities/mobile_transaction/received/member_unremitted_donation_results.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_mobile_transaction/bloc_mobile_transaction_bloc.dart';
import 'package:logger/logger.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';

class ListOfUnremittedDonationsInProgress extends StatefulWidget {
  final VoidCallback? refresh;
  const ListOfUnremittedDonationsInProgress({Key? key, this.refresh}) : super(key: key);

  @override
  _ListOfUnremittedDonationsInProgressState createState() => _ListOfUnremittedDonationsInProgressState();
}

class _ListOfUnremittedDonationsInProgressState extends State<ListOfUnremittedDonationsInProgress> {
  // final masterRemittanceLocalBox = Hive.box('areaOfficerMasterLocal');
  // final masterRemittanceBox = Hive.box('areaOfficerMasterInProgress');

  refresh(){
    setState(() {
      final mobileTransactionBloc = BlocProvider.of<MobileTransactionBloc>(context);
      mobileTransactionBloc.add(const GetCurrentUserRemittanceMasterEvent());
    });
  }
  List<Map<String, dynamic>> bulkMemberList = [];
  @override
  Widget build(BuildContext context) {
    var logger = Logger();
    final currentUserBox = Hive.box('currentUser');
    CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;
    return Expanded(
      child: Container(
        color: kBackgroundColor,
        child: Column(
          children: [
            SizedBox(
              height: 60.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Row(
                  children: [
                    Text(
                      'List Of In-Progress Remittance',
                      style: GoogleFonts.lato(fontWeight: FontWeight.w900, fontSize: 12.0.sp),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () async {
                          setState(() {
                            final mobileTransactionBloc = BlocProvider.of<MobileTransactionBloc>(context);
                            mobileTransactionBloc.add(const GetCurrentUserRemittanceMasterEvent());
                          });
                        },
                        icon: const Icon(
                          CupertinoIcons.refresh_thin,
                          color: Colors.black,
                        ))
                  ],
                ),
              ),
            ),
            BlocBuilder<MobileTransactionBloc, MobileTransactionState>(
              builder: (context, state){
                // addData();
                if(state is GetCurrentUserMasterRemittanceDoneState){
                  final inProgress = BlocProvider.of<MobileTransactionBloc>(context);
                  List<AreaOfficerMasterInProgress> areaOfficerMasterLocalList = inProgress.areaOfficerMasterInProgressList;

                  return Expanded(
                      child: areaOfficerMasterLocalList.isNotEmpty
                          ? ListView.builder(
                          itemCount: areaOfficerMasterLocalList.length,
                          itemBuilder: (context, index) {
                            var logger = Logger();

                            AreaOfficerMasterInProgress areaOfficerMasterInProgress = areaOfficerMasterLocalList[index];

                            bool isAreaOfficer = areaOfficerMasterInProgress.transactionType == 'Ayannah';

                            String stringStatus = areaOfficerMasterInProgress.status != null ? EnumRemittance.remitStatusLabel[areaOfficerMasterInProgress.status!-1] : '';

                            return !isAreaOfficer ? Card(
                              child: ListTile(
                                isThreeLine: true,
                                leading: const Icon(Icons.check_circle, color: Colors.blue),
                                title: Text('${areaOfficerMasterInProgress.referenceNumber}'),
                                subtitle: areaOfficerMasterInProgress.referenceNumberAO == null ? Text('Status: ${stringStatus.trim()}') : Text('Status: ${stringStatus.trim()}\n ${areaOfficerMasterInProgress.referenceNumberAO.toString()}'),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('${double.parse(areaOfficerMasterInProgress.amount!).toStringAsFixed(2)} pesos', style: const TextStyle(color: Colors.grey),),
                                    const SizedBox(height: 5.0),
                                    Text(areaOfficerMasterInProgress.transactionType, style: TextStyle(color: Colors.red, fontSize: 9.0.sp), textAlign: TextAlign.center,),
                                  ],
                                ),
                                onTap: (){
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
                                                  title: const Text('Show QR'),
                                                  leading: const Icon(CupertinoIcons.qrcode_viewfinder),
                                                  onTap: () {
                                                    final currentUserBox = Hive.box('currentUser');
                                                    CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;


                                                    String areaOfficerQR = '{'
                                                        '\"amount\": ${areaOfficerMasterInProgress.amount},'
                                                        '\"referenceNumber\": \"${areaOfficerMasterInProgress.referenceNumber}\",'
                                                        '\"communityOfficeIdNumber\": \"${areaOfficerMasterInProgress.communityOfficeId}\",'
                                                        '\"communityOfficeName\": \"${areaOfficerMasterInProgress.communityOfficerName}\",'
                                                        '\"communityOfficeMemberId\": \"${areaOfficerMasterInProgress.agentMemberIdNumber}\",'
                                                        '\"memberRemittanceMasterID\": \"${areaOfficerMasterInProgress.memberRemittanceMasterID}\"'
                                                        '}';

                                                    showDialog(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          content: _qrFormAO(
                                                            areaOfficerQR,
                                                            areaOfficerMasterInProgress.amount.toString(),
                                                            areaOfficerMasterInProgress.referenceNumber.toString(),
                                                            areaOfficerMasterInProgress.communityOfficerName.toString(),
                                                            areaOfficerMasterInProgress.agentMemberIdNumber.toString(),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: (){
                                                                  Navigator.pop(context);
                                                                },
                                                                child: const Text('Close')
                                                            )
                                                          ],
                                                        )
                                                    );
                                                  },
                                                ),
                                                ListTile(
                                                  title: const Text('Show Details'),
                                                  leading: const Icon(CupertinoIcons.book),
                                                  onTap: () async {
                                                    final currentUserBox = Hive.box('currentUser');
                                                    CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;

                                                    showDialog(
                                                        context: context,
                                                        builder: (context) => FutureBuilder(
                                                            future: showRemittanceMasterDonationDetailsLocal(areaOfficerMasterInProgress, context),
                                                            builder: (context, snapshot){
                                                              if(snapshot.connectionState == ConnectionState.done){
                                                                return AlertDialog(
                                                                  backgroundColor: kSettingsBackgroundColor,
                                                                  content: StatefulBuilder(
                                                                    builder: (BuildContext context, StateSetter setState){
                                                                      List<MemberUnremittedDonationResultsEntity> listMemberMasterCollection = ShowMemberRemittanceMasterHelper.listMemberMasters.value;
                                                                      setState(() {});
                                                                      return SingleChildScrollView(
                                                                        child: SizedBox(
                                                                          height: 50.0.h,
                                                                          width: 40.0.w,
                                                                          child: listMemberMasterCollection.isNotEmpty ? ListView.builder(
                                                                              scrollDirection: Axis.vertical,
                                                                              shrinkWrap: true,
                                                                              itemCount: listMemberMasterCollection.length,
                                                                              itemBuilder: (context, index){
                                                                                MemberUnremittedDonationResultsEntity memberEntity = listMemberMasterCollection[index];
                                                                                return Card(
                                                                                  child: ListTile(
                                                                                    title: Text(memberEntity.donatedByName.toString(), style: TextStyle(fontSize: 8.0.sp)),
                                                                                    trailing: Text(memberEntity.amount!.toStringAsFixed(2)),

                                                                                  ),
                                                                                );
                                                                              }
                                                                          ) : const Center(child: Text('No Data')),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed: (){
                                                                          Navigator.pop(context);
                                                                        },
                                                                        child: const Text('Close')
                                                                    )
                                                                  ],
                                                                );
                                                              } else {
                                                                return SizedBox(
                                                                    height: 100.0,
                                                                    child: Center(
                                                                      child: AlertDialog(
                                                                        content: SingleChildScrollView(
                                                                          child: SizedBox(
                                                                            height: 20.0.h,
                                                                            width: 40.0.w,
                                                                            child: const Center(child: CircularProgressIndicator()),
                                                                          ),
                                                                        ),
                                                                        actions: [
                                                                          TextButton(
                                                                              onPressed: (){
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: const Text('Close')
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                );
                                                              }
                                                            }
                                                        )
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          )));
                                },
                              ),
                            ) : Card(
                              child: ListTile(
                                onTap: (){
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
                                                // ListTile(
                                                //   title: const Text('Cancel Transaction'),
                                                //   leading: const Icon(CupertinoIcons.multiply, color: Colors.red),
                                                //   onTap: () {
                                                //     List<Widget> textButtons = [
                                                //       TextButton(
                                                //           onPressed: () async {
                                                //             await getRemittanceMasterDonationDetailsLocal(areaOfficerMasterInProgress, areaOfficerMasterLocalList, context, widget.refresh!);
                                                //           },
                                                //           child: const Text("Revert")
                                                //       ),
                                                //       TextButton(
                                                //         onPressed: () => Navigator.of(context).pop(false),
                                                //         child: const Text("Cancel"),
                                                //       ),
                                                //     ];
                                                //
                                                //     showDialog(
                                                //         context: context,
                                                //         builder: (context) => ReminderMessage(title: "Confirmation", content: "Are you sure you wish to transfer this back to unremitted?", textButtons: textButtons)
                                                //     );
                                                //   },
                                                // ),
                                                ListTile(
                                                  title: const Text('Show QR'),
                                                  leading: const Icon(CupertinoIcons.qrcode_viewfinder),
                                                  onTap: () {
                                                    final currentUserBox = Hive.box('currentUser');
                                                    CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;

                                                    String areaOfficerQR = '{'
                                                        '\"amount\": ${areaOfficerMasterInProgress.amount},'
                                                        '\"referenceNumber\": \"${areaOfficerMasterInProgress.referenceNumber}\",'
                                                        '\"communityOfficeIdNumber\": \"${areaOfficerMasterInProgress.agentMemberIdNumber}\",'
                                                        '\"communityOfficeName\": \"${areaOfficerMasterInProgress.communityOfficerName}\",'
                                                        '\"communityOfficeMemberId\": \"${areaOfficerMasterInProgress.communityOfficerMemberId}\",'
                                                        '\"memberRemittanceMasterID\": \"${areaOfficerMasterInProgress.memberRemittanceMasterID}\"'
                                                        '}';

                                                    showDialog(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          content: _qrFormAO(
                                                            areaOfficerQR,
                                                            areaOfficerMasterInProgress.amount.toString(),
                                                            areaOfficerMasterInProgress.referenceNumber.toString(),
                                                            areaOfficerMasterInProgress.communityOfficerName.toString(),
                                                            areaOfficerMasterInProgress.agentMemberIdNumber.toString(),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: (){
                                                                  Navigator.pop(context);
                                                                },
                                                                child: const Text('Close')
                                                            )
                                                          ],
                                                        )
                                                    );
                                                  },
                                                ),
                                                ListTile(
                                                  title: const Text('Show Details'),
                                                  leading: const Icon(CupertinoIcons.book),
                                                  onTap: () async {
                                                    final currentUserBox = Hive.box('currentUser');
                                                    CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;

                                                    showDialog(
                                                        context: context,
                                                        builder: (context) => FutureBuilder(
                                                            future: showRemittanceMasterDonationDetailsLocal(areaOfficerMasterInProgress, context),
                                                            builder: (context, snapshot){
                                                              if(snapshot.connectionState == ConnectionState.done){
                                                                return AlertDialog(
                                                                  backgroundColor: kSettingsBackgroundColor,
                                                                  content: StatefulBuilder(
                                                                    builder: (BuildContext context, StateSetter setState){
                                                                      List<MemberUnremittedDonationResultsEntity> listMemberMasterCollection = ShowMemberRemittanceMasterHelper.listMemberMasters.value;
                                                                      setState(() {});
                                                                      return SingleChildScrollView(
                                                                        child: SizedBox(
                                                                          height: 50.0.h,
                                                                          width: 40.0.w,
                                                                          child: listMemberMasterCollection.isNotEmpty ? ListView.builder(
                                                                              scrollDirection: Axis.vertical,
                                                                              shrinkWrap: true,
                                                                              itemCount: listMemberMasterCollection.length,
                                                                              itemBuilder: (context, index){
                                                                                MemberUnremittedDonationResultsEntity memberEntity = listMemberMasterCollection[index];
                                                                                return Card(
                                                                                  child: ListTile(
                                                                                    title: Text(memberEntity.donatedByName.toString(), style: TextStyle(fontSize: 8.0.sp)),
                                                                                    trailing: Text('${memberEntity.amount.toString()}.00'),
                                                                                  ),
                                                                                );
                                                                              }
                                                                          ) : const Center(child: CircularProgressIndicator(), ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed: (){
                                                                          Navigator.pop(context);
                                                                        },
                                                                        child: const Text('Close')
                                                                    )
                                                                  ],
                                                                );
                                                              } else {
                                                                return SizedBox(
                                                                    height: 100.0,
                                                                    child: Center(
                                                                      child: AlertDialog(
                                                                        content: SingleChildScrollView(
                                                                          child: SizedBox(
                                                                            height: 20.0.h,
                                                                            width: 40.0.w,
                                                                            child: const Center(child: CircularProgressIndicator()),
                                                                          ),
                                                                        ),
                                                                        actions: [
                                                                          TextButton(
                                                                              onPressed: (){
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: const Text('Close')
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                );
                                                              }
                                                            }
                                                        )
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          )));
                                },
                                leading: const Icon(Icons.list, color: Colors.grey),
                                title: Text('${areaOfficerMasterInProgress.referenceNumber}'),
                                subtitle: areaOfficerMasterInProgress.referenceNumberAO == null ? Text('Status: $stringStatus', style: const TextStyle(color: Colors.black)) : Text('Status: $stringStatus\n ${areaOfficerMasterInProgress.referenceNumberAO.toString()}', style: const TextStyle(color: Colors.black)),
                                trailing: Column(
                                  children: [
                                    Text('${double.parse(areaOfficerMasterInProgress.amount!).toStringAsFixed(2)} pesos', style: const TextStyle(color: Colors.grey)),
                                    const SizedBox(height: 5.0),
                                    Text(areaOfficerMasterInProgress.transactionType, style: TextStyle(color: Colors.red, fontSize: 9.0.sp), textAlign: TextAlign.center,),
                                  ],
                                ),
                              ),
                            );
                          })
                          : const Scaffold(backgroundColor: kBackgroundColor, body: Center(child: Text('No data.'))));
                } else {
                  return const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
            }),
            currentUser.membershipLevel == 5 ? SizedBox(
              height: 80.0,
              width: 100.0.w,
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Container(
                    padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 10.0),
                    height: 20.0,
                    child: BlocBuilder<MobileTransactionBloc, MobileTransactionState>(builder: (context, state) {
                        if(state is GetCurrentUserMasterRemittanceDoneState){
                          final inProgress = BlocProvider.of<MobileTransactionBloc>(context);
                          List<AreaOfficerMasterInProgress> areaOfficerMasterLocalList = inProgress.areaOfficerMasterInProgressList;
                          bool check = true;
                          for(AreaOfficerMasterInProgress i in areaOfficerMasterLocalList){
                            if(i.referenceNumberAO == ""){
                              check = false;
                            }
                          }
                          return ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(areaOfficerMasterLocalList.isNotEmpty && !check ? kPrimaryColor : Colors.grey),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
                              ),
                              onPressed: areaOfficerMasterLocalList.isNotEmpty  && !check
                                  ? () async {
                                var connectivityResult = await (Connectivity().checkConnectivity());
                                if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {

                                  final bloc = BlocProvider.of<MobileTransactionBloc>(context);
                                  bloc.add(CreateCollectedRemittanceMasterEvent(context, refresh));
                                  ///Add choices where to remit
                                  showCupertinoModalBottomSheet(
                                    context: context,
                                    builder: (context) => _paymentChoice(),
                                  );
                                } else {
                                  showDialog(context: context, builder: (context) => const WarningMessage(title: "Warning", content: "No internet connection. Please try again later."));
                                }
                              } : () {},
                              child: Text(
                                'Bulk Remit',
                                style: GoogleFonts.lato(color: Colors.white),
                              ));
                        } else{
                          return const SizedBox(height: 0);
                        }
                    })),
              ),
            ) : const SizedBox(),
          ],
        ),
      ),
    );
  }
  Widget _paymentChoice(){
    return Material(
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                title: Center(child: Text('Where did you remit your collection?')),
              ),
              ListTile(
                title: const Text('Ayannah'),
                leading: const Icon(CupertinoIcons.money_rubl_circle),
                onTap: (){

                    List<Widget> textButtons = [
                      TextButton(
                          onPressed: () async{
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) =>
                                    SuccessMessage(
                                      title: 'Thank you for your donation!',
                                      content: 'Please wait for 24 hours for us to process your donation.',
                                      onPressedFunction: () {
                                        //TODO: USE NAVIGATOR.POPUNTIL
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        // refresh!();
                                      },
                                    ));


                            final bloc = BlocProvider.of<MobileTransactionBloc>(context);
                            bloc.add(const UpdateCollectorRemittanceAyannahEvent());
                          },
                          child: const Text("Yes")
                      ),
                      TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: const Text("No")
                      ),
                    ];

                    showDialog(
                        context: context,
                        builder: (context) => ReminderMessage(title: "Please confirm.", content: "Did you pay the donations to BrigadaPay?", textButtons: textButtons)
                    );
                },
              ),
              ListTile(
                title: const Text('Kabrigadahan Headquarters'),
                leading: const Icon(CupertinoIcons.person_2),
                onTap: (){
                    List<Widget> textButtons = [
                      TextButton(
                          onPressed: () async{
                                showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) =>
                                SuccessMessage(
                                title: 'Thank you for your donation!',
                                content: 'Please wait for 24 hours for us to process your donation.',
                                onPressedFunction: () {
                                //TODO: USE NAVIGATOR.POPUNTIL
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                // refresh!();
                                },
                                ));

                                final bloc = BlocProvider.of<MobileTransactionBloc>(context);
                                bloc.add(const UpdateCollectorRemittanceBrigadahanHeadQuarterEvent());
                          },
                          child: const Text("Yes")
                      ),
                      TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: const Text("No")
                      ),
                    ];

                    showDialog(
                        context: context,
                        builder: (context) => ReminderMessage(title: "Confirmation.", content: "Did you remit your collection to KaBrigadahan Headquarters?", textButtons: textButtons)
                    );
                  }
              ),
            ],
          ),
        ));
  }

  Widget _qrFormAO(String areaOfficerQR, String amount, String referenceNumber, String communityOfficerName, String communityOfficerIdNumber){
    return SizedBox(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 250,
                width: 250,
                child: Center(
                  child: QrImage(
                    data: areaOfficerQR,
                    size: 350.0,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$referenceNumber\n',
                      style: GoogleFonts.lato(color: Colors.red, fontWeight: FontWeight.w900),
                    ),
                    TextSpan(
                      text: 'Reference Number',
                      style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w500),
                    )
                  ]
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.0.h),
            RichText(
              text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Php ${double.parse(amount).toStringAsFixed(2)}\n',
                      style: GoogleFonts.lato(color: Colors.red, fontWeight: FontWeight.w900),
                    ),
                    TextSpan(
                      text: 'Amount',
                      style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w500),
                    )
                  ]
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.0.h),
            RichText(
              text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$communityOfficerName\n',
                      style: GoogleFonts.lato(color: Colors.red, fontWeight: FontWeight.w900),
                    ),
                    TextSpan(
                      text: 'Name',
                      style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w500),
                    )
                  ]
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.0.h),
            RichText(
              text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$communityOfficerIdNumber\n',
                      style: GoogleFonts.lato(color: Colors.red, fontWeight: FontWeight.w900),
                    ),
                    TextSpan(
                      text: 'ID Number',
                      style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w500),
                    )
                  ]
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> showRemittanceMasterDonationDetailsLocal (AreaOfficerMasterInProgress areaOfficer, BuildContext context) async {
    String? accessToken = await GetPreferences().getStoredAccessToken();
    String? accessTokenRes = 'Bearer $accessToken';

    String memberRemittanceMasterId = areaOfficer.memberRemittanceMasterID.toString();

    GetRemittancerMasterDonationDetailsParams getRemittancerMasterDonationDetailsParams =
    GetRemittancerMasterDonationDetailsParams(
        authorizationHeader: accessTokenRes,
        memberRemittanceMasterId: memberRemittanceMasterId
    );

    final mobileTransactionBloc = BlocProvider.of<MobileTransactionBloc>(context);
    mobileTransactionBloc.add(ShowRemittanceMasterDetailsEvent(getRemittancerMasterDonationDetailsParams, areaOfficer.memberRemittanceMasterID
        .toString(), context));

    await Future.delayed(const Duration(seconds: 5), (){});
    super.setState(() {

    });
    return true;
  }

  Future<void> getRemittanceMasterDonationDetailsLocal (AreaOfficerMasterInProgress areaOfficer, List<AreaOfficerMasterInProgress> areaOfficerMasterLocalList, BuildContext context, VoidCallback
  refresh) async {
    var logger = Logger();
    String? accessToken = await GetPreferences().getStoredAccessToken();
    String? accessTokenRes = 'Bearer $accessToken';

    String memberRemittanceMasterId = areaOfficer.memberRemittanceMasterID.toString();

    GetRemittancerMasterDonationDetailsParams getRemittancerMasterDonationDetailsParams =
    GetRemittancerMasterDonationDetailsParams(
        authorizationHeader: accessTokenRes,
        memberRemittanceMasterId: memberRemittanceMasterId
    );

    final mobileTransactionBloc = BlocProvider.of<MobileTransactionBloc>(context);
    mobileTransactionBloc.add(GetRemittanceMasterDetailsEvent(getRemittancerMasterDonationDetailsParams, areaOfficer.memberRemittanceMasterID.toString(), context, refresh, true));
  }

  // void addData() {
  //   var logger = Logger();
  //   bulkMemberList.clear();
  //
  //   List<dynamic> inProgressDonationUiList = masterRemittanceBox.values.toList();
  //   logger.i(inProgressDonationUiList);
  //
  //   // CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;
  //
  //   for (var i in inProgressDonationUiList) {
  //     AreaOfficerMasterInProgress inProgressDonation = i as AreaOfficerMasterInProgress;
  //   //DONE CREATED AreaOfficerMasterInProgress in JSON FORMAT ready for calling an API
  //     Map<String, dynamic> sampleJson = {
  //       "agentMemberId": inProgressDonation.agentMemberId,
  //       "referenceNumber": inProgressDonation.referenceNumber,
  //       "status": inProgressDonation.status,
  //       "transactionId": '',
  //       "transactionSourceType": 1,
  //       "isVerified": false,
  //       "isVerifiedTransactionDate": '',
  //       "amount": inProgressDonation.amount,
  //       "collectorAgentId": inProgressDonation.agentMemberId,
  //       "collectedDate": inProgressDonation.agentMemberIdNumber,
  //       "paidById": inProgressDonation.creatorID,
  //       "paidDate": inProgressDonation.dateCreated,
  //       "id": inProgressDonation.memberRemittanceMasterID
  //     };
  //
  //     bulkMemberList.add(sampleJson);
  //   }
  //
  //   Map<String, dynamic> jsonResult = {
  //     "collectorMemberId": currentUser.memberId,
  //     "memberRemittanceMasters": bulkMemberList
  //   };
  // }
}
