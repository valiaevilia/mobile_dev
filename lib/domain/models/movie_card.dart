class MovieCardData {
  final int? id;
  final String title;
  final String descriptionText;
  final String details;
  final String? poster;
  final int? year;
  final double? rating;

  const MovieCardData({
    this.id,
    required this.title,
    required this.descriptionText,
    required this.details,
    this.poster,
    this.year,
    this.rating,
  });
}