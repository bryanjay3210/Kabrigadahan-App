import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/welcome_screen/body/slider_list.dart';
import 'package:sizer/sizer.dart';

class SlidersWelcome extends StatefulWidget {
  const SlidersWelcome({Key? key}) : super(key: key);

  @override
  _SlidersWelcomeState createState() => _SlidersWelcomeState();
}

class _SlidersWelcomeState extends State<SlidersWelcome> {
  @override
  Widget build(BuildContext context) {
    SlidersList.setSliderContext(context);

    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: SizedBox(
        height: 55.0.h,
        width: 100.0.w,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: [
                  Text(
                    "Explore. ",
                    style: GoogleFonts.ubuntu(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Read. ",
                    style: GoogleFonts.ubuntu(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Register. ",
                    style: GoogleFonts.ubuntu(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50.0.h,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        SlidersList.sliders[index],
                        SizedBox(width: 2.0.h),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    ));
  }
}
