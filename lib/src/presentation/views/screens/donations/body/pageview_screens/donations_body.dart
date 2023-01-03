import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/warning_message/warning_message.dart';
import 'package:kabrigadan_mobile/src/core/utils/tenant_settings/brigadahan_funds_code.dart';
import 'package:kabrigadan_mobile/src/core/utils/text_checker/text_checker.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_donations/donations_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/donations/body/total_donated_amount.dart';
import 'package:sizer/sizer.dart';

class DonationsBody extends StatefulWidget {
  // final DonationsEntity donationsEntity;

  const DonationsBody({Key? key}) : super(key: key);

  @override
  _DonationsBodyState createState() => _DonationsBodyState();
}

class _DonationsBodyState extends State<DonationsBody> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: BlocBuilder<DonationsBloc, DonationsState>(
          builder: (_, state){
            if(state is DonationsDone){
              double? totalDonations = state.donationsEntity!.totalDonations;
              return Container(
                color: kBackgroundColor,
                child: SafeArea(
                  child: CustomScrollView(
                    slivers: [
                      TotalDonatedAmount(totalDonations, backgroundColor: kChipColor, title: 'My Donations List'),
                      state.donationsEntity!.items!.isNotEmpty
                          ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'List of Donations',
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w900,
                                fontSize: 9.0.sp
                            ),
                          ),
                        ),
                      )
                          : const SliverToBoxAdapter(child: SizedBox(width: 0)),
                      state.donationsEntity!.items!.isNotEmpty
                          ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            String? brigadahanFundsCode = BrigadahanFundsCode.brigadahanFundsCode;
                            String? brigadahanRecipient = BrigadahanFundsCode.brigadahanFundsRecipient;

                            bool hasRecipient = state.donationsEntity!.items![index].recipient.toString() != ""
                                ? state.donationsEntity!.items![index].recipient.toString() == brigadahanFundsCode.toString()
                                ? false
                                : true
                                : false;

                            String? recipient = textLenghtChecker(state.donationsEntity!.items![index].recipient!, 8);
                            String dateDonated = DateFormat.yMMMMd('en_US').format(DateTime.parse(state.donationsEntity!.items![index].dateTimeDonated!)).toString();

                            String? recipientDialog = state.donationsEntity!.items![index].recipient! == "" ? brigadahanRecipient : state.donationsEntity!.items![index].recipient!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 95.0.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Colors.white,
                                  ),
                                  child: GestureDetector(
                                    onTap: (){
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text(
                                                'Donation details:'
                                            ),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    recipientDialog!,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w900,
                                                        fontSize: 11.0.sp
                                                    ),
                                                  ),
                                                  Text(
                                                    'Recipient',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 11.0.sp
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20.0),
                                                  Text(
                                                    'Php ${state.donationsEntity!.items![index].amountDonated!.toStringAsFixed(2)}',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w900,
                                                        fontSize: 12.0.sp
                                                    ),
                                                  ),
                                                  Text(
                                                    'Amount',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 12.0.sp
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20.0),
                                                  Text(
                                                    dateDonated,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w900,
                                                        fontSize: 11.0.sp
                                                    ),
                                                  ),
                                                  Text(
                                                    'Date Donated',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 11.0.sp
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                      );
                                    },
                                    child: ListTile(
                                      leading: const CircleAvatar(
                                        backgroundColor: Colors.orange,
                                        backgroundImage: AssetImage('assets/images/pesoDonation.png'),
                                      ),
                                      title: RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                              text: 'Php ',
                                              style: GoogleFonts.lato(fontWeight: FontWeight.w300, color: Colors.black,fontSize: 9.0.sp),
                                            ),
                                            TextSpan(
                                              text: state.donationsEntity!.items![index].amountDonated!.toStringAsFixed(2),
                                              style: GoogleFonts.lato(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 9.0.sp),
                                            )
                                          ])),
                                      subtitle: hasRecipient
                                          ? Text(
                                        'Recipient: $recipient',
                                        style: GoogleFonts.lato(fontSize: 9.0.sp),
                                      )
                                          : null,
                                      trailing: Text(
                                        dateDonated,
                                        style: GoogleFonts.lato(fontSize: 9.0.sp),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 1.0.h),
                              ],
                            );
                          },
                          childCount: state.donationsEntity!.items!.length,
                        ),
                      )
                          : const SliverToBoxAdapter(child: SizedBox(width: 0))
                    ],
                  ),
                ),
              );
            }

            if(state is DonationsLoading){
              return Container(color: kBackgroundColor,child: Stack(
                children: [
                  Container(
                    height: 40.0,
                    width: 100.0.w,
                    decoration: const BoxDecoration(
                      color: kChipColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
                      child: Row(
                        children: [
                          Text(
                            "My Donations List",
                            style: GoogleFonts.lato(fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                          const Spacer(),
                          IconButton(onPressed: () async{
                            var connectivityResult = await (Connectivity().checkConnectivity());
                            if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
                              final donationsBloc = BlocProvider.of<DonationsBloc>(context);
                              donationsBloc.add(const DonationsLoadingEvent());
                              donationsBloc.add(const GetDonationsEvent());
                            } else {
                              showDialog(context: context, builder: (context) => const WarningMessage(title: "Warning", content: "No internet connection. Please try again later."));
                            }
                          },
                              icon: const Icon(Icons.refresh, color: Colors.white))
                        ],
                      ),
                    ),
                  ),
                  const Center(child: CircularProgressIndicator()),
                ],
              ));
            }

            return const SizedBox(width: 0);
          }
      ),
    );
  }
}
