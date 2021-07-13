import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:zapme/controller/restaurant_controller.dart';
import 'package:zapme/model/restaurant_model.dart';
import 'package:zapme/widget/payment_button_widget.dart';

class InfoRestaurantScreen extends StatefulWidget {
  @override
  _InfoRestaurantScreenState createState() => _InfoRestaurantScreenState();
}

class _InfoRestaurantScreenState extends State<InfoRestaurantScreen> {
  @override
  Widget build(BuildContext context) {
    RestaurantController restaurantController = Get.find();
    return FutureBuilder<Restaurant?>(
        future: restaurantController.getInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text("Não foi possivel se conectar com o servidor"));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!.name.isEmpty) {
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

            return _cardInfo(snapshot.data!);
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget _cardInfo(Restaurant restaurant) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Get.theme.cardColor,
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: [
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    image: DecorationImage(
                        image: Image.network(restaurant.logo).image)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Text(
                  restaurant.name,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(restaurant.subTitle,
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
              ),
              Text(restaurant.description, textAlign: TextAlign.center),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text("Tipos de pagamentos: ",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ),
              Container(
                constraints: BoxConstraints(maxWidth: double.infinity),
                child: Wrap(
                  runSpacing: 5.0,
                  spacing: 5.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    paymentAccept(
                        imagePath: 'img/card-credit.png',
                        visible: restaurant.allowPayments["credit_card"],
                        title: "Cartão \nde credito",
                        color: Color.fromARGB(255, 205, 238, 252)),
                    paymentAccept(
                        imagePath: 'img/card-debit.png',
                        visible: restaurant.allowPayments["debit_card"],
                        title: "Cartão \nde debito",
                        color: Color.fromARGB(255, 230, 213, 255)),
                    paymentAccept(
                        imagePath: 'img/money.png',
                        visible: restaurant.allowPayments["money"],
                        title: "Dinheiro",
                        color: Color.fromARGB(255, 193, 234, 204)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
