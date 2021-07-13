import 'package:get/get.dart';
import 'package:zapme/model/product_modal.dart';

class ProductDetailsController extends GetxController {

  Product product;
  bool extrasOptions = false;

  ProductDetailsController({required this.product});

  @override
  void onInit() {
    product.total.value = product.price;
    product.amount = 1;
    // Initialize check fields

    if(product.extra[0] != '') {
      product.extra.forEach((extra) {
        extra['options'].forEach((option) {
          option['check'] = false.obs;
        });
      });
      extrasOptions = true;
    }
    super.onInit();
  }
}