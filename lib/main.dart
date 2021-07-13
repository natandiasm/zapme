import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:zapme/screen/home_screen.dart';
import 'package:zapme/screen/restaurant_home_screen.dart';
import 'package:zapme/util/themeData_util.dart';

void main() {
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ZapMe',
      theme: ThemeDataUtil.themeDefault(),
      //darkTheme: ThemeDataUtil.themeDark(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomeScreen()),
        GetPage(name: '/:slug', page: () => RestaurantHomeScreen()),
      ],
    );
  }
}

