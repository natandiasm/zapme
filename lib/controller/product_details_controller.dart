import 'package:get/get.dart';
import 'package:zapme/model/product_modal.dart';

class ProductDetailsController extends GetxController {

  Product initProduct(Product product) {
    Product clone = Product.copyWith(product);
    product = clone;
    product.total.value = product.price;
    product.amount.value = 1;
    if(product.extra[0] != '') {
      product.extra.forEach((extra) {
        extra['options'].forEach((option) {
          option['check'] = false.obs;
        });
      });
      product.extrasOptions = true;
    }
    return product;
  }

}