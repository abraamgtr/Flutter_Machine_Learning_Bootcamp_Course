import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news_app_section18/Models/News/Article_model.dart';
import 'package:news_app_section18/Models/News/News_service.dart';

import 'articles_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;
  late NewsApiService newsApiService;

  setUp(() {
    mockClient = MockClient();
    newsApiService = NewsApiService(mockClient);
  });

  final uri = Uri.parse(
      '/everything?q=flutter&apiKey=788576fa85e0490eacac2d580771d924');
  const jsonString = """
  {
    "source": "ReadWrite",
    "author": "Chris Gale",
    "title": "What Drives Choosing Flutter Over React Native?",
    "description": "For those looking at open-source options",
    "url": "https://readwrite.com/what-drives-choosing-flutter-over-react-native/",
    "urlToImage": "https://images.readwrite.com/wp-content/uploads/2022/11/Super-hero-3497522.jpg",
    "publishedAt": "2022-12-09T16:00:37Z",
    "content": "For those looking at open-source options for applications"
    }
    """;

  final article = Article(
    source: "ReadWrite",
    author: "Chris Gale",
    title: "What Drives Choosing Flutter Over React Native?",
    description: "For those looking at open-source options",
    url:
        "https://readwrite.com/what-drives-choosing-flutter-over-react-native/",
    urlToImage:
        "https://images.readwrite.com/wp-content/uploads/2022/11/Super-hero-3497522.jpg",
    publishedAt: DateTime.parse("2022-12-09T16:00:37Z"),
    content: "For those looking at open-source options for applications",
  );

  test('should return an article object with success when status code is 200',
      () async {
    // arrange
    when(mockClient.get(uri))
        .thenAnswer((_) async => http.Response(jsonString, 200));
    // act
    final result = await newsApiService.fetchArticle();
    // assert
    expect(result, equals(article));
    verify(mockClient.get(uri));
  });
}
