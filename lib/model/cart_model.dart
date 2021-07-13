import 'package:zapme/model/product_modal.dart';

class CartModel {
  final List<Product> _products = <Product>[];
  Map<String, dynamic>? addressUser;


  void setProduct(Product product) {
    this._products.add(product);
  }

  int getCount() {
    int count = 0;
    _products.forEach((product) {
      count += product.amount;
    });
    return count;
  }

  List<Product> getList() {
    return _products;
  }

}
