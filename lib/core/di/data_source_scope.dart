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
    // Здесь возможно извлечение необходимых зависимостей из контекста
    return DataSources(fakeDataSource: FakeDataSource());
  }
}
