import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:zapme/controller/restaurant_controller.dart';
import 'package:zapme/model/cart_model.dart';
import 'package:zapme/model/product_modal.dart';
import 'package:zapme/widget/payment_button_widget.dart';

class CartController extends GetxController {
  CartModel cart = CartModel();

  void addToCart(product) {
    cart.setProduct(product);
    cart.count.value = cart.getCount();
  }

  double getSubTotal() {
    double subTotal = 0.0;
    cart.getList().forEach((product) {
      subTotal += product.total.value;
    });
    return subTotal;
  }

  List<Product> getProducts() {
    return cart.getList();
  }

  void removeProductOnTap(product) {
    cart.removeProduct(product);
    cart.count.value = cart.getCount();
    Get.snackbar("Removido", "O produto foi removido do carrinho!",
        backgroundColor: Colors.green,
        borderRadius: 10,
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        icon: Icon(FeatherIcons.checkCircle));
  }

  Future<bool> paymentToWhatsOnTap(String phone) async {
    if (cart.count.value == 0) {
      Get.snackbar("Atenção!", "Não a produtos no carrinho!",
          backgroundColor: Colors.orange,
          borderRadius: 10,
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          icon: Icon(FeatherIcons.alertTriangle));
      return false;
    }

    if (cart.addressUser.length == 0) {
      Get.snackbar("Atenção!", "Endereço não informado!",
          backgroundColor: Colors.orange,
          borderRadius: 10,
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          icon: Icon(FeatherIcons.alertTriangle));
      return false;
    }

    if (cart.paymentMethod.value == 'Escolher como pagar') {
      Get.snackbar("Atenção!", "Metodo de pagamento não selecionado!",
          backgroundColor: Colors.orange,
          borderRadius: 10,
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          icon: Icon(FeatherIcons.alertTriangle));
      return false;
    }

    final link = WhatsAppUnilink(
      phoneNumber: phone,
      text: cart.toStringZap(),
    );
    await launch('$link');
    return true;
  }

  void paymentMethodOnTap() {
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
                      visible: cart.allowPayments["credit_card"] as bool,
                      title: "Cartão \nde credito",
                      color: Color.fromARGB(255, 205, 238, 252),
                      subTitle: 'Pagar com',
                      onTap: () {
                        cart.paymentMethod.value = 'Cartão de credito';
                        Get.back();
                      })),
                  Obx(() => paymentAccept(
                      imagePath: 'img/card-debit.png',
                      visible: cart.allowPayments["debit_card"] as bool,
                      title: "Cartão \nde debito",
                      color: Color.fromARGB(255, 230, 213, 255),
                      subTitle: 'Pagar com',
                      onTap: () {
                        cart.paymentMethod.value = 'Cartão de debito';
                        Get.back();
                      })),
                  Obx(() => paymentAccept(
                      imagePath: 'img/money.png',
                      visible: cart.allowPayments["money"] as bool,
                      title: "Dinheiro",
                      color: Color.fromARGB(255, 193, 234, 204),
                      subTitle: 'Pagar com',
                      onTap: () async {
                        TextEditingController trocoTextController =
                            TextEditingController();
                        await Get.defaultDialog(
                            title: "",
                            content: Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
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
                                cart.moneyChange.value =
                                    trocoTextController.text;
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
                        Get.back();
                        cart.paymentMethod.value = 'Dinheiro';
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
    final _formKey = GlobalKey<FormState>();
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
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: ruaTextController,
                      decoration: InputDecoration(hintText: "Rua"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Esse campo é obrigatorio';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: bairroTextController,
                      decoration: InputDecoration(hintText: "Bairro"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Esse campo é obrigatorio';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: complementoTextController,
                      decoration: InputDecoration(hintText: "Complemento"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Esse campo é obrigatorio';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
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
              if (_formKey.currentState!.validate()) {
                if(cart.addressUser.isEmpty){
                  cart.addressUser.add(ruaTextController.text);
                  cart.addressUser.add(bairroTextController.text);
                  cart.addressUser.add(complementoTextController.text);
                } else {
                  cart.addressUser.clear();
                  cart.addressUser.add(ruaTextController.text);
                  cart.addressUser.add(bairroTextController.text);
                  cart.addressUser.add(complementoTextController.text);
                }
                Get.back();
              }
            }));
  }
}
