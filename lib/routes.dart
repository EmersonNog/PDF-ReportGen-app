import 'package:flutter/cupertino.dart';
import 'pages/home.dart';

class Routes {
  static Map<String, Widget Function(BuildContext context)> routes = <String, WidgetBuilder>{
    '/home': (context) => const Home(),
  };

  static String initialRoute = '/home';
}