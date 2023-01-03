import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_donations/sync_donations_bloc/sync_donations_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/community_officer_collections/body/community_collection/body_community_collections.dart';

import 'body/master_collection/master_collection.dart';

class CommunityOfficerCollections extends StatefulWidget {
  const CommunityOfficerCollections({Key? key}) : super(key: key);

  @override
  State<CommunityOfficerCollections> createState() => _CommunityOfficerCollectionsState();
}

class _CommunityOfficerCollectionsState extends State<CommunityOfficerCollections> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  refresh(){
    super.setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    final syncDonationsBloc = BlocProvider.of<SyncDonationsBloc>(context);
    syncDonationsBloc.add(const PostSyncDonationsCOEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: kSettingsBackgroundColor,
            appBar: AppBar(
              centerTitle: true,
              title: TabBar(
                controller: _tabController,
                indicatorColor: kPrimaryColor,
                tabs: const [
                  Tab(child: Text('Member', style: TextStyle(color: Colors.black))),
                  Tab(child: Text('Remittance', style: TextStyle(color: Colors.black))),
                  // const Tab(child: Text('Remitted', style: TextStyle(color: Colors.black))),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                BodyCommunityCollections(refresh: refresh),
                MasterCollection(refresh: refresh),
              ],
            )),
      ),
    );
  }
}
