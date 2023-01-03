import 'package:flutter/material.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/donations/body/pageview_screens/donations_body.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/donations/body/pageview_screens/my_unremitted_donations.dart';

class MakeDonationsBody extends StatefulWidget {
  // final DonationsEntity donationsEntity;

  const MakeDonationsBody({Key? key}) : super(key: key);

  @override
  State<MakeDonationsBody> createState() => _MakeDonationsBodyState();
}

class _MakeDonationsBodyState extends State<MakeDonationsBody> {
  bool _hasBeenPressedDonation = true;
  bool _hasBeenPressedUnRemitted = false;

  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController(initialPage: 0);

    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150.0,
                child: TextButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(_hasBeenPressedDonation ? Colors.red : Colors.white)),
                  onPressed: () {
                    setState(() {
                      _hasBeenPressedUnRemitted = false;
                      _hasBeenPressedDonation = true;
                    });
                    _pageController.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                  },
                  child: Text(
                    "Your Donation",
                    style: TextStyle(
                      color: _hasBeenPressedDonation ? Colors.white : Colors.red,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 150.0,
                child: TextButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(_hasBeenPressedUnRemitted ? Colors.red : Colors.white )),
                    onPressed: () {
                      setState(() {
                        _hasBeenPressedUnRemitted = true;
                        _hasBeenPressedDonation = false;
                      });
                      _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                    },
                    child: Text(
                      "Unremitted Donation",
                      style: TextStyle(
                        color: _hasBeenPressedUnRemitted ? Colors.white : Colors.red,
                      ),
                    )),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: const [
                DonationsBody(),
                MyUnremittedDonations()
              ],
              onPageChanged: (value) {
                if(value==1){
                  setState(() {
                    _hasBeenPressedUnRemitted = true;
                    _hasBeenPressedDonation = false;
                  });
                }else{
                  setState(() {
                    _hasBeenPressedUnRemitted = false;
                    _hasBeenPressedDonation = true;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
