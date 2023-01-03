import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:sizer/sizer.dart';

class WelcomeTitle extends StatelessWidget {
  const WelcomeTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.only(
        left: 30.0,
        right: 30.0,
      ),
      child: SizedBox(
        height: 12.5.h,
        width: 80.0.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Welcome!',
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.w900,
                  color: kPrimaryColor,
                  fontSize: 10.0.w),
            ),
            SizedBox(height: 1.0.h),
            Text(
              'Please select where you would want to start.',
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.w500,
                  color: kPrimaryColor,
                  fontSize: 3.0.w),
            )
          ],
        ),
      ),
    ));
  }
}
