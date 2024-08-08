import 'package:flutter/widgets.dart';

/// Базовый класс для наследуемых областей.
abstract class BaseInheritedScope extends InheritedNotifier {
  /// Конструктор базовой наследуемой области.
  const BaseInheritedScope({
    required super.child,
    super.notifier,
    super.key,
  });

  /// Метод для создания копии текущего экземпляра с новым дочерним виджетом.
  ///
  /// Аргументы:
  /// - [child]: Новый дочерний виджет.
  /// - [key]: Новый ключ (необязательный).
  ///
  /// Возвращает новую копию экземпляра [BaseInheritedScope] с обновленным дочерним виджетом и ключом.
  BaseInheritedScope copyWithChild(Widget child);
}
