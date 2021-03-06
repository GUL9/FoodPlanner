import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocerylister/Views/Plan/PlanView.dart';
import 'package:grocerylister/Views/Recipes/RecipesView.dart';
import 'package:grocerylister/Views/Shoppinglist/ShoppinglistView.dart';
import 'package:grocerylister/Views/Stock/IngredientsInStockView.dart';
import 'package:grocerylister/util/strings.dart';

class NavigationDestination {
  const NavigationDestination(this.title, this.icon);
  final String title;
  final IconData icon;
}

const List<NavigationDestination> allDestinations = <NavigationDestination>[
  NavigationDestination(Strings.stock, Icons.food_bank),
  NavigationDestination(Strings.shoppinglist, Icons.shopping_cart),
  NavigationDestination(Strings.plan, Icons.calendar_today),
  NavigationDestination(Strings.recipe_list, Icons.list),
];

class NavigationView extends StatefulWidget {
  final NavigationDestination destination;
  NavigationView({Key key, this.destination}) : super(key: key);

  @override
  State createState() {
    switch (destination.title) {
      case Strings.stock:
        return IngredientsInStockView();
      case Strings.shoppinglist:
        return ShoppinglistView();
      case Strings.plan:
        return PlanView();
      case Strings.recipe_list:
        return RecipesView();
      default:
        return null;
    }
  }
}
