class Reviewer {
  final int id;
  final String firstName;
  final String lastName;

  Reviewer({required this.id, required this.firstName, required this.lastName});

  String get fullName => '$firstName $lastName';

  factory Reviewer.fromJson(Map<String, dynamic> json) {
    return Reviewer(
      id: json['id'] as int,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
    );
  }
}
