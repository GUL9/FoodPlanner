import 'package:flutter/material.dart';
import 'Navigation/Navigation.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage>
    with TickerProviderStateMixin<HomePage> {
  int _currentDestinationIndex = 0;

  List<Widget> _navigationViews() => allDestinations
      .map<Widget>((NavigationDestination destination) =>
          NavigationView(destination: destination))
      .toList();

  SafeArea _navigationView() => SafeArea(
        top: false,
        child: IndexedStack(
          index: _currentDestinationIndex,
          children: _navigationViews(),
        ),
      );

  void _setNavigationDestination(int index) =>
      setState(() => _currentDestinationIndex = index);

  List<BottomNavigationBarItem> _navigationDestinations() => allDestinations
      .map((NavigationDestination destination) => BottomNavigationBarItem(
          icon: Icon(destination.icon),
          backgroundColor: destination.color,
          label: destination.title))
      .toList();

  BottomNavigationBar _navigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentDestinationIndex,
      onTap: _setNavigationDestination,
      items: _navigationDestinations(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _navigationView(),
      bottomNavigationBar: _navigationBar(),
    );
  }
}

void main() async {
  runApp(MaterialApp(home: HomePage(), debugShowCheckedModeBanner: false));
}
