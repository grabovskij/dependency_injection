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
