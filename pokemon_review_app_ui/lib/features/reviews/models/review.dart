class Review {
  final int id;
  final String title;
  final String text;
  final int rating;

  Review({required this.id, required this.title, required this.text, required this.rating});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      text: json['text'] as String? ?? '',
      rating: json['rating'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'text': text,
        'rating': rating,
      };
}
