import 'package:dependency_injection/domain/models/tweet.dart';

const _mockTweet = Tweet(id: 0, message: 'Test message');

class FakeDataSource {
  Future<Tweet> fetchTweet() async {
    return Future.delayed(const Duration(seconds: 3)).then((_) => _mockTweet);
  }
}
