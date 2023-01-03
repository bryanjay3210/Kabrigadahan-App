import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kabrigadan_mobile/src/core/utils/constants.dart';
import 'package:kabrigadan_mobile/src/data/models/hive/current_user/current_user.dart';
import 'package:kabrigadan_mobile/src/domain/entities/newsfeed/newsfeed.dart';
import 'package:kabrigadan_mobile/src/presentation/bloc/bloc/bloc_fundraising/fundraising_bloc.dart';
import 'package:kabrigadan_mobile/src/presentation/widgets/fundraising/donate_without_fundraising.dart';
import 'package:kabrigadan_mobile/src/presentation/widgets/fundraising/fundraising_widget.dart';
import 'package:logger/logger.dart';

class FundraisingFilterView extends HookWidget {
  final String? val;
  const FundraisingFilterView({this.val, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FundraisingBloc.skipCount = 0;
    FundraisingBloc search = BlocProvider.of<FundraisingBloc>(context);
    search.add(const LoadFundraising());
    search.add(const GetFundraising());
    ScrollController scrollController = useScrollController();
    ScrollController listViewScrollController = useScrollController();
    FundraisingBloc fund = BlocProvider.of<FundraisingBloc>(context);

    useEffect(() {
      scrollController.addListener(() => _onScrollListener(context, scrollController));
    }, [scrollController]);

    final currentUserBox = Hive.box('currentUser');
    if(currentUserBox.length != 0){
      CurrentUser currentUser = currentUserBox.getAt(0) as CurrentUser;

      return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          elevation: 2.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              search.controller.clear();
              FundraisingBloc.skipCount = 0;
              search.add(const LoadFundraising());
              search.add(const GetFundraising());
              Navigator.of(context).pop();
              },
          ),
          title: Text('Search Result For: '+val!, style: const TextStyle(color: Colors.black),),
          centerTitle: true,
        ),
        body: _buildBody(scrollController, listViewScrollController, currentUser, context),
      );
    } else {
      return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          elevation: 2.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: (){
              fund.currentIndex = 0;
              Navigator.of(context).pop();
            },
          ),
          title: Text('Search Result For: '+val!, style: const TextStyle(color: Colors.black),),
          centerTitle: true,
        ),
        body: _buildBody(scrollController, listViewScrollController, null,context),
      );
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: 80,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20.0)
          )
      ),
      centerTitle: true,
      title: const Text('Kabrigadahan Mobile', style: TextStyle(color: Colors.black)),
      actions: [
        Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: IconButton(
              onPressed: (){
                showDialog(context: context, builder: (context) => AlertDialog(
                  title: const Text('Search'),
                  actions: [
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Search Fundraiser',
                      ),
                    ),
                    ElevatedButton(
                        onPressed: (){

                        }, child: const Text('Search')
                    ),
                    ElevatedButton(
                        onPressed: (){
                          Navigator.pop(context);
                        }, child: const Text('Close')
                    ),
                  ],
                ));
              },
              icon: const Icon(Ionicons.search, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(ScrollController scrollController, ScrollController listViewScrollController, CurrentUser? currentUser, BuildContext context) {
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
          return _buildFundraise(scrollController, listViewScrollController, state.listNewsFeed, state.noMoreData!, currentUser);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildFundraise(
      ScrollController scrollController,
      ScrollController listViewScrollController,
      List<NewsFeed> fundraisingItems,
      bool noMoreData,
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
                if(fundraisingItems[index].fundraisingItem!.fundRaising!.fundraising!.recipient!.contains(val!)){
                  return FundraisingWidget(
                    newsFeed: fundraisingItems[index],
                    currentUser: currentUser,
                  );
                }
                return Container();
              }
          ),
          if (noMoreData) ...[
            const SizedBox(),
          ]
          // else ...[
          //   const Padding(
          //     padding: EdgeInsets.symmetric(vertical: 14),
          //     // child: CupertinoActivityIndicator(),
          //   ),
          // ]
        ],
      ),
    );
  }

  void _onScrollListener(BuildContext context, ScrollController scrollController) {
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    final fundraisingBloc = BlocProvider.of<FundraisingBloc>(context);
    final state = fundraisingBloc.blocProcessState;

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