class Employee {
  final String id;
  final String name;
  final String role;
  String? imageUrl;

  Employee({required this.id,
    required this.name,
    required this.role,
    this.imageUrl});
}