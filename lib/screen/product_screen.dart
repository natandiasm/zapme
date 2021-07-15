import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:zapme/controller/restaurant_controller.dart';
import 'package:zapme/util/load_screen.dart';
import 'package:zapme/widget/item_list_widget.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final RestaurantController restaurantController = Get.find();

  @override
  Widget build(BuildContext context) {
    RestaurantController restaurantController = Get.find();
    return FutureBuilder<Map<String, dynamic>>(
        future: restaurantController.getMenu(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text(
                    "Não foi possivel carregar as informações, por favor tente novamente."));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!.isEmpty) {
              return Center(
                  child: Column(
                children: [
                  Image.asset(
                    'img/woman-error.png',
                    height: 250,
                  ),
                  Text("Não foi encontrado o estabelecimento."),
                ],
              ));
            }
            Map<String, dynamic> categories = snapshot.data!;
            List<Widget> categoriesList = [];
            categories.forEach((key, products) {
              categoriesList.add(_listBuilder(name: key, products: products));
            });

            return CustomScrollView(
              slivers: categoriesList,
            );
          }

          return loadProducts(); //Center(child: CircularProgressIndicator());
        });
  }

  Widget _listBuilder({required name, required products}) {
    return SliverStickyHeader(
      header: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
        child: Container(
          height: 55,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 233, 236, 239),
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            name,
            style:
                TextStyle(color: Colors.black54, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => listItem(product: products[index]),
          childCount: products.length,
        ),
      ),
    );
  }
}
