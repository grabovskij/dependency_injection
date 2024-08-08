import 'package:dependency_injection/core/di/scope/base/global_scope.dart';

/// Миксин для использования функций класса [GlobalScope].
mixin GlobalScopeProvidingMixin {
  /// Записывает значение в реестр.
  ///
  /// [value] - значение для записи.
  /// [replace] - флаг, указывающий, нужно ли заменить существующее значение.
  ///
  /// Возвращает записанное значение.
  T writeGlobal<T>(T value, {bool replace = false}) {
    return GlobalScope.write(value, replace: replace);
  }

  /// Читает значение из реестра.
  ///
  /// Возвращает значение типа [T].
  /// Бросает исключение, если значение не найдено.
  T readGlobal<T>() {
    return GlobalScope.read<T>();
  }

  /// Читает значение из реестра или возвращает null, если значение не найдено.
  ///
  /// Возвращает значение типа [T] или null.
  T? readOrNullGlobal<T>() {
    return GlobalScope.readOrNull<T>();
  }
}
