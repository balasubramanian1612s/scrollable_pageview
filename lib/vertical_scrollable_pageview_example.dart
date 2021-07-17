import 'package:flutter/material.dart';
import 'package:vertical_scrollable_pageview/vertical_scrollable_pageview.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  final PageController pageController = new PageController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Material(
      child: VerticalScrollablePageview(
        itemBuilder: (context, index) {
          return [
            for (int i = 0; i < 9; i++)
              Container(
                height: 100,
                color: Colors.red[(i + 1) * 100],
                child: Center(
                  child: Text('$i'),
                ),
              ),
            for (int i = 0; i < 9; i++)
              Container(
                height: 100,
                color: Colors.green[(i + 1) * 100],
                child: Center(
                  child: Text('$i'),
                ),
              )
          ];
        },
        itemCount: 10,
        pageController: pageController,
        onPageChanged: (v) {
          print("PAGE CHANGED");
        },
      ),
    ));
  }
}
