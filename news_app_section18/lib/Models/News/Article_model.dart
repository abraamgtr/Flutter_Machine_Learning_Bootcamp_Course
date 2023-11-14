import 'package:equatable/equatable.dart';

class Article extends Equatable {
  Article({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  String? source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  DateTime? publishedAt;
  String? content;

  factory Article.fromJson(Map<String, dynamic>? json) {
    return Article(
      source: json?["source"],
      author: json?["author"],
      title: json?["title"],
      description: json?["description"],
      url: json?["url"],
      urlToImage: json?["urlToImage"],
      publishedAt: DateTime.parse(json?["publishedAt"] ?? ""),
      content: json?["content"],
    );
  }

  Map<String, dynamic> toJson() => {
        "source": this.source,
        "author": this.author,
        "title": this.title,
        "description": this.description,
        "url": this.url,
        "urlToImage": this.urlToImage,
        "publishedAt": this.publishedAt,
        "content": this.content,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [
        this.source,
        this.author,
        this.title,
        this.description,
        this.url,
        this.urlToImage,
        this.publishedAt,
        this.content,
      ];
}
