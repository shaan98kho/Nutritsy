import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nu_trit_sy/config/custom_router.dart';
import 'package:firebase_core/firebase_core.dart';

import './config/route_paths.dart';
import './widgets/utils.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

//void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  //forces your app to run only portrait and disable landscape
  runApp(
    Nutritsy(),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class Nutritsy extends StatefulWidget {
  const Nutritsy({Key? key}) : super(key: key);
  @override
  State<Nutritsy> createState() {
    return _NutritsyState();
  }
}

class _NutritsyState extends State<Nutritsy> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //theme: Theme(data: , child: ,),
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: Utils.messengerKey,
      title: 'Nutritsy',
      //home: SplashScreen(),
      onGenerateRoute: CustomRouter.onGenerateRoute,
      initialRoute: RoutePaths.Splash,
      debugShowCheckedModeBanner: false,
    );
  }
}
