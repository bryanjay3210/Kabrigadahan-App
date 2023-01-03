import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kabrigadan_mobile/src/core/bloc/bloc_with_state.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/current_user.dart';
import 'package:kabrigadan_mobile/src/domain/entities/newsfeed/newsfeed.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_fundraising/fundraising_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_my_recent_search/my_recent_search_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/widgets/fundraising/donate_without_fundraising.dart';
import 'package:kabrigadan_mobile/src/presentation/widgets/fundraising/fundraising_widget.dart';
import 'package:logger/logger.dart';

import 'fundraising_search.dart';

class FundraisingView extends HookWidget {
  const FundraisingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = useScrollController();
    ScrollController listViewScrollController = useScrollController();

    useEffect(() {
      scrollController.addListener(() => _onScrollListener(context, scrollController));
    }, [scrollController]);

    final currentUserBox = Hive.box('currentUser');

    if(currentUserBox.length != 0){
      CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;

      return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: _buildAppBar(context),
        body: _buildBody(scrollController, listViewScrollController, currentUser),
      );
    } else {
      return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: _buildAppBar(context),
        body: _buildBody(scrollController, listViewScrollController, null),
      );
    }
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    TextEditingController controller = TextEditingController();
    MyRecentSearchBloc myRecent = BlocProvider.of<MyRecentSearchBloc>(context);
    TextStyle defaultStyle = const TextStyle(color: Colors.grey, fontSize: 15.0);
    TextStyle linkStyle = const TextStyle(color: Colors.blue);
    double height = 0.0;
    String val = '';
    return AppBar(
      toolbarHeight: 80,
      elevation: 2.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20.0),
        ),
      ),
      centerTitle: true,
      title: const Text('Kabrigadahan Mobile', style: TextStyle(color: Colors.black)),
      actions: [
        Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: IconButton(
              onPressed: (){
                MyRecentSearchBloc myRecent = BlocProvider.of<MyRecentSearchBloc>(context);
                FundraisingBloc textController = BlocProvider.of<FundraisingBloc>(context);
                textController.controller.clear();
                myRecent.myRecentList.clear();
                myRecent.add(const GetMyRecentSearch());
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FundRaisingSearch()));
              },
              icon: const Icon(Ionicons.search, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(ScrollController scrollController, ScrollController listViewScrollController, CurrentUser? currentUser) {
    return BlocBuilder<FundraisingBloc, FundraisingState>(
      builder: (_, state) {
        if (state is FundraisingLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is FundraisingError) {
          return GestureDetector(
            onTap: (){
              final fundraisingBloc = BlocProvider.of<FundraisingBloc>(_);
              fundraisingBloc.add(const GetFundraising());
            },
            child: const Center(
              child: Icon(Ionicons.refresh)
            )
          );
        }
        if (state is FundraisingDone) {
          // return const SizedBox();
          return _buildFundraise(scrollController, listViewScrollController, state.listNewsFeed, state.noMoreData, currentUser);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildFundraise(
    ScrollController scrollController,
    ScrollController listViewScrollController,
    List<NewsFeed> fundraisingItems,
    bool? noMoreData,
    CurrentUser? currentUser
  ) {
    var logger = Logger();

    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          currentUser != null ? DonateWithoutFundraising(currentUser: currentUser) : const SizedBox(height: 0),
          ListView.builder(
            controller: listViewScrollController,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: fundraisingItems.length,
            itemBuilder: (BuildContext context, int index){
              return FundraisingWidget(
                newsFeed: fundraisingItems[index],
                currentUser: currentUser,
              );
            }
          ),
          if (noMoreData!) ...[
            const SizedBox(),
          ] else ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: CupertinoActivityIndicator(),
            ),
          ]
        ],
      ),
    );
  }

  void _onScrollListener(BuildContext context, ScrollController scrollController) {
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    final fundraisingBloc = BlocProvider.of<FundraisingBloc>(context);
    final state = fundraisingBloc.blocProcessState;

    if (currentScroll == maxScroll && state == BlocProcessState.idle) {
      fundraisingBloc.add(const GetFundraising());
    }
  }

  //TODO: UNCOMMENT FOR FUNDRAISING PRESSED EVENT
  // void _onArticlePressed(BuildContext context, Article article) {
  //   Navigator.pushNamed(context, '/ArticleDetailsView', arguments: article);
  // }
  //
  // void _onShowSavedArticlesViewTapped(BuildContext context) {
  //   Navigator.pushNamed(context, '/SavedArticlesView');
  // }
}