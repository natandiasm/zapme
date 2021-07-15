import 'package:zapme/model/product_modal.dart';
import 'package:get/get.dart';

class CartModel {
  final List<Product> _products = <Product>[].obs;
  var count = 0.obs;
  var allowPayments =
      {'credit_card': true, 'debit_card': true, 'money': true}.obs;
  var paymentMethod = 'Escolher como pagar'.obs;
  var moneyChange = ''.obs;
  var addressUser = [].obs;

  void setProduct(Product product) {
    this._products.add(product);
  }

  void removeProduct(product){
    _products.remove(product);
  }

  int getCount() {
    int count = 0;
    _products.forEach((product) {
      count += product.amount.value;
    });
    return count;
  }

  List<Product> getList() {
    return _products;
  }

  String toStringZap() {
    String textZap = '';
    _products.forEach((Product product) {
      textZap += '${product.toStringZap()}';
    });
    textZap += 'Metodo de pagamento: ${paymentMethod.value} \n';
    if (paymentMethod.value == 'dinheiro') {
      textZap += 'Troco: ${moneyChange.value} \n';
    }
    textZap +=
        '*Endereço:* \n\r Rua: ${addressUser[0]} \n\r Bairro: ${addressUser[1]} \n\r Complemento:  ${addressUser[2]}';
    return textZap;
  }
}
