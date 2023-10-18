
import 'package:flutter/material.dart';

typedef RemovedItemBuilder<T> = Widget Function(
    T item, BuildContext context, Animation<double> animation);

class ListModel<E> {
  final GlobalKey<AnimatedListState> listKey;
  final RemovedItemBuilder<E>? removedItemBuilder;
  List<E> items;

  AnimatedListState? get _animatedList => listKey.currentState;

  ListModel({
    required this.listKey,
    this.removedItemBuilder,
    this.items = const [],
  });

  void setItems(List<E> newItems) {
    items = newItems;
  }

  void insert(int index, E item) {
    items.insert(index, item);
    _animatedList!.insertItem(index);
  }

  void add(E item) {
    int index = items.length;
    items.insert(index, item);
    _animatedList!.insertItem(index);
  }

  void removeAt(int index) {
    final E removedItem = items.removeAt(index);
    if (removedItem != null) {
      _animatedList!.removeItem(
        index, (context, animation) =>
          removedItemBuilder!(removedItem, context, animation)
      );
    }
  }

  int get length => items.length;

  E operator [](int index) => items[index];

  int indexOf(E item) => items.indexOf(item);
}