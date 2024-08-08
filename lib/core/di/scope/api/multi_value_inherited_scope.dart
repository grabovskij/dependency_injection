import 'package:dependency_injection/core/di/scope/api/base_inherited_scope.dart';
import 'package:flutter/widgets.dart';

/// Виджет, который предоставляет несколько наследуемых областей.
class MultiValueInheritedScope extends StatelessWidget {
  /// Список наследуемых областей.
  final List<BaseInheritedScope> scopes;

  /// Дочерний виджет, который будет обернут в области.
  final Widget child;

  /// Конструктор для создания экземпляра [MultiValueInheritedScope].
  ///
  /// Аргументы:
  /// - [scopes]: Список наследуемых областей.
  /// - [child]: Дочерний виджет.
  const MultiValueInheritedScope({
    required this.scopes,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var currentChild = child;

    for (final scope in scopes.reversed) {
      // Оборачивает дочерний виджет в наследуемые области в обратном порядке
      currentChild = scope.copyWithChild(currentChild);
    }

    return currentChild;
  }
}
