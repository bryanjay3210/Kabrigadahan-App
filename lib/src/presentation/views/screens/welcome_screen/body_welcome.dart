import 'dart:io';

import 'package:flowder/flowder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/core/utils/shared_preferences/get_preferences.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_mobile_version/bloc_mobile_version_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/widgets/loader/loader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:open_file/open_file.dart';

import 'body/sliders.dart';
import 'body/title.dart';

class BodyWelcome extends StatefulWidget {
  const BodyWelcome({Key? key}) : super(key: key);

  @override
  _BodyWelcomeState createState() => _BodyWelcomeState();
}

class _BodyWelcomeState extends State<BodyWelcome> {
  late DownloaderUtils options;
  late DownloaderCore core;
  late final String path;
  late double progress = 0;

  void showAlert(BuildContext context, String thisVersion, String serverVersion, String updateUrl) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(thisVersion != serverVersion ?  "Application Update Available" : "Application is updated"),
          content: Text(thisVersion != serverVersion ? "Available Updates from \n version $thisVersion to version $serverVersion" : "Application is up to date.", textAlign: TextAlign.center,),
          actions: [

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                thisVersion != serverVersion ?
                TextButton(onPressed: () async{
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Loader(),
                      ));
                  if(File('$path/KaBrigadahan-Staging.apk').existsSync())
                  {
                    File('$path/KaBrigadahan-Staging.apk').delete();
                  }
                  options = DownloaderUtils(
                    progressCallback: (current, total) {
                      progress = (current / total) * 100;
                    },
                    file: File('$path/KaBrigadahan-Staging.apk'),
                    progress: ProgressImplementation(),
                    onDone: () {
                      Navigator.pop(context);
                      OpenFile.open('$path/KaBrigadahan-Staging.apk');

                    },
                    deleteOnCancel: true,
                  );
                  core = await Flowder.download(
                      updateUrl,
                      options);

                }, child: const Text('Download Now')) : Container(),
                TextButton(onPressed: (){Navigator.pop(context);}, child: const Text('Close')),
              ],
            )
          ],
        ));
  }

  Widget _menu(){
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          floating: true,
          pinned: true,
          iconTheme: const IconThemeData(color: kPrimaryColor),
          expandedHeight: 200.0,
          flexibleSpace: FlexibleSpaceBar(
            background: Image.asset('assets/images/appbar-header.png'),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 1.0.h),
        ),
        const WelcomeTitle(),
        const SlidersWelcome(),
        const SliverToBoxAdapter(
          child: Divider(),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();

    //TODO: INITIALIZE GETTING OF PREFERENCES ON A CONTROLLER
    GetPreferences().getBrigadahanFoundationFundsSettings();
    final mobileVersionBloc = BlocProvider.of<MobileVersionBloc>(context);
    mobileVersionBloc.add(const GetMobileVersionEvent());
  }

  Future<void> initPlatformState() async {
    _setPath();
    if (!mounted) return;
  }

  void _setPath() async {
    path = (await getExternalStorageDirectory())!.path;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MobileVersionBloc, MobileVersionState>(
      builder: (_, state){
        if(state is GetMobileVersionDone){
          final mobileVersionBloc = BlocProvider.of<MobileVersionBloc>(context);
          if(mobileVersionBloc.thisVersion != mobileVersionBloc.serverVersion){
            Future.delayed(Duration.zero, () => showAlert(context, mobileVersionBloc.thisVersion, mobileVersionBloc.serverVersion, mobileVersionBloc.updateUrl));
          }
          FloatingActionButton(
              elevation: 0.0,
              child: const Icon(Icons.update),
              backgroundColor: const Color(0xFFE57373),
              onPressed: (){}
          );
          return Stack(
              children: [
                _menu(),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.end,
                //       children: [
                //         Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: FloatingActionButton(
                //               elevation: 0.0,
                //               child: const Icon(Icons.update),
                //               backgroundColor: const Color(0xFFE57373),
                //               onPressed: (){
                //                 Future.delayed(Duration.zero, () => showAlert(context, mobileVersionBloc.thisVersion, mobileVersionBloc.serverVersion, mobileVersionBloc.updateUrl));
                //               }
                //           ),
                //         ),
                //       ],
                //     ),
                //   ],
                // )
              ]
          );
        }else{
          return _menu();
        }
      },
    );

  }
}
