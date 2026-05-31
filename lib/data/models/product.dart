class Product {
  String name;
  double price;
  String? description;

  Product({required this.name, required this.price, this.description});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      if (description != null && description!.trim().isNotEmpty)
        'description': description!.trim(),
    };
  }
}
