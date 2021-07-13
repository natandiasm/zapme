import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zapme/model/product_modal.dart';
import 'package:zapme/screen/product_details_screen.dart';

Widget listItem({required Product product, bool updateItem = false}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector(
      onTap: () {
        Get.to(()=> ProductDetailsScreen(
          product: product,
          update: false,
        ));
      },
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Get.theme.cardColor),
        child: ListTile(
          leading: Container(
            decoration: BoxDecoration(
                color: Get.theme.cardColor,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: Image.network(product.img).image
                )
            ),
            height: 60,
            width: 60,
          ),
          title: Text(product.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.detail),
              Text(
                product.getPriceFormatted(),
                style: TextStyle(
                    color: Get.theme.buttonColor,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
