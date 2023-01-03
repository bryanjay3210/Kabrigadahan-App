import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_fundraising/fundraising_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_my_recent_search/my_recent_search_bloc.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/my_recent_search/my_recent_search.dart';
import 'package:sizer/sizer.dart';

import 'fundraising_filterview.dart';

class FundRaisingSearch extends StatefulWidget {
  const FundRaisingSearch({Key? key}) : super(key: key);

  @override
  _FundRaisingSearchState createState() => _FundRaisingSearchState();
}

class _FundRaisingSearchState extends State<FundRaisingSearch> {
  final FocusNode emailFocusNode = FocusNode();
  final KeyboardListener keyboardListen = KeyboardListener();
  double defFontSize = getDeviceType() == 'phone' ? 12.0.sp : 10.0.sp;
  @override
  Widget build(BuildContext context) {
    FundraisingBloc textController = BlocProvider.of<FundraisingBloc>(context);

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        // The search area here
          title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: RawKeyboardListener(
                onKey: (RawKeyEvent event) {
                  if (event.runtimeType == RawKeyDownEvent  &&
                      (event.logicalKey.keyId == 4295426088))//Enter Key ID from keyboard
                      {
                    submit(textController, context);
                  }
                },
                focusNode: FocusNode(),
                child: TextFormField(
                  inputFormatters: <TextInputFormatter> [keyboardListen],
                  focusNode: emailFocusNode,
                  decoration: InputDecoration(
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          submit(textController, context);
                        },
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          textController.controller.clear();
                        },
                      ),
                      hintText: 'Search...',
                      border: InputBorder.none),
                  controller: textController.controller,
                  onFieldSubmitted: (value) {
                    submit(textController, context);
                  },
                ),
              ),
            ),
          )),
      body: _body(defFontSize),
      resizeToAvoidBottomInset: false,
    );
  }

  void submit(FundraisingBloc textController, BuildContext context) {
    MyRecentSearchBloc myRecent = BlocProvider.of<MyRecentSearchBloc>(context);
    bool checking = true;
    final myRecentSearchBox = Hive.box("myRecentSearch");
    for(var element in myRecent.myRecentList){
      if(element.recent! == textController.controller.text){
        checking = false;
      }
    }
    if(checking){
      myRecentSearchBox.add(MyRecentSearch(textController.controller.text));
    }
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => FundraisingFilterView(val: textController.controller.text.toUpperCase())));
  }

  Widget _body(double defFontSize){
    TextStyle defaultStyle = const TextStyle(color: Colors.grey, fontSize: 15.0);
    TextStyle linkStyle = TextStyle(color: Colors.blue, fontSize: defFontSize);
    double height = 0.0;
    String val = '';
    MyRecentSearchBloc myRecent = BlocProvider.of<MyRecentSearchBloc>(context);
    FundraisingBloc textController = BlocProvider.of<FundraisingBloc>(context);
    double limit = getDeviceType() == 'phone' ? 17 : 19;
    height = myRecent.myRecentList.isEmpty ? 0.0 : myRecent.myRecentList.length <= limit ? myRecent.myRecentList.length*4.3.h : limit*4.3.h;
    myRecent.add(const GetMyRecentSearch());
    return SizedBox(
      height: 160.h,
      width: getDeviceType() == 'phone' ? 100.0.w : 200.0.w,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children:  [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0,left: 20.0),
                    child: Text('Recent Searches', style: TextStyle(fontSize: 12.0.sp)),
                  ),
                ],
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: SizedBox(
                  height: 70.0.h,
                  child: ListView.builder(
                      itemCount: myRecent.myRecentList.length,
                      itemBuilder: (BuildContext context, int index){
                        return Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                textController.controller.text = myRecent.myRecentList[index].recent.toString();
                              },
                              child: Card(
                                color: const Color(0xFAF7F7EA),
                                elevation: 0.1,
                                child: SizedBox(
                                  height: 5.0.h,
                                  width: getDeviceType() == 'phone' ? 86.0.w : 90.0.w,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 1.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            style: defaultStyle,
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: myRecent.myRecentList[index].recent.toString(),
                                                  style: linkStyle,
                                                  ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              // color: const Color(0xFAF7F7EA),
                              elevation: 0.1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.2),
                                child: RichText(
                                  text: TextSpan(
                                    style: defaultStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'X',
                                          style: linkStyle,
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              myRecent.index = index;
                                              myRecent.add(DeleteMyRecentSearch(index));
                                              myRecent.myRecentList.clear();
                                              myRecent.add(const GetMyRecentSearch());
                                              setState(() {});
                                            }),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}


class KeyboardListener extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ){
    return newValue;
  }
}