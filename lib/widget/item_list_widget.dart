import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zapme/model/product_modal.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:zapme/screen/product_details_screen.dart';

firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

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
          leading: _imgLoad(product.img),
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

Widget _imgLoad(String imgRef) {

  return FutureBuilder<String>(
    future: storage.ref('img/$imgRef')
        .getDownloadURL(),
    builder: (context, AsyncSnapshot<String> snapshot) {
      if(snapshot.hasData) {
       return Container(
          decoration: BoxDecoration(
              color: Get.theme.cardColor,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: Image.network(snapshot.data!).image
              )
          ),
          height: 60,
          width: 60,
        );
      }

      return Shimmer.fromColors(
          baseColor: Colors.black12,
          highlightColor: Colors.black38.withOpacity(0.3),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 60,
            width: 60,
          )
      );
    },
  );
}