import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:kabrigadan_mobile/src/core/params/mobile_transaction/get_remittance_master_donation_details/get_remittancer_master_donation_details_master.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/core/utils/enums/remittance/enum_remittance.dart';
import 'package:kabrigadan_mobile/src/core/utils/mobile_transaction/show_member_remittance_master_helper.dart';
import 'package:kabrigadan_mobile/src/core/utils/shared_preferences/get_preferences.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/area_officer_master/area_officer_master.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/current_user.dart';
import 'package:kabrigadan_mobile/src/domain/entities/mobile_transaction/received/member_unremitted_donation_results.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_mobile_transaction/bloc_mobile_transaction_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';

class ListOfUnremittedDonationsComplete extends StatefulWidget {
  final VoidCallback? refresh;
  const ListOfUnremittedDonationsComplete({Key? key, this.refresh}) : super(key: key);

  @override
  _ListOfUnremittedDonationsCompleteState createState() => _ListOfUnremittedDonationsCompleteState();
}

class _ListOfUnremittedDonationsCompleteState extends State<ListOfUnremittedDonationsComplete> {
  final masterRemittanceBox = Hive.box('areaOfficerMaster');

  @override
  Widget build(BuildContext context) {
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
                      'List Of Completed Remittance',
                      style: GoogleFonts.lato(fontWeight: FontWeight.w900, fontSize: 12.0.sp),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              final mobileTransactionBloc = BlocProvider.of<MobileTransactionBloc>(context);

                              List<dynamic> masterRemittanceList = masterRemittanceBox.values.toList();

                              masterRemittanceBox.clear();
                              mobileTransactionBloc.add(const GetCurrentUserRemittanceMasterEvent());
                            },
                            icon: const Icon(
                              CupertinoIcons.refresh_thin,
                              color: Colors.black,
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
            BlocBuilder<MobileTransactionBloc, MobileTransactionState>(
              builder: (context, state){
                if(state is GetCurrentUserMasterRemittanceDoneState){
                  final complete = BlocProvider.of<MobileTransactionBloc>(context);
                  List<AreaOfficerMaster> areaOfficerMasterList = complete.areaOfficerMasterCompleteList;

                  return Expanded(
                      child: areaOfficerMasterList.isNotEmpty
                          ? ListView.builder(
                          itemCount: areaOfficerMasterList.length,
                          itemBuilder: (context, index) {
                            AreaOfficerMaster areaOfficer = areaOfficerMasterList[index];

                            String stringStatus = areaOfficer.status != null ? EnumRemittance.remitStatusLabel[areaOfficer.status!-1] : '';

                            String? completedDate = areaOfficer.completedDate.toString().trim();
                            String formatedDate = completedDate == 'null' ? 'null' : DateFormat('yyyy-MM-dd').parse(completedDate).toString().substring(0, 10);

                            return Card(
                              child: ListTile(
                                isThreeLine: true,
                                leading: const Icon(Icons.check_circle, color: Colors.blue),
                                title: Text('${areaOfficer.referenceNumber}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text('Status: $stringStatus'),
                                    const SizedBox(height: 5,),
                                    completedDate == 'null' ? const SizedBox(height: 0,) : Text(formatedDate)
                                  ],),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('${double.parse(areaOfficer.amount!).toStringAsFixed(2)} pesos', style: const TextStyle(color: Colors.grey)),
                                    // const SizedBox(height: 5.0),
                                    Text(areaOfficer.transactionType, style: TextStyle(color: Colors.red, fontSize: 9.0.sp), textAlign: TextAlign.center,),
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
                                                        '\"amount\": ${areaOfficer.amount},'
                                                        '\"referenceNumber\": \"${areaOfficer.referenceNumber}\",'
                                                        '\"communityOfficeIdNumber\": \"${areaOfficer.communityOfficeId}\",'
                                                        '\"communityOfficeName\": \"${areaOfficer.communityOfficerName}\",'
                                                        '\"communityOfficeMemberId\": \"${areaOfficer.agentMemberIdNumber}\",'
                                                        '\"memberRemittanceMasterID\": \"${areaOfficer.memberRemittanceMasterID}\"'
                                                        '}';

                                                    showDialog(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          content: _qrFormAO(
                                                            areaOfficerQR,
                                                            areaOfficer.amount.toString(),
                                                            areaOfficer.referenceNumber.toString(),
                                                            areaOfficer.communityOfficerName.toString(),
                                                            areaOfficer.agentMemberIdNumber.toString(),
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

                                                    List<MemberUnremittedDonationResultsEntity> listMemberMasterCollection = ShowMemberRemittanceMasterHelper.listMemberMasters.value;

                                                    showDialog(
                                                        context: context,
                                                        builder: (context) => FutureBuilder(
                                                            future: showRemittanceMasterDonationDetails(areaOfficer, context),
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
                            );
                          })
                          : const Padding(
                        padding: EdgeInsets.all(30.0),
                        child: Center(child: Text('No data.')),
                      ));
                } else {
                  return const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              })
          ],
        ),
      ),
    );

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

  Future<bool> showRemittanceMasterDonationDetails(AreaOfficerMaster areaOfficer, BuildContext context) async {
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

    // Future.delayed(const Duration(seconds: 10), (){});

    await Future.delayed(const Duration(seconds: 5), (){});
    super.setState(() {

    });
    return true;
  }

  Future<void> getRemittanceMasterDonationDetails(AreaOfficerMaster areaOfficer, BuildContext context, VoidCallback refresh) async {
    String? accessToken = await GetPreferences().getStoredAccessToken();
    String? accessTokenRes = 'Bearer $accessToken';

    String memberRemittanceMasterId = areaOfficer.memberRemittanceMasterID.toString();

    GetRemittancerMasterDonationDetailsParams getRemittancerMasterDonationDetailsParams =
    GetRemittancerMasterDonationDetailsParams(
        authorizationHeader: accessTokenRes,
        memberRemittanceMasterId: memberRemittanceMasterId
    );

    final mobileTransactionBloc = BlocProvider.of<MobileTransactionBloc>(context);
    mobileTransactionBloc.add(GetRemittanceMasterDetailsEvent(getRemittancerMasterDonationDetailsParams, areaOfficer.memberRemittanceMasterID.toString(), context, refresh, false));
  }
}
