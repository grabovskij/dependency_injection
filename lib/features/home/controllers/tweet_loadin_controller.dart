import 'dart:async';

import 'package:dependency_injection/data/data_sources/fake_data_source.dart';
import 'package:dependency_injection/domain/models/tweet.dart';

sealed class TweetState {}

class TweetInitialState extends TweetState {}

class TweetLoadingState extends TweetState {}

class TweetLoadedState extends TweetState {
  final Tweet tweet;

  TweetLoadedState(this.tweet);
}

class TweetLoadingController {
  final StreamController<TweetState> _stateController =
      StreamController.broadcast();

  final FakeDataSource _source;

  TweetLoadingController(this._source);

  Stream<TweetState> get stateStream => _stateController.stream;

  Future<void> init() async {
    _stateController.add(TweetLoadingState());
    final tweet = await _source.fetchTweet();
    _stateController.add(TweetLoadedState(tweet));
  }

  void dispose() {
    _stateController.close();
  }
}
