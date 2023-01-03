import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kabrigadan_mobile/src/core/utils/messages/warning_message/warning_message.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_donations/donations_bloc.dart';
import 'package:sizer/sizer.dart';

class TotalDonatedAmount extends StatelessWidget {
  final double? totalAmount;
  final Color backgroundColor;
  final String title;

  const TotalDonatedAmount(this.totalAmount, {Key? key, required this.backgroundColor, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // double defFontSize = getDeviceType() == 'phone' ? 12.0.sp : 8.0.sp;
    // double height = MediaQuery.of(context).size.height;
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 40.0,
              width: 100.0.w,
              decoration: BoxDecoration(
                color: backgroundColor,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
                child: Row(
                  children: [
                    Text(
                      title,
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
            SizedBox(height: 0.5.h),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 18.0.h,
                width: 95.0.w,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Total Amount Donated",
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                      const Divider(),
                      SizedBox(height: 1.0.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Php", style: GoogleFonts.lato(color: Colors.green, fontWeight: FontWeight.w900, fontSize: 12.sp)),
                          SizedBox(width: 0.5.w),
                          Text(totalAmount!.toStringAsFixed(2), style: GoogleFonts.lato(color: Colors.green, fontWeight: FontWeight.w900, fontSize: 12.sp))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
