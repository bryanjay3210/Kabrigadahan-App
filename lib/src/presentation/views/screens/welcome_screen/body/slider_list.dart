import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

const String _paragraph =
    "\"Daghang salamat igsoon sa imong boluntaryong pagdawat nga mamahimo kitang instrumento "
    "ug tubag sa mga panalangin sa atong mga igsoon nga nanginahanglan ug tabang. \n\nMalipayon "
    "ug mapasalamaton ako sa imong malumong kasingkasing ug simpatiya. Hingpit ang akong"
    "pagtu-o nga ikaw adunay igong gugma ug kaluoy aron motabang labaw na sa mga "
    "nanginahanglan. \n\nKana tungod ikaw usa ka bayani sa imong isigkatawo. \n\nAng imong "
    "pagkabayani tima-ilhan sa imong pagtu-o nga ang tinuod nga gahum, ana-a sa kadaghanan, gahum nga naga-gikan sa "
    "matag-usa kanato. \n\nAna-a kanimo ang tinuod nga kusog sa programang KaBrigadahan. "
    "\n\nAng akong pag-ampo nga magpadayun kita sa pakighi-usa ug pagbarug "
    "para sa atong kaugmaon. \n\nAng Diyos magapanalangin kanimo ug sa imong pamilya.Kanunay "
    "Nimong KaBrigadahan\"";

ContainerTransitionType _transitionType = ContainerTransitionType.fade;

late BuildContext slidersContext;

class SlidersList {
  static void setSliderContext(BuildContext context) {
    slidersContext = context;
  }

  static List<Widget> sliders = [
    Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        top: 10.0,
      ),
      child: Container(
        height: 45.0.h,
        width: 50.0.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: _OpenContainerWrapper(
          transitionType: _transitionType,
          closedBuilder: (BuildContext _, VoidCallback openContainer) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(slidersContext, '/Auth');
              },
              child: _SmallerCardNavigator(
                cardPicture: 'assets/images/scrolling.png',
                title: 'Explore',
                openContainer: openContainer,
                subtitle:
                    'Scroll through newsfeeds. Customize your profile. Explore the app now!',
                color: Colors.red,
                titleColor: kWhiteColor,
                subtitleColor: kWhiteColor,
              ),
            );
          },
          onClosed: (bool? data) {},
        ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        top: 10.0,
      ),
      child: Container(
        height: 45.0.h,
        width: 50.0.w,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: _OpenContainerWrapper(
          transitionType: _transitionType,
          closedBuilder: (BuildContext _, VoidCallback openContainer) {
            return _SmallerCard(
              cardPicture: 'assets/images/reading.gif',
              title: 'Welcome, KaBrigadahan',
              openContainer: openContainer,
              subtitle:
                  'Read Elmer V. Catulpos message for our fellow KaBrigadahan.',
              color: kYellowColor,
              titleColor: kWhiteColor,
              subtitleColor: kWhiteColor,
            );
          },
          onClosed: (bool? data) {},
        ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        top: 10.0,
      ),
      child: Container(
        height: 45.0.h,
        width: 50.0.w,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: _OpenContainerWrapper(
          transitionType: _transitionType,
          closedBuilder: (BuildContext _, VoidCallback openContainer) {
            return GestureDetector(
              onTap: () async {
                try {
                  await launch("$kBaseUrl/account/register");
                } on Exception {
                  throw 'Could not launch "$kBaseUrl/account/register"';
                }
              },
              child: _SmallerCardNavigator2(
                cardPicture: 'assets/images/registration.png',
                title: 'Register now!',
                openContainer: openContainer,
                subtitle: 'Help a KaBrigadahan. Be a member now!',
                color: Colors.orange,
                titleColor: kWhiteColor,
                subtitleColor: kWhiteColor,
              ),
            );
          },
          onClosed: (bool? data) {},
        ),
      ),
    ),
  ];
}

class _OpenContainerWrapper extends StatelessWidget {
  const _OpenContainerWrapper({
    required this.closedBuilder,
    required this.transitionType,
    required this.onClosed,
  });

  final CloseContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final ClosedCallback<bool?>? onClosed;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      transitionType: transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        return const _DetailsPage();
      },
      onClosed: onClosed,
      tappable: false,
      closedBuilder: closedBuilder,
    );
  }
}

class _SmallerCard extends StatelessWidget {
  const _SmallerCard(
      {this.cardPicture,
      this.title,
      this.openContainer,
      this.subtitle,
      this.color,
      this.titleColor,
      this.subtitleColor});

  final String? cardPicture;
  final String? title;
  final VoidCallback? openContainer;
  final String? subtitle;
  final Color? color;
  final Color? titleColor;
  final Color? subtitleColor;

  @override
  Widget build(BuildContext context) {
    return _InkWellOverlay(
      openContainer: openContainer,
      height: 20.0.h,
      child: Container(
        color: color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 15.0.h,
              child: Center(
                child: Image.asset(
                  cardPicture!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title!,
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w900,
                          fontSize: 2.5.h,
                          color: titleColor),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle!,
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w400, color: subtitleColor)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallerCardNavigator extends StatelessWidget {
  const _SmallerCardNavigator(
      {this.cardPicture,
      this.title,
      this.openContainer,
      this.subtitle,
      this.color,
      this.titleColor,
      this.subtitleColor});

  final String? cardPicture;
  final String? title;
  final VoidCallback? openContainer;
  final String? subtitle;
  final Color? color;
  final Color? titleColor;
  final Color? subtitleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 15.0.h,
            child: Center(
              child: Image.asset(
                cardPicture!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title!,
                    style: GoogleFonts.lato(
                        fontWeight: FontWeight.w900,
                        fontSize: 2.5.h,
                        color: titleColor),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle!,
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w400, color: subtitleColor)),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          Navigator.pushNamed(slidersContext, '/Auth');
                        }),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallerCardNavigator2 extends StatelessWidget {
  const _SmallerCardNavigator2(
      {this.cardPicture,
      this.title,
      this.openContainer,
      this.subtitle,
      this.color,
      this.titleColor,
      this.subtitleColor});

  final String? cardPicture;
  final String? title;
  final VoidCallback? openContainer;
  final String? subtitle;
  final Color? color;
  final Color? titleColor;
  final Color? subtitleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 15.0.h,
            child: Center(
              child: Image.asset(
                cardPicture!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title!,
                    style: GoogleFonts.lato(
                        fontWeight: FontWeight.w900,
                        fontSize: 2.5.h,
                        color: titleColor),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle!,
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w400, color: subtitleColor)),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () async {
                          try {
                            await launch("$kBaseUrl/account/register");
                          } on Exception {
                            throw 'Could not launch "$kBaseUrl/account/register"';
                          }
                        }),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsPage extends StatelessWidget {
  const _DetailsPage({this.includeMarkAsDoneButton = true});

  final bool includeMarkAsDoneButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: kPrimaryColor),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 150,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Card(
                  color: kPastelRed,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                        child: SizedBox(
                          height: 15.0.h,
                          child: Image.asset(
                            'assets/images/evc-cropped.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "KaBrigadahan",
                            style: GoogleFonts.lato(
                                fontSize: 2.5.h,
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                          ),
                          Text(
                            "Gensan",
                            style: GoogleFonts.lato(
                                fontSize: 2.5.h,
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            "Elmer V. Catulpos",
                            style: GoogleFonts.lato(
                                fontSize: 2.5.h,
                                fontWeight: FontWeight.w300,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 20.0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Mahal Nakong KaBrigada, ',
                        style: GoogleFonts.ubuntu(
                            fontWeight: FontWeight.w900, fontSize: 20.0)),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, top: 10.0, right: 10.0),
                      child: Column(
                        children: [
                          Text(_paragraph,
                              style: GoogleFonts.ubuntu(
                                  color: Colors.grey,
                                  fontSize: 15.0,
                                  fontStyle: FontStyle.italic)),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Image.asset(
                                "assets/images/signature-catulpos.png"),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InkWellOverlay extends StatelessWidget {
  const _InkWellOverlay({
    this.openContainer,
    this.width,
    this.height,
    this.child,
  });

  final VoidCallback? openContainer;
  final double? width;
  final double? height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: InkWell(
        onTap: openContainer,
        child: child,
      ),
    );
  }
}
