import 'package:dependency_injection/core/di/scope/base/global_scope.dart';
import 'package:flutter/widgets.dart';

/// Расширение для [BuildContext], предоставляющее методы чтения и записи значений в [GlobalScope].
extension GlobalScopeContextExtension on BuildContext {
  /// Читает значение из реестра [GlobalScope].
  ///
  /// Возвращает значение типа [T].
  /// Бросает исключение, если значение не найдено.
  T readGlobal<T>() => GlobalScope.read();

  /// Записывает значение в реестр [GlobalScope].
  ///
  /// [value] - значение для записи.
  ///
  /// Возвращает записанное значение.
  T writeGlobal<T>(T value, {bool replace = false}) {
    return GlobalScope.write(value, replace: replace);
  }

  /// Метод для удаления значения из реестра.
  ///
  /// Возвращает значение типа [T].
  /// Бросает исключение, если значение не найдено.
  T? removeGlobal<T>([T? value]) {
    return GlobalScope.remove<T>();
  }
}
