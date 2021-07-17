library scrollable_pageview;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_pageview/scrollable_list.dart';

typedef IndexedMultipleWidgetBuilder = List<Widget> Function(
    BuildContext context, int index);

class ScrollablePageView extends StatefulWidget {
  final PageController pageController;
  final Function? onPageChanged;
  final IndexedMultipleWidgetBuilder itemBuilder;
  final int? itemCount;
  ScrollablePageView({
    this.onPageChanged,
    required this.itemBuilder,
    required this.itemCount,
    required this.pageController,
  });
  @override
  _ScrollablePageViewState createState() => _ScrollablePageViewState();
}

class _ScrollablePageViewState extends State<ScrollablePageView> {
  late bool atTheTop;
  late bool atTheBottom;
  ScrollController activeScrollController = new ScrollController();
  Drag? drag;

  @override
  void initState() {
    atTheTop = true;
    atTheBottom = false;
    super.initState();
  }

  void handleDragStart(
      DragStartDetails details, ScrollController scrollController) {
    if (scrollController.hasClients) {
      if (scrollController.position.minScrollExtent ==
          scrollController.position.maxScrollExtent) {
        atTheTop = false;
        atTheBottom = false;
      } else if (scrollController.position.context.storageContext != null) {
        if (scrollController.position.pixels ==
            scrollController.position.minScrollExtent) {
          atTheTop = true;
        } else if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          atTheBottom = true;
        } else {
          atTheTop = false;
          atTheBottom = false;

          activeScrollController = scrollController;
          drag = activeScrollController.position.drag(details, disposeDrag);
          return;
        }
      }
    }

    activeScrollController = widget.pageController;
    drag = widget.pageController.position.drag(details, disposeDrag);
  }

  void handleDragUpdate(
      DragUpdateDetails details, ScrollController scrollController) {
    if (details.delta.dy > 0 && atTheTop) {
      activeScrollController = widget.pageController;
      drag?.cancel();
      drag = widget.pageController.position.drag(
          DragStartDetails(
              globalPosition: details.globalPosition,
              localPosition: details.localPosition),
          disposeDrag);
    } else if (details.delta.dy < 0 && atTheBottom) {
      activeScrollController = widget.pageController;
      drag?.cancel();
      drag = widget.pageController.position.drag(
          DragStartDetails(
            globalPosition: details.globalPosition,
            localPosition: details.localPosition,
          ),
          disposeDrag);
    } else {
      if (atTheTop || atTheBottom) {
        activeScrollController = scrollController;
        drag?.cancel();
        drag = scrollController.position.drag(
            DragStartDetails(
              globalPosition: details.globalPosition,
              localPosition: details.localPosition,
            ),
            disposeDrag);
      }
    }
    drag?.update(details);
  }

  void handleDragEnd(DragEndDetails details) {
    drag?.end(details);
    if (atTheTop) {
      atTheTop = false;
    } else if (atTheBottom) {
      atTheBottom = false;
    }
  }

  void handleDragCancel() {
    drag?.cancel();
  }

  void disposeDrag() {
    drag = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView.builder(
      clipBehavior: Clip.hardEdge,
      dragStartBehavior: DragStartBehavior.down,
      controller: widget.pageController,
      scrollDirection: Axis.vertical,
      onPageChanged: widget.onPageChanged == null
          ? null
          : (index) => widget.onPageChanged!(index),
      itemCount: widget.itemCount,
      itemBuilder: (BuildContext context, int index) => ScrollableList(
        handleDragStart: handleDragStart,
        pageController: widget.pageController,
        handleDragUpdate: handleDragUpdate,
        handleDragEnd: handleDragEnd,
        widgets: widget.itemBuilder(context, index),
        pageStorageKeyValue: index.toString(),
        key: Key(''),
      ),
    ));
  }
}
