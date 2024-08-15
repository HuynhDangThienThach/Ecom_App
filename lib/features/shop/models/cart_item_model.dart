class CartItemModel {
  String productId;
  String title;
  String? image;
  String variationId;
  String? brandName;
  double price;
  int quantity;
  Map<String, String>? selectedVariation;

  // Constructor
  CartItemModel({
    required this.productId,
    required this.quantity,
    this.variationId = "",
    this.image,
    this.price = 0.0,
    this.title = '',
    this.brandName,
    this.selectedVariation,
  });

  // Empty Cart
  static CartItemModel empty() => CartItemModel(productId: '', quantity: 0);

  // Convert a CartItem to a Json Map
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'image': image,
      'variationId': variationId,
      'brandName': brandName,
      'price': price,
      'quantity': quantity,
      'selectedVariation': selectedVariation,
    };
  }

  // Create a CartItem from a Json Map
  factory CartItemModel.fromJson(Map<String, dynamic> json){
    return CartItemModel(
      productId: json['productId'],
      title: json['title'],
      image: json['image'],
      variationId: json['variationId'],
      brandName: json['brandName'],
      price: json['price']?.toDouble(),
      quantity: json['quantity'],
      selectedVariation: json['selectedVariation'] != null ? Map<String, String>.from(json['selectedVariation']) : null,
    );
  }
}