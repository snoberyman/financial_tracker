class Category {
  final String id;
  final String name;
  final int order;

  Category({
    required this.id,
    required this.name,
    required this.order,
  });

  factory Category.fromMap(String id, Map<String, dynamic> data) {
    return Category(
      id: id,
      name: data['name'],
      order: data['order'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'order': order,
    };
  }
}
