import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/size_config.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key? key,
    required this.text,
    required this.image,
  }) : super(key: key);
  final String text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(),
        const SizedBox(height: 30.0),
        Center(
          child: Text(
            "KaBrigadahan \nMobile",
            textAlign: TextAlign.center,
            // style: TextStyle(
            //   fontSize: getProportionateScreenWidth(36),
            //   color: kPrimaryColor,
            //   fontWeight: FontWeight.bold,
            // ),
            style: GoogleFonts.notoSans(
                fontSize: getProportionateScreenWidth(30),
                color: kPrimaryColor,
                fontWeight: FontWeight.w900
            ),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(
              fontWeight: FontWeight.w600
          ),
        ),
        const Spacer(flex: 2),
        const SizedBox(height: 50.0),
        Expanded(
          flex: 10,
          child: Image.asset(
            image,
            height: getProportionateScreenHeight(265),
            width: getProportionateScreenWidth(235),
          ),
        ),
      ],
    );
  }
}