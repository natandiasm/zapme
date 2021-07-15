import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zapme/controller/cart_controller.dart';
import 'package:zapme/controller/product_details_controller.dart';
import 'package:zapme/model/product_modal.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:zapme/widget/card_extras_widget.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final bool update;

  ProductDetailsScreen({required this.product, this.update = false});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final CartController cartController = Get.find();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final ProductDetailsController productDetailsController = ProductDetailsController();
  late Product product;

  @override
  void initState() {
    product = productDetailsController.initProduct(widget.product);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _scaffoldProduct(
        body: SingleChildScrollView(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _imgLoad(product.img),
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
              product.extrasOptions
                  ? Container(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: product.extra.length,
                        itemBuilder: (context, index) {
                          return cardExtras(product.extra[index], product);
                        },
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ],
    )));
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
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Image.network(snapshot.data!).image
                )
            ),
            height: 350,
          );
        }

        return Shimmer.fromColors(
            baseColor: Colors.black12,
            highlightColor: Colors.black38.withOpacity(0.3),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              height: 350,
            )
        );
      },
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
                        product.minusQdt();
                      },
                    ),
                    Obx(() => Text(product.amount.value.toString())),
                    IconButton(
                      icon: Icon(FeatherIcons.plus),
                      onPressed: () {
                        product.addQdt();
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
                        Obx(() => Text(
                              product.getTotalPriceFormatted(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            )),
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
