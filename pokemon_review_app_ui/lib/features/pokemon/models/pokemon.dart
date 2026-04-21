class Pokemon {
  final int id;
  final String name;
  final DateTime birthDate;

  Pokemon({required this.id, required this.name, required this.birthDate});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'] as int,
      name: json['name'] as String,
      birthDate: DateTime.tryParse(json['birthDate'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'birthDate': birthDate.toIso8601String(),
      };
}
