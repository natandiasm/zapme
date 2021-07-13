class MoneyFormat{
  static String getPriceFormatted(double? price) {
    return "R\$ ${price!.toStringAsFixed(2).replaceAll('.', ',')} ";
  }
}