import 'package:flutter/material.dart';

typedef ValuesChanged<T, E> = void Function(T value, E valueTwo);

///Main Widget Which manages eveything
class ScrollableList extends StatefulWidget {
  ///To detect drag start

  final ValuesChanged<DragStartDetails, ScrollController> handleDragStart;

  ///To detect drag update

  final ValuesChanged<DragUpdateDetails, ScrollController> handleDragUpdate;

  ///To detect drag end
  final ValueChanged<DragEndDetails> handleDragEnd;

  ///Used for storing a page (not to reload)
  final String pageStorageKeyValue;

  ///Main Page controller
  final PageController pageController;

  ///List of widgets for single index
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
        ///Calling Function handleDragStart
        widget.handleDragStart(details, scrollController);
      },
      onVerticalDragUpdate: (details) {
        ///Calling Function handleDragUpdate
        widget.handleDragUpdate(details, scrollController);
      },
      onVerticalDragEnd: (details) {
        ///Calling Function onVerticalDragEnd
        widget.handleDragEnd(details);
      },
      child: ListView(
          key: PageStorageKey<String>(widget.pageStorageKeyValue),
          physics: const NeverScrollableScrollPhysics(),
          controller: scrollController,
          children: widget.widgets),
    );
  }
}
