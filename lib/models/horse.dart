
class Horse {
  final String id;
  final String name;
  final String imagePath;
  int position;

  Horse({
    required this.id,
    required this.name,
    required this.imagePath,
    this.position = 0,
  });
}
