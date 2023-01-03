import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/remitted_donation/remitted_donation.dart';
import 'package:sizer/sizer.dart';

TextEditingController controller = TextEditingController();
class CommunityOfficeSearch extends StatefulWidget {
  final List<dynamic>? remittedDonationList;
  const CommunityOfficeSearch({Key? key, required this.remittedDonationList}) : super(key: key);

  @override
  _CommunityOfficeSearchState createState() => _CommunityOfficeSearchState();
}

class _CommunityOfficeSearchState extends State<CommunityOfficeSearch> {
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
        height: 87.0.h,
        color: kBackgroundColor,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 120.0.h,
                child: CustomScrollView(
                  slivers: [
                    const SliverAppBar(
                      title: Text('List Of Remitted', style: TextStyle(color: Colors.black),),
                      automaticallyImplyLeading: false,
                      backgroundColor: kYellowColor,
                      pinned: true,
                    ),
                    widget.remittedDonationList!.isNotEmpty
                        ? SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        RemittedDonation remittedDonation = widget.remittedDonationList![index] as RemittedDonation;

                        if(remittedDonation.name!.contains(controller.text.toUpperCase())){
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.check_circle, color: Colors.blue),
                              title: Text('${remittedDonation.name}', style: const TextStyle(color: Colors.grey)),
                              subtitle: Text(remittedDonation.dateRecorded.toString(), style: const TextStyle(color: Colors.grey)),
                              trailing: Text('${double.parse(remittedDonation.amount.toString()).toStringAsFixed(2)} pesos', style: const TextStyle(color: Colors.grey)),
                            ),
                          );
                        }
                        return Container();
                      }, childCount: widget.remittedDonationList!.length),
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
