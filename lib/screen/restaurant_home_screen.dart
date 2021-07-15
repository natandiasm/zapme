import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zapme/controller/cart_controller.dart';
import 'package:zapme/controller/restaurant_controller.dart';
import 'package:zapme/screen/info_restaurant_screen.dart';
import 'package:zapme/screen/product_screen.dart';
import 'package:zapme/widget/scaffold_widget.dart';

class RestaurantHomeScreen extends StatefulWidget {
  @override
  _RestaurantHomeScreenState createState() => _RestaurantHomeScreenState();
}

class _RestaurantHomeScreenState extends State<RestaurantHomeScreen> {
  int bottomSelectedIndex = 0;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final CartController cartController = Get.put(CartController());
  final PageController pageController = Get.put(PageController(
    initialPage: 0,
    keepPage: true,
  ));

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return scaffoldCustom(
      title: Text(
        "Produtos",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
      context: context,
      index: bottomSelectedIndex,
      body: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text("Não foi possivel se conectar com o servidor"));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            String slug = Get.parameters['slug'] as String;
            Get.put(RestaurantController(restaurantSlug: slug));

            return PageView(
              controller: pageController,
              onPageChanged: (index) {
                pageChanged(index);
              },
              children: <Widget>[
                ProductScreen(),
                InfoRestaurantScreen(),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
