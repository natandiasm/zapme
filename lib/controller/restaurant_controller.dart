import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:zapme/model/product_modal.dart';
import 'package:zapme/model/restaurant_model.dart';

class RestaurantController extends GetxController {

  CollectionReference _restaurants =
  FirebaseFirestore.instance.collection('restaurants');
  CollectionReference _menu = FirebaseFirestore.instance.collection('menu');

  Restaurant? restaurant;

  final String restaurantSlug;

  Map<String, dynamic> categories = Map<String, dynamic>();

  RestaurantController({required this.restaurantSlug});


  @override
  onInit() async {
    restaurant = await _getInfo();
    super.onInit();
  }


  Future<Restaurant?> _getInfo() async {
      DocumentSnapshot data = await _restaurants.doc(restaurantSlug).get();
      Map<String, dynamic> dataMap = data.data() as Map<String, dynamic>;
      restaurant = Restaurant.fromJson(dataMap);
      return restaurant;
  }

  Future<Map<String, dynamic>> getMenu() async {
    if (categories.isEmpty) {
      DocumentSnapshot data = await _menu.doc(restaurantSlug).get();
      _addToCategories(data);
    }
    return categories;
  }

  void _addToCategories(DocumentSnapshot data) {
    Map<String, dynamic> dataMap = data.data() as Map<String, dynamic>;
    dataMap.forEach((key, value) {
      // Converter products im map
      Map<String, dynamic> productsMap =
      value["products"] as Map<String, dynamic>;
      // Create list empty product list
      List<Product> productsList = [];
      productsMap.forEach((key, value) {
        Product product = Product.fromJson(value);
        productsList.add(product);
      });
      // Add to categories
      categories[value['name']] = productsList;
    });
  }
}
