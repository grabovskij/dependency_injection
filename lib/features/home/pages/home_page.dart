import 'package:dependency_injection/core/di/data_source_scope.dart';
import 'package:dependency_injection/features/home/controllers/tweet_loadin_controller.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TweetLoadingController controller;

  @override
  void initState() {
    super.initState();
    controller = TweetLoadingController(
      DataSourceScope.of(context).fakeDataSource,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: controller.stateStream,
        builder: (context, snapshot) {
          final state = snapshot.data ?? TweetInitialState();

          return Center(
            child: switch (state) {
              TweetInitialState() => const SizedBox.shrink(),
              TweetLoadingState() => const CircularProgressIndicator(),
              TweetLoadedState() => Text(state.tweet.message),
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.init,
        tooltip: 'Increment',
        child: const Icon(Icons.download),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
