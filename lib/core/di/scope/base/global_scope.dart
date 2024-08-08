/// Класс для управления областью видимости (GlobalScope), который позволяет
/// регистрировать и получать значения по типу.
class GlobalScope {
  /// Реестр для хранения значений по типу
  static final _registry = <Type, dynamic>{};

  /// Метод для записи значения в реестр.
  ///
  /// [value] - значение для записи.
  /// [replace] - флаг, указывающий, нужно ли заменить существующее значение.
  ///
  /// Возвращает записанное значение.
  static T write<T>(
    T value, {
    bool replace = false,
  }) {
    assert(
      !_registry.containsKey(T) || replace,
      'Registry must have only one value of type $T',
    );

    _registry[T] = value;

    return value;
  }

  /// Метод для чтения значения из реестра или возвращает null, если значение не найдено.
  ///
  /// Возвращает значение типа [T] или null.
  static T? readOrNull<T>() {
    return _registry[T];
  }

  /// Метод для чтения значения из реестра.
  ///
  /// Возвращает значение типа [T].
  /// Бросает исключение, если значение не найдено.
  static T read<T>() {
    assert(
      _registry.containsKey(T),
      'At first need to add value of type $T to Registry, before reading him',
    );

    return readOrNull<T>()!;
  }

  /// Метод для удаления значения из реестра.
  ///
  /// Возвращает значение типа [T].
  /// Бросает исключение, если значение не найдено.
  static T? remove<T>() {
    if (!_registry.keys.contains(T)) {
      return null;
    }

    return _registry.remove(T);
  }

  /// Метод для очистки реестра.
  static void dispose() {
    _registry.clear();
  }
}
