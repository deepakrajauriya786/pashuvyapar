class Product {
  String id;
  List<String> images;
  String userId;
  String categoryId;
  String title;
  String price;
  String description;
  String location;
  String date;
  String time;

  Product({
    required this.id,
    required this.images,
    required this.userId,
    required this.categoryId,
    required this.title,
    required this.price,
    required this.description,
    required this.location,
    required this.date,
    required this.time,
  });

  // Factory method to parse JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    List<dynamic> images = json['images'] ?? [];
    return Product(
      id: json['p_id'] ?? '',
      images: List<String>.from(images),
      userId: json['u_id'] ?? '',
      categoryId: json['c_id'] ?? '',
      title: json['title'] ?? '',
      price: json['price'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
    );
  }
}