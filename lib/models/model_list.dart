import 'dart:math';

class ModelList {
  final List<Object> _modelList;

  ModelList({List<Object>? modelList}) : _modelList = modelList ?? [];

  /* --- List extended methods --- */
  int get length => _modelList.length;

  bool get isEmpty => _modelList.isEmpty;

  bool get isNotEmpty => _modelList.isNotEmpty;

  Object operator [](int index) => _modelList[index];

  void operator []=(int index, Object value) => _modelList[index] = value;

  void add(Object value) => _modelList.add(value);

  void addAll(Iterable<Object> iterable) => _modelList.addAll(iterable);

  void clear() => _modelList.clear();

  bool contains(Object? element) => _modelList.contains(element);

  void insert(int index, Object element) => _modelList.insert(index, element);

  void insertAll(int index, Iterable<Object> iterable) => _modelList.insertAll(index, iterable);

  bool remove(Object? value) => _modelList.remove(value);

  Object removeAt(int index) => _modelList.removeAt(index);

  void removeWhere(bool Function(Object element) test) => _modelList.removeWhere(test);

  void sort([int Function(Object a, Object b)? compare]) => _modelList.sort(compare);

  List<Object> sublist(int start, [int? end]) => _modelList.sublist(start, end);

  void shuffle([Random? random]) => _modelList.shuffle(random);

  List<Object> toList({bool growable = true}) => _modelList.toList(growable: growable);

  Set<Object> toSet() => _modelList.toSet();

  Object get first => _modelList.first;

  Object get last => _modelList.last;

  Object get single => _modelList.single;

  Object elementAt(int index) => _modelList.elementAt(index);

  Iterable<Object> get reversed => _modelList.reversed;

  Iterable<Object> where(bool Function(Object element) test) => _modelList.where(test);

  Iterable<T> whereType<T>() => _modelList.whereType<T>();

  Iterable<Object> skip(int count) => _modelList.skip(count);

  Iterable<Object> take(int count) => _modelList.take(count);

  Iterable<Object> skipWhile(bool Function(Object value) test) => _modelList.skipWhile(test);

  Iterable<Object> takeWhile(bool Function(Object value) test) => _modelList.takeWhile(test);

  Iterable<Object> followedBy(Iterable<Object> other) => _modelList.followedBy(other);

  void forEach(void Function(Object element) action) => _modelList.forEach(action);

  Iterable<Object> getRange(int start, int end) => _modelList.getRange(start, end);

  int indexOf(Object element, [int start = 0]) => _modelList.indexOf(element, start);

  int indexWhere(bool Function(Object element) test, [int start = 0]) => _modelList.indexWhere(test, start);

  int lastIndexOf(Object element, [int? start]) => _modelList.lastIndexOf(element, start);

  int lastIndexWhere(bool Function(Object element) test, [int? start]) => _modelList.lastIndexWhere(test, start);

  Object lastWhere(bool Function(Object element) test, {Object Function()? orElse}) => _modelList.lastWhere(test, orElse: orElse);

  Object firstWhere(bool Function(Object element) test, {Object Function()? orElse}) => _modelList.firstWhere(test, orElse: orElse);

  Object singleWhere(bool Function(Object element) test, {Object Function()? orElse}) => _modelList.singleWhere(test, orElse: orElse);

  String join([String separator = ""]) => _modelList.join(separator);

  void fillRange(int start, int end, [Object? fillValue]) => _modelList.fillRange(start, end, fillValue);

  void removeRange(int start, int end) => _modelList.removeRange(start, end);

  void replaceRange(int start, int end, Iterable<Object> replacements) => _modelList.replaceRange(start, end, replacements);

  void retainWhere(bool Function(Object element) test) => _modelList.retainWhere(test);

  void setAll(int index, Iterable<Object> iterable) => _modelList.setAll(index, iterable);

  void setRange(int start, int end, Iterable<Object> iterable, [int skipCount = 0]) => _modelList.setRange(start, end, iterable, skipCount);

  Iterable<T> map<T>(T Function(Object e) toElement) => _modelList.map(toElement);

  Iterable<T> expand<T>(Iterable<T> Function(Object element) toElements) => _modelList.expand(toElements);

  T fold<T>(T initialValue, T Function(T previousValue, Object element) combine) => _modelList.fold(initialValue, combine);

  Object reduce(Object Function(Object value, Object element) combine) => _modelList.reduce(combine);

  Map<int, Object> asMap() => _modelList.asMap();

  List<R> cast<R>() => _modelList.cast<R>();

  List<Object> operator +(List<Object> other) => _modelList + other;

  Iterator<Object> get iterator => _modelList.iterator;
}