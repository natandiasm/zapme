import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zapme/model/product_modal.dart';
import 'package:zapme/util/money_format.dart';

Widget cardExtras(Map<String, dynamic> extra, product) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Container(
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              extra['title'],
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Get.theme.primaryColor),
            ),
          ),
          Column(
            children: List.generate(extra['options'].length,
                    (index) => _optionCheck(extra['options'][index], product)),
          ),
        ],
      ),
    ),
  );
}

Widget _optionCheck(option, Product product) {
  return Obx(()=> CheckboxListTile(
    title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(option['title']),
      Text(
        MoneyFormat.getPriceFormatted(option['price']),
        style: TextStyle(color: Get.theme.buttonColor, fontSize: 14),
      )
    ]),
    activeColor: Get.theme.buttonColor,
    value: option['check'].value,
    onChanged: (bool? value) {
      onTapExtraOption(option, value, product);
    },
  ));
}


void onTapExtraOption(option, value, product){
  option['check'].value = value! ? true : false;
  if (option['check'].value == true) {
    product.addExtraSelected(option);
    product.addToTotal(option['price']);
  } else {
    product.removeExtraSelected(option);
    product.minusToTotal(option['price']);
  }
}