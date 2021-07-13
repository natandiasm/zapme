import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zapme/controller/cart_controller.dart';
import 'package:zapme/controller/restaurant_controller.dart';
import 'package:zapme/model/product_modal.dart';
import 'package:zapme/model/restaurant_model.dart';
import 'package:zapme/util/money_format.dart';
import 'package:zapme/widget/scaffold_widget.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController cartController = Get.find();
  final RestaurantController restaurantController = Get.find();
  late List<Product> products;

  @override
  void initState() {
    products = cartController.getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _scaffoldCart(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Get.theme.cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: cartController.getProducts().length,
                          itemBuilder: (context, i) {
                            return Column(
                              children: [
                                ListTile(
                                  title: Text("${products[i].name}"),
                                  trailing: Text(
                                    "${products[i].amount}x ${products[i].getPriceFormatted()}",
                                    style:
                                        TextStyle(color: Get.theme.buttonColor),
                                  ),
                                ),
                                Divider(
                                  height: 2,
                                  color: Colors.grey.withOpacity(0.6),
                                )
                              ],
                            );
                          }),
                      ListTile(
                        title: Text(
                          "Subtotal",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        trailing: Text(
                          MoneyFormat.getPriceFormatted(cartController.getSubTotal()),
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                      FutureBuilder<Restaurant?>(
                        future: restaurantController.getInfo(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                                child: Text(
                                    "Não foi possivel se conectar com o servidor"));
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    "Entrega",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                  trailing: Text(
                                    MoneyFormat.getPriceFormatted(
                                        snapshot.data?.shippingPrice),
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "Total",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  trailing: Text(
                                    MoneyFormat.getPriceFormatted(
                                        cartController.getSubTotal() + 5.00),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Get.theme.primaryColor,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            );
                          }
                          return Shimmer.fromColors(
                              baseColor: Colors.black12,
                              highlightColor: Colors.black38.withOpacity(0.2),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 30,
                              ));
                        },
                      ),
                      GestureDetector(
                        onTap: () => cartController.addressSelectOnTap(),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 233, 236, 239),
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(15),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    FeatherIcons.map,
                                    size: 40,
                                    color: Get.theme.primaryColor,
                                  ),
                                  Obx(() => Text(
                                        cartController.userAddress.string,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500),
                                      )),
                                  Icon(
                                    FeatherIcons.arrowRight,
                                    size: 25,
                                    color: Get.theme.primaryColor,
                                  ),
                                ]),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MaterialButton(
                              child: Obx(() => Text(
                                    cartController.paymentMethod.value,
                                    style: TextStyle(color: Colors.white),
                                  )),
                              padding: EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Get.theme.buttonColor,
                              onPressed: () {cartController.paymentMethodOnTap();},
                              elevation: 0,
                            ),
                            MaterialButton(
                              child: Text('Finalizar pedido',
                                  style: TextStyle(color: Colors.white)),
                              padding: EdgeInsets.all(20),
                              height: 40,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Get.theme.primaryColor,
                              onPressed: () {},
                              elevation: 0,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _scaffoldCart({required body}) {
    return Scaffold(
      body: body,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(top: 5, left: 5),
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Get.theme.primaryColor,
                borderRadius: BorderRadius.circular(20)),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(FeatherIcons.arrowLeft),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
