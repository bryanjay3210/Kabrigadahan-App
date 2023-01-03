import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/core/utils/current_user_permission/current_user_permissions.dart';
import 'package:sizer/sizer.dart';
import 'body/list_of_unremitted_donations_complete.dart';
import 'body/list_of_unremitted_donations_in_progress.dart';

class MasterCollection extends StatefulWidget {
  final VoidCallback? refresh;
  const MasterCollection({Key? key, this.refresh}) : super(key: key);

  @override
  _MasterCollectionState createState() => _MasterCollectionState();
}

class _MasterCollectionState extends State<MasterCollection> with SingleTickerProviderStateMixin{
  final masterRemittanceBox = Hive.box('areaOfficerMaster');
  final masterRemittanceLocalBox = Hive.box('areaOfficerMasterLocal');

  List<String?> listPermissions = CurrentUserPermissions.listPermissions;
  late bool isAreaOfficer;

  late TabController _tabController;

  refresh(){
    super.setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    if (listPermissions.contains(kConsolidateDonationsPermission)) {
      setState(() {
        isAreaOfficer = true;
      });
    } else {
      setState(() {
        isAreaOfficer = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: TabBar(
                  controller: _tabController,
                  indicatorColor: kPrimaryColor,
                  tabs: [
                    Tab(child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: kChipColor),padding: EdgeInsets.symmetric(vertical: getDeviceType() == 'phone' ? 8.sp : 2.sp, horizontal: 25.sp),child: Text('In Progress', style: TextStyle(color: Colors.white, fontSize: 10.sp)))),
                    Tab(child: Container(decoration: BoxDecoration( borderRadius: BorderRadius.circular(5),color: kYellowColor),padding: EdgeInsets.symmetric(vertical: getDeviceType() == 'phone' ? 8.sp : 2.sp, horizontal: 25.sp),child: Text('Completed', style: TextStyle(color: Colors.black, fontSize: 10.sp)))),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  localSave(context),
                  serverSave(context),
                ],
              )
          )
      ),
    );

  }

  List<dynamic> bulkMembers = [];
  List<Map<String, dynamic>> bulkMemberList = [];

  Widget serverSave(BuildContext context){
    return SizedBox(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [ListOfUnremittedDonationsComplete(refresh: widget.refresh)],
        ),
      ),
    );
  }

  Widget localSave(BuildContext context){
    return SizedBox(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [ListOfUnremittedDonationsInProgress(refresh: widget.refresh)],
        ),
      ),
    );
  }
}
