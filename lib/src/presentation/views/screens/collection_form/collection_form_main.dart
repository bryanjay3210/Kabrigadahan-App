import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'body/collection_form.dart';

class CollectionFormMain extends StatefulWidget {
  final bool isConnected;
  final Barcode? barcode;
  final bool? isBrigadahanId;
  final bool isMember;
  final String? idNumber;

  const CollectionFormMain({Key? key, required this.isConnected, this.barcode, this.isBrigadahanId, required this.isMember, this.idNumber}) : super(key: key);

  @override
  _CollectionFormMainState createState() => _CollectionFormMainState();
}

class _CollectionFormMainState extends State<CollectionFormMain> {
  @override
  Widget build(BuildContext context) {
    return CollectionForm(isConnected: widget.isConnected, barcode: widget.barcode, isBrigadahanId: widget.isBrigadahanId, isMember: widget.isMember,idNumber: widget.idNumber,);
  }
}
