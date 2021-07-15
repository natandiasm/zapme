import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:badges/badges.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:zapme/controller/cart_controller.dart';
import 'package:zapme/screen/cart_screen.dart';

Widget scaffoldCustom({required context, required body, required int index, required title}) {
  final CartController cartController = Get.find();
  final PageController pageController = Get.find();
  return Scaffold(
    appBar: AppBar(
      elevation: 0,
      title: title,
      backgroundColor: Get.theme.primaryColor,
    ),
    backgroundColor: Get.theme.backgroundColor,
    body: body,
    bottomNavigationBar: AnimatedBottomNavigationBar(
      activeColor: Colors.white,
      inactiveColor: Colors.white.withOpacity(0.5),
      backgroundColor: Get.theme.primaryColor,
      gapLocation: GapLocation.end,
      leftCornerRadius: 20,
      notchSmoothness: NotchSmoothness.smoothEdge,
      icons: <IconData>[
        FeatherIcons.coffee,
        FeatherIcons.info,
      ],
      activeIndex: index,
      onTap: (index) => {
        pageController.animateToPage(index,
            duration: Duration(milliseconds: 500), curve: Curves.ease)
      },
      //other params
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    floatingActionButton: Badge(
        toAnimate: true,
        badgeContent: Obx(() => Text(
              "${cartController.cart.count}",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            )),
        position: BadgePosition.topStart(),
        badgeColor: Get.theme.focusColor,
        padding: EdgeInsets.all(10.00),
        animationType: BadgeAnimationType.scale,
        child: FloatingActionButton(
          backgroundColor: Get.theme.buttonColor,
          onPressed: () {
            Get.to(() => CartScreen());
          },
          tooltip: 'Carrinho',
          child: Icon(
            FeatherIcons.shoppingBag,
            color: Get.theme.accentColor,
          ),
        )),
  );
}
