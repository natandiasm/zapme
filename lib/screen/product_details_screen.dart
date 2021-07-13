import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:zapme/controller/cart_controller.dart';
import 'package:zapme/model/product_modal.dart';
import 'package:zapme/util/money_format.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final bool update;

  ProductDetailsScreen({required this.product, this.update = false});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final CartController cartController = Get.find();
  late final Product product;

  @override
  void initState() {
    product = widget.product;
    product.total = product.price;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(product.extra);
    return _scaffoldProduct(
        body: SingleChildScrollView(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Get.theme.cardColor,
              image: DecorationImage(
                  fit: BoxFit.fill, image: Image.network(product.img).image)),
          height: 350,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 10),
                child: Text(
                  product.name,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                ),
              ),
              Text(product.detail,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(product.getPriceFormatted(),
                    style: TextStyle(
                        fontSize: 18,
                        color: Get.theme.primaryColor,
                        fontWeight: FontWeight.w500)),
              ),
              Container(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: product.extra.length,
                  itemBuilder: (context, index) {
                    return _cardExtras(product.extra[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    )));
  }

  Widget _cardExtras(Map<String, dynamic> extra) {
    List options = extra['options'] as List;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                extra['title'],
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Get.theme.primaryColor),
              ),
            ),
            Column(
              children:
                  List.generate(options.length, (index) => _optionCheck(options[index])),
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionCheck(option) {
    print(option);
    return CheckboxListTile(
      title: Row(
          children:[
            Text(option['title']),
            Text(MoneyFormat.getPriceFormatted(option['price']))
          ]),
        value: true,
        onChanged: (bool? value) {},
        );
  }

  Widget _scaffoldProduct({required body}) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Get.theme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(top: 5, left: 5),
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Get.theme.cardColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20)),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(FeatherIcons.arrowLeft),
              color: Colors.black,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Container(
          padding: EdgeInsets.all(10),
          height: 70,
          decoration: BoxDecoration(
              color: Get.theme.backgroundColor,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 20, offset: Offset(3, 3))
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Get.theme.cardColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(FeatherIcons.minus),
                      onPressed: () {
                        setState(() {
                          product.minusQdt();
                        });
                      },
                    ),
                    Text(product.amount.toString()),
                    IconButton(
                      icon: Icon(FeatherIcons.plus),
                      onPressed: () {
                        setState(() {
                          product.addQdt();
                        });
                      },
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  cartController.addToCart(product);
                  Get.back();
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: Get.theme.buttonColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Text(
                            "Adicionar",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Text(
                          product.getTotalPriceFormatted(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: body,
    );
  }
}
