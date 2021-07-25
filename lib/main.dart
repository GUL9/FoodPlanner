import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocerylister/Middleware/States/StatesHelper.dart';
import 'package:grocerylister/UI/Views/Navigation/Navigation.dart';
import 'package:grocerylister/UI/Styling/Themes/Themes.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> with TickerProviderStateMixin<HomePage> {
  int _currentDestinationIndex = 0;

  List<Widget> _navigationViews() => allDestinations
      .map<Widget>((NavigationDestination destination) => NavigationView(destination: destination))
      .toList();

  SafeArea _navigationView() => SafeArea(
        top: false,
        child: IndexedStack(
          index: _currentDestinationIndex,
          children: _navigationViews(),
        ),
      );

  void _setNavigationDestination(int index) => setState(() => _currentDestinationIndex = index);

  List<BottomNavigationBarItem> _navigationDestinations() => allDestinations
      .map((NavigationDestination destination) =>
          BottomNavigationBarItem(icon: Icon(destination.icon), label: destination.title))
      .toList();

  BottomNavigationBar _navigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentDestinationIndex,
      onTap: _setNavigationDestination,
      items: _navigationDestinations(),
    );
  }

  @override
  void initState() {
    super.initState();
    _setNavigationDestination(1);
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
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await StatesHelper.initStates();
  runApp(MaterialApp(theme: standardTheme, home: HomePage(), debugShowCheckedModeBanner: false));
}
