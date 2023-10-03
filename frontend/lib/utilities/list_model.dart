
import 'package:flutter/material.dart';

typedef RemovedItemBuilder<T> = Widget Function(
    T item, BuildContext context, Animation<double> animation);

class ListModel<E> {
  final GlobalKey<AnimatedListState> listKey;
  final RemovedItemBuilder<E>? removedItemBuilder;
  final List<E> _items;

  AnimatedListState? get _animatedList => listKey.currentState;

  ListModel({
    required this.listKey,
    this.removedItemBuilder,
    Iterable<E>? initialItems,
  }) : _items = List<E>.from(initialItems ?? <E>[]);

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList!.insertItem(index);
  }

  void add(E item) {
    int index = _items.length;
    _items.insert(index, item);
    _animatedList!.insertItem(index);
  }

  void removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList!.removeItem(
        index, (context, animation) =>
          removedItemBuilder!(removedItem, context, animation)
      );
    }
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}