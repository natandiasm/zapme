import 'package:get/get.dart';
import 'package:zapme/util/money_format.dart';

class Product {
  final String name;
  final String detail;
  final String img;
  final double price;
  final List extra;
  List _extrasSelected = [];
  var amount = 1.obs;
  var total = 0.0.obs;
  bool extrasOptions = false;

  Product({
    required this.name,
    required this.detail,
    required this.img,
    required this.price,
    required this.extra,
  });

  Product.fromJson(Map<String, dynamic> json)
      : this(
          name: json['name']! as String,
          detail: json['detail']! as String,
          img: json['img']! as String,
          price: json['price']! as double,
          extra: json['extra']! as List,
        );

  Product.copyWith(Product product): this(
    name : product.name,
    img : product.img,
    detail: product.detail,
    price: product.price,
    extra: product.extra,
  );

  void addQdt() {
    amount++;
    total.value = price * amount.value;
  }

  void addToTotal(double value) {
    total.value += value;
  }

  void minusToTotal(double value) {
    total.value -= value;
  }

  void minusQdt() {
    if (amount.value != 1) {
      amount--;
      total.value = price * amount.value;
    }
  }

  void addExtraSelected(extra){
    _extrasSelected.add(extra);
  }

  void removeExtraSelected(extra){
    _extrasSelected.remove(extra);
  }

  List getExtrasSelected(){
    return _extrasSelected;
  }

  List getExtraChecked(){
    List optionsChecked = [];
    extra.forEach((extras) {
      extras['options'].forEach((op) {
        if (op['check'] == true) {
          optionsChecked.add(op);
        }
      });
    });

    return optionsChecked;
  }

  String getTotalPriceFormatted() {
    return "R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')} ";
  }

  String getPriceFormatted() {
    return "R\$ ${price.toString().replaceAll('.', ',')} ";
  }

  String toStringZap(){
    String extrasZap = '';
    if(extra[0] != '') {
      List extrasChecked = getExtraChecked();
      extrasChecked.forEach((option) {
        extrasZap += ' _${option['title']} ${MoneyFormat.getPriceFormatted(option['price'])}_ \n\r';
      });
    }

    return '*$name*  x${amount.value}  ${MoneyFormat.getPriceFormatted(price)} \n\r $extrasZap';
  }
}
