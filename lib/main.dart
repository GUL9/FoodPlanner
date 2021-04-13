import 'package:flutter/material.dart';

import 'navigation.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin<HomePage> {
  int _currentDestinationIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _currentDestinationIndex,
          children: allDestinations.map<Widget>((NavigationDestination destination) {
            return NavigationDestinationView(destination: destination);
          }).toList(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentDestinationIndex,
        onTap: (int index) {
          setState(() {
            _currentDestinationIndex = index;
          });
        },
        items: allDestinations.map((NavigationDestination destination) {
          return BottomNavigationBarItem(
              icon: Icon(destination.icon),
              backgroundColor: destination.color,
              title: Text(destination.title)
          );
        }).toList(),
      ),
    );
  }
}

void main() async{
  runApp(MaterialApp(home: HomePage(), debugShowCheckedModeBanner: false));
}