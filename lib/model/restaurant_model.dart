class Restaurant {
  final String logo;
  final String name;
  final String phone;
  final String description;
  final String local;
  final String subTitle;
  final String time;
  final double shippingPrice;
  final Map<String, dynamic> allowPayments;

  Restaurant(
      {required this.logo,
      required this.name,
      required this.phone,
      required this.description,
      required this.local,
      required this.subTitle,
      required this.time,
      required this.shippingPrice,
      required this.allowPayments});

  Restaurant.fromJson(Map<String, dynamic> json)
      : this(
          logo: json['logo']! as String,
          name: json['name']! as String,
          phone : json['phone'] as String,
          description: json['description']! as String,
          local: json['local']! as String,
          subTitle: json['sub_title']! as String,
          time: json['time']! as String,
          shippingPrice: json['shipping_price']! as double,
          allowPayments: json['allow_payments']! as Map<String, dynamic>,
        );
}
