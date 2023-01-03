import 'package:hive/hive.dart';

part 'my_recent_search.g.dart';

@HiveType(typeId: 6)
class MyRecentSearch {
  @HiveField(0)
  final String? recent;

  MyRecentSearch(this.recent);
}