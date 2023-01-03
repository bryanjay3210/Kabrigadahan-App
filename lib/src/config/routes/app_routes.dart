
import 'package:flutter/material.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/auth/auth.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/authenticated_init_views/member_authenticated_init_view/member_authenticated_init_view.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/fundraising/fundraising_view.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/authenticated_init_views/community_officer_authenticated_init_view/init_view.dart';
import 'package:kabrigadan_mobile/src/presentation/views/screens/welcome_screen/welcome_screen.dart';

class AppRoutes {
  static Route? onGenerateRoutes(RouteSettings settings) {
    switch(settings.name){
      case '/':
        return _materialRoute(const Dashboard());

      case '/Auth':
        return _materialRoute(const AuthScreen());

      case'/MemberInitView':
        return _materialRoute(const MemberAuthenticatedInitView());

      case'/CommunityOfficerInitView':
        return _materialRoute(const CommunityOfficerAuthenticatedInitView());

      case '/FundRaisingView':
        return _materialRoute(const FundraisingView());

      default:
        return null;
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}