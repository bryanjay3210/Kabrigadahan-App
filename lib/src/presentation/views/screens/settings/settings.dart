import 'package:flutter/material.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/settings/body/body_settings.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kSettingsBackgroundColor,
      body: BodySettings(),
    );
  }
}
