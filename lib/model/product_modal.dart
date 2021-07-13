class Product {
  final String name;
  final String detail;
  final String img;
  final double price;
  final List extra;
  int amount;
  double total;

  Product(
      {required this.name,
      required this.detail,
      required this.img,
      required this.price,
      required this.extra,
      this.amount = 1,
      this.total = 0.0});

  Product.fromJson(Map<String, dynamic> json)
      : this(
    name: json['name']! as String,
    detail: json['detail']! as String,
    img: json['img']! as String,
    price: json['price']! as double,
    extra: json['extra']! as List,
  );

  void addQdt() {
    amount++;
    total = price * amount;
  }

  void minusQdt() {
    if (amount != 1) {
      amount--;
      total = price * amount;
    }
  }

  String getTotalPriceFormatted() {
    return "R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')} ";
  }

  String getPriceFormatted() {
    return "R\$ ${price.toString().replaceAll('.', ',')} ";
  }
}
