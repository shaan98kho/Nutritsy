import '../config/route_paths.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/mainScreens/splash/splash.dart';
import '../screens/mainScreens/main/main_page.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: RouteSettings(name: '/'),
          builder: (_) => Scaffold(),
        );

      case RoutePaths.Splash:
        return CupertinoPageRoute(
            builder: (context) => SplashScreen(),
            settings: RouteSettings(
                name: RoutePaths.Splash, arguments: settings.arguments));

      case RoutePaths.Main:
        return CupertinoPageRoute(
            builder: (context) => MainPage(),
            settings: RouteSettings(name: RoutePaths.Main));

      default:
        return _errorRoute();
    }
  }

  static Route onGenerateNestedRoute(RouteSettings settings) {
    // this is where you define the nested routes.
    switch (settings.name) {
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Something went wrong'),
        ),
      ),
    );
  }
}
