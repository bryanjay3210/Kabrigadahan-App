import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentPromptMasterCollection extends StatefulWidget {
  const PaymentPromptMasterCollection({Key? key}) : super(key: key);

  @override
  _PaymentPromptMasterCollectionState createState() => _PaymentPromptMasterCollectionState();
}

class _PaymentPromptMasterCollectionState extends State<PaymentPromptMasterCollection> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                title: Center(child: Text('Where did you pay your donation?')),
              ),
              ListTile(
                title: const Text('BrigadaPay'),
                leading: const Icon(CupertinoIcons.money_rubl_circle),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Kabrigadahan center'),
                leading: const Icon(CupertinoIcons.person_3),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ));
  }
}
