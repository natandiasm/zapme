import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:zapme/controller/cart_controller.dart';
import 'package:zapme/controller/restaurant_controller.dart';
import 'package:zapme/model/product_modal.dart';
import 'package:zapme/util/money_format.dart';

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
                      Obx(() => ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: cartController.getProducts().length,
                          itemBuilder: (context, i) {
                            return Column(
                              children: [
                                _tileProduct(products[i]),
                                Divider(
                                  height: 2,
                                  color: Colors.grey.withOpacity(0.6),
                                )
                              ],
                            );
                          })),
                      ListTile(
                        title: Text(
                          "Subtotal",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        trailing: Obx(() => Text(
                              MoneyFormat.getPriceFormatted(
                                  cartController.getSubTotal()),
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            )),
                      ),
                      Column(
                        children: [
                          ListTile(
                            title: Text(
                              "Entrega",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            trailing: Text(
                              MoneyFormat.getPriceFormatted(restaurantController
                                  .restaurant?.shippingPrice),
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
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
                            trailing: Obx(() => Text(
                                  MoneyFormat.getPriceFormatted(
                                      cartController.getSubTotal() + 5.00),
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Get.theme.primaryColor,
                                      fontWeight: FontWeight.w700),
                                )),
                          ),
                        ],
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
                                  Obx(() => Flexible(
                                        child: Text(
                                          cartController.cart.addressUser
                                                      .length ==
                                                  0
                                              ? 'Selecione seu endereço'
                                              : cartController.cart.addressUser
                                                  .join(' - '),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500),
                                        ),
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
                                    cartController.cart.paymentMethod.value,
                                    style: TextStyle(color: Colors.white),
                                  )),
                              padding: EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Get.theme.buttonColor,
                              onPressed: () {
                                cartController.paymentMethodOnTap();
                              },
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
                              onPressed: () {
                                cartController.paymentToWhatsOnTap(
                                    restaurantController.restaurant!.phone);
                              },
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

  Widget _tileProduct(Product product) {
    List extraChecked = [];
    if (product.extrasOptions) {
      extraChecked = product.getExtraChecked();
    }
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(
            child: Text(
              "${product.name}",
              style: TextStyle(fontSize: 17),
              overflow: TextOverflow.fade,
            ),
          ),
          Row(
            children: [
              Text(
                "${product.amount}x ${product.getPriceFormatted()}",
                style: TextStyle(color: Get.theme.buttonColor),
              ),
              SizedBox(
                width: 5,
              ),
              IconButton(
                icon: Icon(
                  FeatherIcons.trash2,
                  size: 14,
                  color: Colors.red,
                ),
                onPressed: () {
                  cartController.removeProductOnTap(product);
                },
              )
            ],
          )
        ]),
      ),
      product.getExtrasSelected().isNotEmpty
          ? Column(
              children: List<Widget>.generate(product.getExtrasSelected().length,
                  (index) => _optionCheck(product.getExtrasSelected()[index], product)))
          : Container()
    ]);
  }

  Widget _optionCheck(option, Product product) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          option['title'],
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
        Text(
          MoneyFormat.getPriceFormatted(option['price']),
          style: TextStyle(color: Colors.black54, fontSize: 14),
        )
      ]),
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
