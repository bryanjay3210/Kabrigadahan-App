import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/splash/component/splash_content.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/welcome_screen/welcome_screen.dart';
import 'package:kabrigadan_mobile/src/size_config.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to the KaBrigadahan Mobile!",
      "image": "assets/images/community.png"
    },
    {
      "text": "Explore the app. \nRead the news. \nVisit the website.",
      "image": "assets/images/evc-cropped.png"
    },
    {
      "text": "Let's get started!",
      "image": "assets/images/brigadahanLogo.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  image: splashData[index]["image"]!,
                  text: splashData[index]['text']!,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: <Widget>[
                    const Spacer(),
                    // SizedBox(height: 60.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                            (index) => buildDot(index: index),
                      ),
                    ),
                    const Spacer(flex: 3),
                  SizedBox(
                    width: double.infinity,
                    height: getProportionateScreenHeight(56),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: kPrimaryColor,
                      onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Dashboard())),
                      child: Text(
                        'Continue',
                        // style: TextStyle(
                        //   fontSize: getProportionateScreenWidth(18),
                        //   color: Colors.white,
                        // ),
                        style: GoogleFonts.lato(
                            fontSize: getProportionateScreenWidth(18),
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}