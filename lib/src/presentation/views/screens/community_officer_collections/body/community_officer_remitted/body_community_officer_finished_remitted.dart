import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/remitted_donation/remitted_donation.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/community_officer_collections/body/community_officer_search.dart';
import 'package:sizer/sizer.dart';

class BodyCommunityOfficerFinishedRemitted extends StatefulWidget {
  const BodyCommunityOfficerFinishedRemitted({Key? key}) : super(key: key);

  @override
  _BodyCommunityOfficerFinishedRemittedState createState() => _BodyCommunityOfficerFinishedRemittedState();
}

class _BodyCommunityOfficerFinishedRemittedState extends State<BodyCommunityOfficerFinishedRemitted> {
  final remittedDonationBox = Hive.box('remittedDonations');

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [_buildListOfUnremittedDonations()],
          ),
        ),
      ),
    );
  }

  List<dynamic> bulkMembers = [];
  List<Map<String, dynamic>> bulkMemberList = [];

  Widget _buildListOfUnremittedDonations() {
    List<dynamic> remittedDonationList = remittedDonationBox.values.toList();

    return Expanded(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 120.0.h,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    title: const Text('List Of Remitted', style: TextStyle(color: Colors.black),),
                    automaticallyImplyLeading: false,
                    backgroundColor: kYellowColor,
                    pinned: true,
                    actions: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityOfficeSearch(remittedDonationList: remittedDonationList,)));
                          },
                          icon: const Icon(
                            CupertinoIcons.search,
                            color: Colors.black,
                          )),
                      IconButton(
                          onPressed: () {
                            setState(() {});
                          },
                          icon: const Icon(
                            CupertinoIcons.refresh_thin,
                            color: Colors.black,
                          ))
                    ],
                  ),
                  remittedDonationList.isNotEmpty
                      ? SliverList(
                          delegate: SliverChildBuilderDelegate((context, index) {
                            RemittedDonation remittedDonation = remittedDonationList[index] as RemittedDonation;

                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.check_circle, color: Colors.blue),
                                title: Text('${remittedDonation.name}', style: const TextStyle(color: Colors.grey)),
                                subtitle: Text(remittedDonation.dateRecorded.toString(), style: const TextStyle(color: Colors.grey)),
                                trailing: Text('${double.parse(remittedDonation.amount.toString()).toStringAsFixed(2)} pesos', style: const TextStyle(color: Colors.grey)),
                              ),
                            );
                          }, childCount: remittedDonationList.length),
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
    );
  }
}
