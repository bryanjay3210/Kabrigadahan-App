import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/current_user.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/remitted_donation/remitted_donation.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/transaction_attachment_display/display_screen/display_screen.dart';
import 'package:logger/logger.dart';
import 'package:sizer/sizer.dart';
import 'dart:convert';

class TransactionAttachmentDisplay extends StatefulWidget {
  final CameraDescription camera;
  final CurrentUser currentUser;
  final String transactionId;
  final List<RemittedDonation> toBeRemittedList;

  const TransactionAttachmentDisplay({Key? key, required this.camera, required this.currentUser, required this.transactionId, required this.toBeRemittedList}) : super(key: key);

  @override
  _TransactionAttachmentDisplayState createState() => _TransactionAttachmentDisplayState();
}

class _TransactionAttachmentDisplayState extends State<TransactionAttachmentDisplay> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    initializeControllers();

    super.initState();
  }

  Future<void> initializeControllers() async {
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var logger = Logger();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Take a picture of receipt',
          style: GoogleFonts.lato(
              color: Colors.black
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: SizedBox(
                height: 60.0.h,
                width: 90.0.w,
                child: CameraPreview(_controller),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: () async {
              try {
                await _initializeControllerFuture;

                final image = await _controller.takePicture();

                List<int> imageBytes = File(image.path).readAsBytesSync();
                String bytes = base64Encode(imageBytes);

                logger.i(bytes);

                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DisplayPictureScreen(
                      imagePath: image.path,
                      currentUser: widget.currentUser,
                      bytes: bytes,
                      transactionId: widget.transactionId,
                      toBeRemittedList: widget.toBeRemittedList,
                    ),
                  ),
                );
              } catch (e) {
                logger.i(e);
              }
            },
            child: const Icon(Icons.camera_alt),
          ),
        ],
      ),
    );
  }
}
