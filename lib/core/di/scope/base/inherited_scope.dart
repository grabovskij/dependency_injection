import 'package:dependency_injection/core/di/scope/api/base_inherited_scope.dart';
import 'package:flutter/widgets.dart';

/// Наследуемая область, предоставляющая значение типа [T].
class InheritedScope<T> extends BaseInheritedScope {
  /// Статический метод для безопасного получения значения из контекста.
  /// При передаче [listen] = true производится отслеживания значения из
  /// контекста.
  /// Реализация сохраняет классический подход команды Flutter.
  ///
  /// Возвращает значение типа [T] или null, если область не найдена.
  static T? maybeOf<T>(BuildContext context, {bool listen = false}) {
    return listen
        ? context.dependOnInheritedWidgetOfExactType<InheritedScope<T>>()?.value
        : context.getInheritedWidgetOfExactType<InheritedScope<T>>()?.value;
  }

  /// Статический метод для безопасного получения значения из контекста.
  /// При передаче [listen] = true производится отслеживания значения из
  /// контекста.
  /// Реализация сохраняет классический подход команды Flutter.
  ///
  /// Возвращает значение типа [T]. Бросает исключение, если область не найдена.
  static T of<T>(BuildContext context, {bool listen = false}) {
    final extraction = maybeOf<T>(context, listen: listen);

    assert(
      extraction != null,
      'No InheritedValueScope found for type $T',
    );

    return extraction!;
  }

  /// Статический метод для безопасного получения значения из контекста.
  ///
  /// Возвращает значение типа [T] или null, если область не найдена.
  static T? maybeRead<T>(BuildContext context) {
    return context.getInheritedWidgetOfExactType<InheritedScope<T>>()?.value;
  }

  /// Статический метод для безопасного отслеживания значения из контекста.
  ///
  /// Возвращает значение типа [T] или null, если область не найдена.
  static T? maybeWatch<T>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedScope<T>>()
        ?.value;
  }

  /// Статический метод для получения значения из контекста.
  ///
  /// Возвращает значение типа [T]. Бросает исключение, если область не найдена.
  static T read<T>(BuildContext context) {
    final result = maybeRead<T>(context);

    assert(
      result != null,
      'No InheritedValueScope found for type $T',
    );

    return result!;
  }

  /// Статический метод для отслеживания значения из контекста.
  ///
  /// Возвращает значение типа [T]. Бросает исключение, если область не найдена.
  static T watch<T>(BuildContext context) {
    final result = maybeWatch<T>(context);

    assert(
      result != null,
      'No InheritedValueScope found for type $T',
    );

    return result!;
  }

  /// Значение, предоставляемое областью.
  final T value;

  /// Конструктор для создания наследуемой области с заданным значением.
  const InheritedScope._(
    this.value, {
    required super.child,
    super.notifier,
    super.key,
  });

  /// Фабричный конструктор для создания области с значением.
  ///
  /// Аргументы:
  /// - [value]: Значение, предоставляемое областью.
  /// - [listen]: Необходимость уведомлять слушателей об изменения [Listenable].
  /// - [child]: Дочерний виджет.
  /// - [key]: Ключ для виджета.
  factory InheritedScope.value({
    required T value,
    bool listen = true,
    Widget? child,
    Key? key,
  }) {
    final notifier = value is Listenable && listen ? value : null;

    return InheritedScope<T>._(
      value,
      key: key,
      notifier: notifier,
      child: child ?? const SizedBox.shrink(),
    );
  }

  @override
  bool updateShouldNotify(InheritedScope<T> oldWidget) {
    return value != oldWidget.value;
  }

  @override
  InheritedScope<T> copyWithChild(Widget child) {
    return InheritedScope._(
      value,
      key: key,
      notifier: notifier,
      child: child,
    );
  }
}
