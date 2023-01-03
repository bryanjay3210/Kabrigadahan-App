import 'package:flutter/material.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/donations/body/main_donations_body.dart';

class DonationsScreen extends StatefulWidget {
  const DonationsScreen({Key? key}) : super(key: key);

  @override
  _DonationsScreenState createState() => _DonationsScreenState();
}

class _DonationsScreenState extends State<DonationsScreen> {
  @override
  Widget build(BuildContext context) {
    return const MakeDonationsBody();
  }
}
