import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/remitted_donation/remitted_donation.dart';
import 'package:sizer/sizer.dart';

TextEditingController controller = TextEditingController();
class CommunityCollectionSearch extends StatefulWidget {
  final List<RemittedDonation>? toBeRemittedList;
  const CommunityCollectionSearch({Key? key, required this.toBeRemittedList}) : super(key: key);

  @override
  _CommunityOfficerSearchState createState() => _CommunityOfficerSearchState();
}

class _CommunityOfficerSearchState extends State<CommunityCollectionSearch> {
  @override
  Widget build(BuildContext context) {
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
              child: TextFormField(
                decoration: InputDecoration(

                    prefixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                      },
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        controller.clear();
                        setState(() {

                        });
                      },
                    ),
                    hintText: 'Search...',
                    border: InputBorder.none),
                onFieldSubmitted: (value) {
                },
                controller: controller,
                onChanged: (val){
                  setState(() {

                  });
                },
              ),
            ),
          )),
      body: Container(
        height: 80.0.h,
        color: kBackgroundColor,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 80.0.h,
                child: CustomScrollView(
                  slivers: [
                    const SliverAppBar(
                      title: Text(
                        'List Of Unremitted',
                        style: TextStyle(color: Colors.black),
                      ),
                      automaticallyImplyLeading: false,
                      backgroundColor: kBackgroundColor,
                      pinned: true,
                    ),
                    widget.toBeRemittedList!.isNotEmpty
                        ? SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        RemittedDonation toBeRemitted = widget.toBeRemittedList![index];

                        String name = toBeRemitted.name.toString() != "null" ? toBeRemitted.name! : '[BrigadaPay Unpaid]';

                        if(toBeRemitted.name!.contains(controller.text.toUpperCase())){
                          return Card(
                            child: ListTile(
                              isThreeLine: true,
                              title: Text(name),
                              subtitle: Text(
                                DateFormat.yMMMMd('en_US').format(DateTime.parse(toBeRemitted.dateRecorded.toString())).toString()
                                     + '\nTempID: ' + toBeRemitted.unremittedTempId.toString(),
                              ),
                              trailing: Text('${double.parse(toBeRemitted.amount.toString()).toStringAsFixed(2)} pesos'),
                            ),
                          );
                        }
                        return Container();
                      }, childCount: widget.toBeRemittedList!.length),
                    )
                        : const SliverToBoxAdapter(
                        child: Padding(
                        padding: EdgeInsets.all(30.0),
                        child: Center(child: Text('No paid members.')),
                      ),
                    ),
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
