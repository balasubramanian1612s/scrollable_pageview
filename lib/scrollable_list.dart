import 'package:flutter/material.dart';

typedef ValuesChanged<T, E> = void Function(T value, E valueTwo);

class ScrollableList extends StatefulWidget {
  final ValuesChanged<DragStartDetails, ScrollController> handleDragStart;
  final ValuesChanged<DragUpdateDetails, ScrollController> handleDragUpdate;
  final ValueChanged<DragEndDetails> handleDragEnd;
  final String pageStorageKeyValue;
  final PageController pageController;
  final List<Widget> widgets;
  ScrollableList({
    required Key key,
    required this.handleDragStart,
    required this.widgets,
    required this.pageController,
    required this.handleDragUpdate,
    required this.handleDragEnd,
    required this.pageStorageKeyValue,
  });
  @override
  _ScrollableListState createState() => _ScrollableListState();
}

class _ScrollableListState extends State<ScrollableList> {
  ScrollController scrollController = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (details) {
        widget.handleDragStart(details, scrollController);
      },
      onVerticalDragUpdate: (details) {
        widget.handleDragUpdate(details, scrollController);
      },
      onVerticalDragEnd: widget.handleDragEnd,
      child: ListView(
          key: PageStorageKey<String>(widget.pageStorageKeyValue),
          physics: const NeverScrollableScrollPhysics(),
          controller: scrollController,
          children: widget.widgets),
    );
  }
}


