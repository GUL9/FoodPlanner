import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocerylister/Shoppinglist/ShoppinglistView.dart';
import 'package:grocerylister/Plan/PlanView.dart';
import 'package:grocerylister/Recipes/RecipesView.dart';
import 'package:grocerylister/util/strings.dart';

class NavigationDestination {
  const NavigationDestination(this.title, this.icon, this.color);
  final String title;
  final IconData icon;
  final MaterialColor color;
}

const List<NavigationDestination> allDestinations = <NavigationDestination>[
  NavigationDestination(Strings.grocery_list, Icons.shopping_cart, Colors.yellow),
  NavigationDestination(Strings.food_planner, Icons.calendar_today, Colors.blue),
  NavigationDestination(Strings.recipe_list, Icons.list, Colors.red),
];

class NavigationView extends StatefulWidget {
  final NavigationDestination destination;
  NavigationView({Key key, this.destination}) : super(key: key);

  @override
  State createState() {
    switch (destination.title) {
      case Strings.grocery_list:
        return ShoppinglistView();
      case Strings.food_planner:
        return PlanView();
      case Strings.recipe_list:
        return RecipesView();
      default:
        return null;
    }
  }
}
