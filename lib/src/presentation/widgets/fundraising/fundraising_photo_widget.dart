import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_fundraising/fundraising_bloc.dart';
import 'package:logger/logger.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FundraisingPhotoWidget extends StatefulWidget {
  final List<String?> listPhoto;
  const FundraisingPhotoWidget({Key? key, required this.listPhoto}) : super(key: key);

  @override
  _FundraisingPhotoWidgetState createState() => _FundraisingPhotoWidgetState();
}

class _FundraisingPhotoWidgetState extends State<FundraisingPhotoWidget> {
  String deviceType = getDeviceType();
  ConnectivityResult? connectivityResult;
  Future<Connectivity?> checkConnection() async{
    var logger = Logger();
    connectivityResult = (await (Connectivity().checkConnectivity()));
  }
  @override
  Widget build(BuildContext context) {

    FundraisingBloc fund = BlocProvider.of<FundraisingBloc>(context);
    double top = deviceType == 'phone' ? 225.0 : 425.0;
    double leftRight = (deviceType == 'phone' ? 140.0  - (widget.listPhoto.length*6): 380.0- (widget.listPhoto.length*2));
    AutoScrollController indicator = AutoScrollController();
    return Column(
      children: [
        Stack(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                enableInfiniteScroll: false,
                height: 40.0.h,
                // aspectRatio: 16/9,
                viewportFraction: 1,
                enlargeCenterPage: true,
                autoPlay: false,
                // enlargeCenterPage: true,
                //scrollDirection: Axis.vertical,
                onPageChanged: (index, reason) {
                  fund.currentIndex = index;
                  setState(
                        () {
                    },
                  );
                },
              ),
              items: widget.listPhoto
                  .map(
                    (item) => Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Card(
                    margin: const EdgeInsets.only(
                      top: 1.0,
                      bottom: 0.0,
                    ),
                    elevation: 6.0,
                    shadowColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                      child: Stack(
                        children: <Widget>[
                          FutureBuilder(
                              future: checkConnection(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi)
                                    {
                                      return SizedBox(child: CachedNetworkImage(
                                        imageUrl: item!,

                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),);
                                    }
                                  else{
                                    return Container(
                                          alignment: Alignment.center,
                                          child: const Text('No Image available. Please Go Online'),
                                          height: double.infinity,
                                          width: double.infinity,
                                        );
                                  }
                                }
                                return Container(
                                  alignment: Alignment.center,
                                  child: const Text('No Image available. Please Go Online'),
                                  height: double.infinity,
                                  width: double.infinity,
                                );
                            },
                          )
                          // connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi ?
                          // Container(
                          //   child: Image.network(item!, height: double.infinity, width: double.infinity,),
                          // ) : Container(
                          //   alignment: Alignment.center,
                          //   child: const Text('No Image available. Please Go Online'),
                          //   height: double.infinity,
                          //   width: double.infinity,
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
            // Padding(
            //   padding: EdgeInsets.only(top: top, left: leftRight, right: leftRight),
            //   child: widget.listPhoto.length > 1 ? Card(
            //     color: kPrimaryLightTrans,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: widget.listPhoto.map((urlOfItem) {
            //         int index = widget.listPhoto.indexOf(urlOfItem);
            //         return Container(
            //           width: 10.0,
            //           height: 10.0,
            //           margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            //           decoration: BoxDecoration(
            //             shape: BoxShape.circle,
            //             color: fund.currentIndex == index
            //                 ? kPrimaryColor
            //                 : Colors.grey,
            //           ),
            //         );
            //       }).toList(),
            //     ),
            //   ) : Container(),
            // )
          ],
        ),

      ],

    );
  }

}
