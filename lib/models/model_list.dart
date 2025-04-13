import 'dart:math';

class ModelList<T> {
  final List<T> _modelList;

  ModelList({List<T>? modelList}) : _modelList = modelList ?? [];

  /* --- List extended methods --- */
  int get length => _modelList.length;

  bool get isEmpty => _modelList.isEmpty;

  bool get isNotEmpty => _modelList.isNotEmpty;

  T operator [](int index) => _modelList[index];

  void operator []=(int index, T value) => _modelList[index] = value;

  void add(T value) => _modelList.add(value);

  void addAll(Iterable<T> iterable) => _modelList.addAll(iterable);

  void clear() => _modelList.clear();

  bool contains(T? element) => _modelList.contains(element);

  void insert(int index, T element) => _modelList.insert(index, element);

  void insertAll(int index, Iterable<T> iterable) => _modelList.insertAll(index, iterable);

  bool remove(T? value) => _modelList.remove(value);

  T removeAt(int index) => _modelList.removeAt(index);

  void removeWhere(bool Function(T element) test) => _modelList.removeWhere(test);

  void sort([int Function(T a, T b)? compare]) => _modelList.sort(compare);

  List<T> sublist(int start, [int? end]) => _modelList.sublist(start, end);

  void shuffle([Random? random]) => _modelList.shuffle(random);

  List<T> toList({bool growable = true}) => _modelList.toList(growable: growable);

  Set<T> toSet() => _modelList.toSet();

  T get first => _modelList.first;

  T get last => _modelList.last;

  T get single => _modelList.single;

  T elementAt(int index) => _modelList.elementAt(index);

  Iterable<T> get reversed => _modelList.reversed;

  Iterable<T> where(bool Function(T element) test) => _modelList.where(test);

  Iterable<T> whereType<T>() => _modelList.whereType<T>();

  Iterable<T> skip(int count) => _modelList.skip(count);

  Iterable<T> take(int count) => _modelList.take(count);

  Iterable<T> skipWhile(bool Function(T value) test) => _modelList.skipWhile(test);

  Iterable<T> takeWhile(bool Function(T value) test) => _modelList.takeWhile(test);

  Iterable<T> followedBy(Iterable<T> other) => _modelList.followedBy(other);

  void forEach(void Function(T element) action) => _modelList.forEach(action);

  Iterable<T> getRange(int start, int end) => _modelList.getRange(start, end);

  int indexOf(T element, [int start = 0]) => _modelList.indexOf(element, start);

  int indexWhere(bool Function(T element) test, [int start = 0]) => _modelList.indexWhere(test, start);

  int lastIndexOf(T element, [int? start]) => _modelList.lastIndexOf(element, start);

  int lastIndexWhere(bool Function(T element) test, [int? start]) => _modelList.lastIndexWhere(test, start);

  T lastWhere(bool Function(T element) test, {T Function()? orElse}) => _modelList.lastWhere(test, orElse: orElse);

  T firstWhere(bool Function(T element) test, {T Function()? orElse}) => _modelList.firstWhere(test, orElse: orElse);

  T singleWhere(bool Function(T element) test, {T Function()? orElse}) => _modelList.singleWhere(test, orElse: orElse);

  String join([String separator = ""]) => _modelList.join(separator);

  void fillRange(int start, int end, [T? fillValue]) => _modelList.fillRange(start, end, fillValue);

  void removeRange(int start, int end) => _modelList.removeRange(start, end);

  void replaceRange(int start, int end, Iterable<T> replacements) => _modelList.replaceRange(start, end, replacements);

  void retainWhere(bool Function(T element) test) => _modelList.retainWhere(test);

  void setAll(int index, Iterable<T> iterable) => _modelList.setAll(index, iterable);

  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) => _modelList.setRange(start, end, iterable, skipCount);

  Iterable<T> map<Object>(T Function(T e) toElement) => _modelList.map(toElement);

  Iterable<T> expand<Object>(Iterable<T> Function(T element) toElements) => _modelList.expand(toElements);

  T fold<Object>(T initialValue, T Function(T previousValue, T element) combine) => _modelList.fold(initialValue, combine);

  T reduce(T Function(T value, T element) combine) => _modelList.reduce(combine);

  Map<int, T> asMap() => _modelList.asMap();

  List<R> cast<R>() => _modelList.cast<R>();

  List<T> operator +(List<T> other) => _modelList + other;

  Iterator<T> get iterator => _modelList.iterator;
}