import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:zapme/controller/restaurant_controller.dart';
import 'package:zapme/model/cart_model.dart';
import 'package:zapme/model/product_modal.dart';
import 'package:zapme/widget/payment_button_widget.dart';

class CartController extends GetxController {
  var count = 0.obs;
  var allowPayments =
      {'credit_card': true, 'debit_card': true, 'money': true}.obs;
  var paymentMethod = 'Escolher como pagar'.obs;
  var moneyChange = ''.obs;
  var userAddress = "Selecione o seu endereço".obs;
  CartModel cart = CartModel();

  void addToCart(product) {
    cart.setProduct(product);
    count.value = cart.getCount();
  }

  double getSubTotal() {
    double subTotal = 0.0;
    cart.getList().forEach((product) {
      subTotal += product.total;
    });
    return subTotal;
  }

  List<Product> getProducts() {
    return cart.getList();
  }

  void paymentMethodOnTap() {
    final RestaurantController restaurantController = Get.find();
    Get.defaultDialog(
        title: "",
        content: Container(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  "Metodo de pagamento",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Get.theme.primaryColor,
                      fontSize: 18),
                ),
              ),
              Wrap(
                runSpacing: 5.0,
                spacing: 5.0,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Obx(() => paymentAccept(
                      imagePath: 'img/card-credit.png',
                      visible: allowPayments.value["credit_card"] as bool,
                      title: "Cartão \nde credito",
                      color: Color.fromARGB(255, 205, 238, 252),
                      subTitle: 'Pagar com',
                      onTap: () {
                        paymentMethod.value = 'Cartão de credito';
                        Get.back();
                      })),
                  Obx(() => paymentAccept(
                      imagePath: 'img/card-debit.png',
                      visible: allowPayments.value["debit_card"] as bool,
                      title: "Cartão \nde debito",
                      color: Color.fromARGB(255, 230, 213, 255),
                      subTitle: 'Pagar com',
                      onTap: () {
                        paymentMethod.value = 'Cartão de debito';
                        Get.back();
                      })),
                  Obx(() => paymentAccept(
                      imagePath: 'img/money.png',
                      visible: allowPayments.value["money"] as bool,
                      title: "Dinheiro",
                      color: Color.fromARGB(255, 193, 234, 204),
                      subTitle: 'Pagar com',
                      onTap: () {
                        TextEditingController trocoTextController =
                            TextEditingController();
                        Get.defaultDialog(
                            title: "",
                            content: Container(
                              padding:  EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Text(
                                      "Troco para o dinhero ?",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Get.theme.primaryColor,
                                          fontSize: 18),
                                    ),
                                  ),
                                  TextFormField(
                                      controller: trocoTextController,
                                      decoration: InputDecoration(
                                          hintText: "Para quanto",
                                          icon: Icon(FeatherIcons.dollarSign))),
                                ],
                              ),
                            ),
                            buttonColor: Get.theme.primaryColor,
                            confirm: MaterialButton(
                              elevation: 0,
                              color: Get.theme.primaryColor,
                              child: Text(
                                'Confirmar',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                moneyChange.value = trocoTextController.text;
                                Get.back();
                              },
                            ),
                            cancel: MaterialButton(
                              elevation: 0,
                              color: Colors.redAccent,
                              child: Text(
                                'Não',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                            ));
                        paymentMethod.value = 'Dinheiro';
                      })),
                ],
              ),
            ],
          ),
        ));
  }

  void addressSelectOnTap() {
    TextEditingController ruaTextController = TextEditingController();
    TextEditingController bairroTextController = TextEditingController();
    TextEditingController complementoTextController = TextEditingController();
    Get.defaultDialog(
        title: "",
        content: Container(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  "Digite seu o endereço",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Get.theme.primaryColor,
                      fontSize: 18),
                ),
              ),
              TextFormField(
                  controller: ruaTextController,
                  decoration: InputDecoration(hintText: "Rua")),
              TextFormField(
                  controller: bairroTextController,
                  decoration: InputDecoration(hintText: "Bairro")),
              TextFormField(
                  controller: complementoTextController,
                  decoration: InputDecoration(hintText: "Complemento")),
            ],
          ),
        ),
        confirm: MaterialButton(
            elevation: 0,
            child: Text(
              "Salvar",
              style: TextStyle(color: Colors.white),
            ),
            color: Get.theme.primaryColor,
            onPressed: () {
              Map<String, dynamic> addressUser = {
                "street": ruaTextController.text,
                "district": bairroTextController.text,
                "complement": complementoTextController.text
              };
              cart.addressUser = addressUser;
              userAddress.value =
                  "${addressUser['street']} - ${addressUser['district']}";
              Get.back();
            }));
  }
}
