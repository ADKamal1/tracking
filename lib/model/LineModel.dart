class Line {
  final String name;
  final List<String> classification;
  final List<String> distribution;
  final List<String> speciality;
  final List<Product> products;

  Line({
    required this.name,
    required this.classification,
    required this.distribution,
    required this.speciality,
    required this.products,
  });

  factory Line.fromJson(Map<String, dynamic> json) {
    return Line(
      name: json['name'] ?? '',
      classification: List<String>.from(json['classification'] ?? []),
      speciality: List<String>.from(json['speciality'] ?? []),
      products: (json['product'] is List)
          ? (json['product'] as List)
          .map((item) => Product.fromJson(item))
          .toList()
          : [],
      distribution: List<String>.from(json['distribution'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'classification': classification,
      'distribution': distribution,
      'speciality': speciality,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}

class Product {
  String name;
  String brief;

  Product({
    required this.name,
    required this.brief,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['Product Name']??"",
      brief: json['Brief']??"",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Product Name': name??"",
      'Brief': brief??"",
    };
  }
}
