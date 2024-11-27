// my_model.dart
class Article {
  final String title;
  final String content;
  final DateTime datePublished;

  // Constructeur
  Article({
    required this.title,
    required this.content,
    required this.datePublished,
  });

  // Méthode pour convertir un objet JSON en instance de `Article`
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      content: json['content'],
      datePublished: DateTime.parse(json['datePublished']),
    );
  }

  // Méthode pour convertir une instance d'`Article` en JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'datePublished': datePublished.toIso8601String(),
    };
  }
}