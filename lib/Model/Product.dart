class Product {
  int? id;
  String name;
  double price;
  String imagePath;
  String category;
  int availableQty;
  int? inCartNumber;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.category,
    required this.availableQty,
    this.inCartNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image_path': imagePath,
      'category': category,
      'availableQty': availableQty,
    };
  }

  static Product fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      imagePath: map['imagePath'],
      category: map['category'],
      availableQty: map['availableQty'],
    );
  }
}
