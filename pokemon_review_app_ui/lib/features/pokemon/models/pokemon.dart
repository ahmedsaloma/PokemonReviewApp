class Pokemon {
  final int id;
  final String name;
  final String? imageUrl;
  final DateTime birthDate;

  Pokemon({
    required this.id, 
    required this.name, 
    this.imageUrl,
    required this.birthDate
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      birthDate: DateTime.tryParse(json['birthDate'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'birthDate': birthDate.toIso8601String(),
      };
}
