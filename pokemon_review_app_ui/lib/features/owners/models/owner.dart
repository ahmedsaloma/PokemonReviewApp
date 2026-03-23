class Owner {
  final int id;
  final String firstName;
  final String lastName;
  final String gym;
  final int countryId;

  Owner({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gym,
    required this.countryId,
  });

  String get fullName => '$firstName $lastName';

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'] as int,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      gym: json['gym'] as String? ?? '',
      countryId: json['countryId'] as int? ?? 0,
    );
  }
}
