# Пример внедрения зависимостей в Flutter

Этот проект демонстрирует, как реализовать внедрение зависимостей и управление состоянием в приложении Flutter с использованием `InheritedScope` и пользовательских контроллеров. Проект включает базовые примеры настройки источников данных и управления состоянием приложения с помощью `TweetLoadingController`.

## Содержание

- [Начало работы](#начало-работы)
- [Структура проекта](#структура-проекта)
- [Основные компоненты](#основные-компоненты)
- [Запуск приложения](#запуск-приложения)
- [Участие в разработке](#участие-в-разработке)
- [Лицензия](#лицензия)

## Начало работы

Чтобы запустить локальную копию, следуйте этим простым шагам.

### Необходимые условия

- Flutter SDK: [Руководство по установке](https://flutter.dev/docs/get-started/install)
- Dart SDK: включен в Flutter
- IDE: VSCode, IntelliJ, Android Studio или любой другой редактор на ваш выбор

### Установка

1. Клонируйте репозиторий
   ```sh
   git clone https://github.com/your_username/flutter_dependency_injection_demo.git
   ```
2. Перейдите в каталог проекта
   ```sh
   cd flutter_dependency_injection_demo
   ```
3. Установите зависимости
   ```sh
   flutter pub get
   ```

## Структура проекта

```
lib/
├── core/
│   ├── application.dart
│   ├── di/
│   │   ├── data_source_scope.dart
│   │   └── scope/
│   │       ├── api/
│   │       │   └── base_inherited_scope.dart
│   │       ├── base/
│   │       │   └── inherited_scope.dart
│   │       └── extension/
│   │           └── inherited_scope_context_extension.dart
├── data/
│   └── data_sources/
│       └── fake_data_source.dart
├── domain/
│   └── models/
│       └── tweet.dart
├── features/
│   └── home/
│       ├── controllers/
│       │   └── tweet_loading_controller.dart
│       └── pages/
│           └── home_page.dart
└── main.dart
```

## Основные компоненты

### 1. `main.dart`

Точка входа в приложение. Инициализирует `DataSourceScope` и запускает приложение.

```dart
import 'dart:async';
import 'package:dependency_injection/core/application.dart';
import 'package:dependency_injection/core/di/data_source_scope.dart';
import 'package:flutter/material.dart';

void main() {
  runZonedGuarded(
    () => runApp(
      const DataSourceScope(
        child: MyApp(),
      ),
    ),
    (_, __) {},
  );
}
```

### 2. `DataSourceScope`

StatefulWidget, который инициализирует и предоставляет источники данных дереву виджетов с использованием `InheritedScope`.

```dart
import 'package:dependency_injection/core/di/scope/base/inherited_scope.dart';
import 'package:dependency_injection/core/di/scope/extension/inherited_scope_context_extension.dart';
import 'package:dependency_injection/data/data_sources/fake_data_source.dart';
import 'package:flutter/widgets.dart';

class DataSourceScope extends StatefulWidget {
  static DataSources of(BuildContext context) =>
      context.readValue<DataSources>();

  final Widget child;

  const DataSourceScope({
    required this.child,
    super.key,
  });

  @override
  State<DataSourceScope> createState() => _DataSourceScopeState();
}

class _DataSourceScopeState extends State<DataSourceScope> {
  late final DataSources _dataSources;

  @override
  void initState() {
    super.initState();
    _dataSources = DataSources.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return InheritedScope.value(
      value: _dataSources,
      child: widget.child,
    );
  }
}

class DataSources {
  final FakeDataSource fakeDataSource;

  const DataSources({required this.fakeDataSource});

  factory DataSources.init(BuildContext context) {
    return DataSources(fakeDataSource: FakeDataSource());
  }
}
```

### 3. `TweetLoadingController`

Контроллер, который управляет состоянием загрузки твитов с использованием `StreamController`.

```dart
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
```

### 4. `MyHomePage`

StatefulWidget, демонстрирующий, как использовать `TweetLoadingController` для загрузки и отображения твитов.

```dart
import 'package:dependency_injection/core/di/data_source_scope.dart';
import 'package:dependency_injection/features/home/controllers/tweet_loading_controller.dart';
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
        tooltip: 'Load Tweet',
        child: const Icon(Icons.download),
      ),
    );
  }
}
```

## Запуск приложения

1. Убедитесь, что вы выполнили шаги по установке из раздела [Начало работы](#начало-работы).
2. Запустите приложение
   ```sh
   flutter run
   ```

## Участие в разработке

Участие делает сообщество с открытым исходным кодом таким удивительным местом для обучения, вдохновения и создания. Любые ваши вклады **очень ценятся**.

1. Сделайте форк проекта
2. Создайте свою ветку для новой функции (`git checkout -b feature/AmazingFeature`)
3. Сделайте коммит изменений (`git commit -m 'Add some AmazingFeature'`)
4. Отправьте изменения в ветку (`git push origin feature/AmazingFeature`)
5. Откройте Pull Request

## Лицензия

Распространяется по лицензии MIT. Смотрите файл `LICENSE.txt` для получения дополнительной информации.

---

Этот README файл предоставляет обзор структуры проекта и компонентов, а также инструкции по настройке и запуску проекта. Не стесняйтесь изменять его, чтобы лучше соответствовать специфике и требованиям вашего проекта.
