import 'package:flutter/material.dart';

import '../config/custom_router.dart';
import '../enums/bottom_nav_item.dart';

import '../screens/mainScreens/home/home.dart';
import '../screens/mainScreens/discover/discover.dart';
import '../screens/mainScreens/favourite/favourite.dart';
import '../screens/mainScreens/profile/user_profile.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';

  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;

  const TabNavigator({Key? key, required this.navigatorKey, required this.item})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilder();
    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoot,
      onGenerateInitialRoutes: (_, initialRoute) {
        return [
          MaterialPageRoute(
              settings: const RouteSettings(name: tabNavigatorRoot),
              builder: (context) => routeBuilders[initialRoute]!(context))
        ];
      },
      onGenerateRoute: CustomRouter.onGenerateNestedRoute,
    );
  }

  Map<String, WidgetBuilder> _routeBuilder() {
    return {tabNavigatorRoot: (context) => _getScren(context, item)};
  }

  _getScren(BuildContext context, BottomNavItem item) {
    switch (item) {
      case BottomNavItem.one:
        return HomePage();
      case BottomNavItem.two:
        return Discover();
      case BottomNavItem.three:
        return UserFavouritePage();
      case BottomNavItem.four:
        return UserProfilePage();
      /*case BottomNavItem.five:
        return UserProfilePage();*/

      default:
        return HomePage();
    }
  }
}
