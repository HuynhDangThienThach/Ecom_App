class PaymentMethodModel {
  final String name;
  final String image;

  PaymentMethodModel({required this.image, required this.name});

  static PaymentMethodModel empty() => PaymentMethodModel( name: '', image: '');
}