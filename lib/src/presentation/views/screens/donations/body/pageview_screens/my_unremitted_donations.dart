import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/core/utils/enums/remittance/enum_remittance.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/warning_message/warning_message.dart';
import 'package:kabrigadan_mobile/src/core/utils/tenant_settings/brigadahan_funds_code.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/unremitted_donation/unremitted_donation_fromserver.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_donations/sync_donations_bloc/sync_donations_bloc.dart';
import 'package:logger/logger.dart';
import 'package:sizer/sizer.dart';

class MyUnremittedDonations extends StatefulWidget {
  const MyUnremittedDonations({Key? key}) : super(key: key);

  @override
  _MyUnremittedDonationsState createState() => _MyUnremittedDonationsState();
}

class _MyUnremittedDonationsState extends State<MyUnremittedDonations> {
  final myUnremittedDonationsBox = Hive.box('myUnremittedDonations');
  final myUnremittedFromServerBox = Hive.box('unremittedDonationsFromServer');
  final currentUserBox = Hive.box('currentUser');

  final String unremittedDescriptionText = "This donation has not yet received by the ${BrigadahanFundsCode.brigadahanFundsRecipient.toString()}. "
      "This will be cleared once the donations has been received by the ${BrigadahanFundsCode.brigadahanFundsRecipient.toString()}. "
      "Contact your Kabrigadahan Officer if donations are taking too long to process.";

  var logger = Logger();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == 0) {
          // You're at the top.
        } else {
          final synDonationsBloc = BlocProvider.of<SyncDonationsBloc>(context);
          synDonationsBloc.add(const PostSyncDonationsDonorEvent());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: Scaffold(
        body: Container(
          color: kBackgroundColor,
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              _buildMyUnremittedDescription(context),
              BlocBuilder<SyncDonationsBloc, SyncDonationsState>(
                builder: (context, state){
                  if(state is SyncDoneDonorDonationState){
                    List<UnremittedDonationFromServer> myUnremittedDonationsFromServerList = state.listUnremittedDonationServer;
                    bool noMoreData = state.noMoreData;

                    return myUnremittedDonationsFromServerList.isNotEmpty ?
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          return Column(
                            children: [
                              Container(
                                width: 95.0.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.white,
                                ),
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: Colors.orange,
                                    backgroundImage: AssetImage('assets/images/pesoDonation.png'),
                                  ),
                                  title: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: 'Php ',
                                          style: GoogleFonts.lato(fontWeight: FontWeight.w300, color: Colors.black, fontSize: 12.0.sp),
                                        ),
                                        TextSpan(
                                          text: double.parse(myUnremittedDonationsFromServerList[index].amount.toString()).toStringAsFixed(2),
                                          style: GoogleFonts.lato(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 12.0.sp),
                                        )
                                      ])),
                                  subtitle: Text(
                                    myUnremittedDonationsFromServerList[index].unremittedTempId ?? '',
                                    style: GoogleFonts.lato(fontSize: 8.0.sp),
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 5.0),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            enumRemittanceValue(Remittance.values[myUnremittedDonationsFromServerList[index].status! - 1]),
                                            style: GoogleFonts.lato(fontSize: 10.0.sp, color: Colors.red),
                                          ),
                                          SizedBox(
                                            height: 3.0.h,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 2.0.h),
                            ],
                          );
                        },
                        childCount: myUnremittedDonationsFromServerList.length,
                      ),
                    ) : const SliverToBoxAdapter(child: SizedBox(width: 0));
                  } else {
                    return SliverToBoxAdapter(
                      child: SizedBox(
                        height: 70.0.h,
                        child: const Center(
                            child: CircularProgressIndicator()
                        ),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: kPrimaryColor,
        //   onPressed: () async {
        //     var connectivityResult = await (Connectivity().checkConnectivity());
        //     if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        //       setState(() {
        //         final myUnremittedFromServerBox = Hive.box('unremittedDonationsFromServer');
        //         myUnremittedFromServerBox.clear().then((value){
        //           SyncDonationsBloc.syncSkipCount = 0;
        //           final syncDonationsBloc = BlocProvider.of<SyncDonationsBloc>(context);
        //           syncDonationsBloc.add(const PostSyncButtonDonationsDonorEvent());
        //         });
        //       });
        //     } else {
        //       showDialog(context: context, builder: (context) => const WarningMessage(title: "Warning", content: "No internet connection. Please try again later."));
        //     }
        //   },
        //   child: const Icon(Icons.sync_outlined),
        // ),
      ),
    );
  }

  Widget _buildMyUnremittedDescription(BuildContext context) {
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: kYellowColor,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
                child: Row(
                  children: [
                    Text(
                      'My Unremitted Donations',
                      style: GoogleFonts.lato(fontWeight: FontWeight.w900, color: Colors.black),
                    ),
                    const Spacer(),
                    IconButton(onPressed: () async {
                      var connectivityResult = await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
                        setState(() {
                          final myUnremittedFromServerBox = Hive.box('unremittedDonationsFromServer');
                          myUnremittedFromServerBox.clear().then((value){
                            SyncDonationsBloc.syncSkipCount = 0;
                            final syncDonationsBloc = BlocProvider.of<SyncDonationsBloc>(context);
                            syncDonationsBloc.add(const PostSyncButtonDonationsDonorEvent());
                          });
                        });
                      } else {
                        showDialog(context: context, builder: (context) => const WarningMessage(title: "Warning", content: "No internet connection. Please try again later."));
                      }
                    }, icon: const Icon(Icons.refresh),)
                  ],
                ),
              ),
            ),
            SizedBox(height: 0.5.h),
            BlocBuilder<SyncDonationsBloc, SyncDonationsState>(
                builder: (context, state){
                  if(state is SyncDoneDonorDonationState){
                    List<UnremittedDonationFromServer> myUnremittedDonationsFromServerList = state.listUnremittedDonationServer;

                    return myUnremittedDonationsFromServerList.isNotEmpty
                        ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Reminder",
                                    style: GoogleFonts.lato(fontWeight: FontWeight.w600, letterSpacing: 1.0),
                                  ),
                                ),
                                const Divider(),
                                SizedBox(height: 1.0.h),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 16.0),
                                  child: Text(
                                    unremittedDescriptionText,
                                    style: const TextStyle(letterSpacing: 1.0),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                        : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "No Data",
                                    style: GoogleFonts.lato(fontWeight: FontWeight.w600, letterSpacing: 1.0),
                                  ),
                                ),
                                const Divider(),
                                SizedBox(height: 1.0.h),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 16.0),
                                  child: Text(
                                    'You have no unremitted donations as of this moment.',
                                    style: TextStyle(letterSpacing: 1.0),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else{
                    return const SizedBox(height: 0);
                  }
                }
            )
          ],
        ),
      ),
    );
  }

  void _onScrollListener(BuildContext context, ScrollController scrollController) {
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    final synDonationsBloc = BlocProvider.of<SyncDonationsBloc>(context);

    if (currentScroll == maxScroll) {
      synDonationsBloc.add(const PostSyncDonationsDonorEvent());
    }
  }
}
