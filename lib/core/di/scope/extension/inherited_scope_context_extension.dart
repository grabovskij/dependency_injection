import 'package:dependency_injection/core/di/scope/base/inherited_scope.dart';
import 'package:flutter/widgets.dart';

/// Расширение для [BuildContext], предоставляющее методы для работы с [InheritedScope].
extension InheritedScopeContextExtension on BuildContext {
  /// Чтение значения типа [T] из [InheritedScope] без отслеживания изменений.
  ///
  /// Используйте этот метод, если вам нужно получить значение только один раз.
  ///
  /// Возвращает значение типа [T], если [InheritedScope] существует в контексте.
  /// Бросает исключение, если область не найдена.
  T readValue<T>() => InheritedScope.read<T>(this);

  /// Отслеживание значения типа [T] из [InheritedScope] с обновлением при изменениях.
  ///
  /// Используйте этот метод, если вам нужно, чтобы виджет пересоздавался при изменении значения.
  ///
  /// Возвращает значение типа [T], если [InheritedScope] существует в контексте.
  /// Бросает исключение, если область не найдена.
  T watchValue<T>() => InheritedScope.watch<T>(this);
}
