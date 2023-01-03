import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/core/utils/dropdown_data/dropdown_data.dart';
import 'package:kabrigadan_mobile/src/core/utils/tenant_settings/brigadahan_funds_code.dart';
import 'package:kabrigadan_mobile/src/core/utils/uuid_generator/uuid_generator.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/current_user.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation/unremitted_donation.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation_ui/unremitted_donation_ui.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_current_user/bloc_members_under_co/members_under_co_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_current_user/current_user_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_mobile_transaction/bloc_mobile_transaction_bloc.dart';
import 'package:logger/logger.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

class CollectionForm extends StatefulWidget {
  final bool isConnected;
  final Barcode? barcode;
  final bool? isBrigadahanId;
  final bool isMember;
  final String? idNumber;

  const CollectionForm({Key? key, required this.isConnected, this.barcode, required this.isBrigadahanId, required this.isMember, this.idNumber}) : super(key: key);

  @override
  _CollectionFormState createState() => _CollectionFormState();
}

enum DonatedTo { kaBrigadahanFoundation, individualCampaign }

class _CollectionFormState extends State<CollectionForm> {
  final currentUserBox = Hive.box('currentUser');
  final unremittedDonationBox = Hive.box('unremittedDonations');
  final unremittedDonationUiBox = Hive.box('unremittedDonationsUi');
  DonatedTo? _donatedTo = DonatedTo.kaBrigadahanFoundation;
  TextEditingController idNumber = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController refNumber = TextEditingController();

  bool _isFoundationDonation = true;
  var logger = Logger();

  List<Map<String, dynamic>> mapMember = DropdownData.mapMember;
  List<String> mapMemberName = DropdownData.mapMemberName;

  @override
  void initState() {
    if (widget.isBrigadahanId == true) {
      var member = mapMember.firstWhere((e) => e['memberId'].toString() == widget.barcode!.code.toString().trim().replaceAll(' ', ''), orElse: () => {});
      if (member.isNotEmpty) {
        idNumber.text = member['memberId'].toString();
        name.text = member['memberName'].toString();
      }
    } else if (widget.isBrigadahanId == false) {
      var member = mapMember.firstWhere((e) => e['cityQrCodeId'].toString() == widget.barcode!.code.toString().trim().replaceAll(' ', ''), orElse: () => {});
      if (member.isNotEmpty) {
        idNumber.text = member['memberId'].toString();
        name.text = member['memberName'].toString();
      }
    }
    if(widget.idNumber != null) {
      idNumber.text = widget.idNumber!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CurrentUserBloc controller = BlocProvider.of<CurrentUserBloc>(context);

    CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;
    var uuid = const Uuid();

    // _isFoundationDonation ? BrigadahanFundsCode.brigadahanFundsCode.toString() : 'NULL';
    if(_isFoundationDonation){
      refNumber.text = BrigadahanFundsCode.brigadahanFundsCode ?? '';
    } else {
      refNumber.text = '';
    }

    bool hasBarcode = widget.barcode != null ? true : false;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            color: Colors.black,
            onPressed: () {
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BodyCommunityCollections()));
              Navigator.pop(context);
            }),
        title: const Text('Collection Form', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(children: [
              Row(children: [
                BlocBuilder<MembersUnderCoBloc, MembersUnderCoState>(
                  builder: (context, state){
                    if(state is GetMembersUnderCoDone){
                      return Expanded(
                        child: DropdownSearch<String>(
                          enabled: widget.isMember,
                          mode: Mode.MENU,
                          showSelectedItems: true,
                          items: DropdownData.mapMemberName,
                          label: "Members",
                          hint: 'Select Member',
                          showClearButton: true,
                          showSearchBox: true,
                          selectedItem: name.text,
                          onChanged: (data) {
                            if (data != null) {
                              var member = DropdownData.mapMember.firstWhere((e) => e['memberName'].toString() == data.toString());
                              idNumber.text = member['memberId'].toString();
                              name.text = member['memberName'].toString();
                            } else {
                              idNumber.clear();
                              name.clear();
                            }
                          },
                        ),
                      );
                    }

                    return const Expanded(
                      child: Center(child: CircularProgressIndicator())
                    );
                  }
                ),
                widget.isConnected
                    ? IconButton(
                        onPressed: () {
                            final membersUnderCoBloc = BlocProvider.of<MembersUnderCoBloc>(context);
                            membersUnderCoBloc.add(const GetMembersUnderCoEvent());
                         setState(() {});
                        },
                        icon: const Icon(
                          CupertinoIcons.refresh_thin,
                          color: Colors.black,
                        ))
                    : const SizedBox(),
              ]),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: idNumber,
                onChanged: (data) {
                  setState(() {});
                  var name = DropdownData.mapMember.firstWhere((e) => e['memberId'].toString() == data.toString(), orElse: () => {});
                  name = name.toString() != '' ? name['memberName'] : '';
                },
                decoration: InputDecoration(
                  labelText: 'ID Number',
                  suffixIcon: IconButton(
                    onPressed: () {
                      idNumber.clear();
                      name.clear();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(
                height: 10,
                thickness: 2,
                indent: 40,
                endIndent: 40,
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: name,
                decoration: InputDecoration(labelText: 'Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                enabled: !widget.isMember,
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {});
                            amount.text = "5";
                          },
                          child: Text('Php 5', style: TextStyle(color: kPrimaryColor, fontSize: 10.0.sp)),
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryLight)),
                        ),
                        SizedBox(
                          width: 5.0.sp,
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {});
                            amount.text = "10";
                          },
                          child: Text('Php 10', style: TextStyle(color: kPrimaryColor, fontSize: 10.0.sp)),
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryLight)),
                        ),
                        SizedBox(
                          width: 5.0.sp,
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {});
                            amount.text = "15";
                          },
                          child: Text(
                            'Php 15',
                            style: TextStyle(color: kPrimaryColor, fontSize: 10.0.sp),
                          ),
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryLight)),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {});
                            amount.text = "20";
                          },
                          child: Text(
                            'Php 20',
                            style: TextStyle(color: kPrimaryColor, fontSize: 10.0.sp),
                          ),
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryLight)),
                        ),
                        SizedBox(
                          width: 5.0.sp,
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {});
                            amount.text = "50";
                          },
                          child: Text('Php 50', style: TextStyle(color: kPrimaryColor, fontSize: 10.0.sp)),
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryLight)),
                        ),
                        SizedBox(
                          width: 5.0.sp,
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {});
                            amount.text = "100";
                          },
                          child: Text('Php 100', style: TextStyle(color: kPrimaryColor, fontSize: 10.0.sp)),
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryLight)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: amount,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onChanged: (val) {
                    setState(() {});
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Donated to:',
                    style: TextStyle(color: Colors.black, fontSize: 15.0.sp),
                  ),
                  ListTile(
                      title: const Text('Kabrigadahan Foundation'),
                      leading: Radio<DonatedTo>(
                        value: DonatedTo.kaBrigadahanFoundation,
                        groupValue: _donatedTo,
                        onChanged: (DonatedTo? value) {
                          setState(() {
                            _isFoundationDonation = true;

                            _donatedTo = value;
                            logger.i(_donatedTo);
                          });
                        },
                      )),
                  // ListTile(
                  //     title: const Text('Individual Campagin'),
                  //     leading: Radio<DonatedTo>(
                  //       value: DonatedTo.individualCampaign,
                  //       groupValue: _donatedTo,
                  //       onChanged: (DonatedTo? value) {
                  //         setState(() {
                  //           _isFoundationDonation = false;
                  //
                  //           _donatedTo = value;
                  //           logger.i(_donatedTo);
                  //         });
                  //       },
                  //     ))
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: refNumber,
                decoration: InputDecoration(
                  labelText: _isFoundationDonation ? 'Ref Number' : 'Case Code',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                enabled: _isFoundationDonation ? false : true,
              ),
              const SizedBox(height: 15,),
              saveButton(uuid, context, controller, currentUser, amount, idNumber),
            ]),
          )),
        ],
      ),
    );
  }

  ElevatedButton saveButton(Uuid uuid, BuildContext context, CurrentUserBloc controller, CurrentUser currentUser, TextEditingController amount, TextEditingController idNumber) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 25.0.w, vertical: 2.0.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
            primary: amount.text.isEmpty || idNumber.text.isEmpty ? Colors.grey : kPrimaryLight,
            onPrimary: kPrimaryColor),
            onPressed: amount.text.isEmpty || idNumber.text.isEmpty
            ? () {}
            : () {
                logger.i(refNumber.text);
                popDialog(uuid, context, controller, currentUser, idNumber);
              },
        child: Text(
          'Add',
          style: TextStyle(color: amount.text.isEmpty || idNumber.text.isEmpty ? Colors.white : kPrimaryColor),
        ));
  }

  Future<void> popDialog(Uuid uuid, BuildContext contextDiag, CurrentUserBloc controller, CurrentUser currentUser, TextEditingController idNumber) async {
    String tempId = await UuidGenerator().generateUuid();

    String qrData = "{"
        "\"transactionId\": \"$tempId\","
        "\"officerName\": \"${currentUser.name}\","
        "\"officerIdNumber\": \"${currentUser.idNumber}\","
        "\"donorIdNumber\": \"${idNumber.text}\","
        "\"amount\": \"${amount.text}\""
        "}";


    logger.i(qrData);

    bool _isMultiClick = false;
    showDialog(
        context: contextDiag,
        builder: (contextDiag) => AlertDialog(
              title: const Text('Generated ID:'),
              content: _qrForm(qrData, tempId, currentUser.name, amount.text),
              actions: [
                TextButton(
                    onPressed: () {
                      if(!_isMultiClick){
                        UnremittedDonation unremittedDonation = UnremittedDonation(
                            caseCode: refNumber.text,
                            amount: double.parse(amount.text),
                            donatedByMemberIdNumber: idNumber.text,
                            agentMemberIdNumber: currentUser.idNumber,
                            status: 1,
                            memberRemittanceMasterId: null,
                            ayannahAttachment: null,
                            unremittedTempId: tempId,
                            id: null,
                            creatorId: currentUser.memberId,
                            referenceNumber: null);

                        UnremittedDonationUi unremittedDonationUi = UnremittedDonationUi(
                            caseCode: refNumber.text,
                            amount: double.parse(amount.text),
                            donatedByMemberIdNumber: idNumber.text,
                            agentMemberIdNumber: currentUser.idNumber,
                            status: 1,
                            memberRemittanceMasterId: null,
                            ayannahAttachment: null,
                            unremittedTempId: tempId,
                            id: null,
                            name: name.text,
                            dateRecorded: DateTime.now(),
                            creatorId: currentUser.memberId,
                            referenceNumber: null);

                        unremittedDonationBox.add(unremittedDonation);
                        unremittedDonationUiBox.add(unremittedDonationUi);

                        setState(() {
                          const snackBar = SnackBar(
                            content: Text('Donation Received!'),
                            duration: Duration(seconds: 2),
                          );

                          Future.delayed(const Duration(seconds: 1), () async{
                            Navigator.pop(contextDiag);
                            ScaffoldMessenger.of(contextDiag).showSnackBar(snackBar);
                            idNumber.clear();
                            name.clear();
                            amount.clear();
                            refNumber.clear();
                            /// Sync data
                            var connectivityResult = await (Connectivity().checkConnectivity());
                            if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
                              final mobileTransactionBloc = BlocProvider.of<MobileTransactionBloc>(context);
                              mobileTransactionBloc.add(SyncUnremittedDonationEvent(context));
                              mobileTransactionBloc.add(const SyncUnremittedDonationCOEvent());
                              setState(() {});
                            }
                          });
                          _isMultiClick = true;
                        });
                      }else{
                        debugPrint('Multipled click is not valid!!!!');
                      }
                    },
                    child: const Text('Donation Received')),
              ],
            ));
  }

  Widget _qrForm(String qrData, String transactionId, String? officerName, String amount) {
    return SizedBox(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 150,
                width: 150,
                child: Center(
                  child: QrImage(
                    data: qrData,
                    size: 350.0,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: '$transactionId\n',
                  style: GoogleFonts.lato(color: Colors.red, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: 'Transaction Id',
                  style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w500),
                )
              ]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.0.h),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: officerName != null ? '$officerName\n' : 'Officer Name\n',
                  style: GoogleFonts.lato(color: Colors.red, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: 'Officer Name',
                  style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w500),
                )
              ]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.0.h),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Php ${double.parse(amount).toStringAsFixed(2)}\n',
                  style: GoogleFonts.lato(color: Colors.red, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: 'Amount',
                  style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w500),
                )
              ]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.0.h),
            RichText(
                text: TextSpan(
              children: [
                TextSpan(
                  text: 'Note: Please tap Donation Received to complete this transaction.',
                  style: GoogleFonts.lato(color: Colors.red, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic ),
                )
              ]
            ))
          ],
        ),
      ),
    );
  }
}
