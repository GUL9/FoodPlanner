import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocerylister/groceries/shoppinglist.dart';
import 'package:grocerylister/planner/planner.dart';
import 'package:grocerylister/recipes/recipes.dart';
import 'package:grocerylister/util/strings.dart';

class NavigationDestination{
  const NavigationDestination(this.title,this.icon,this.color);
  final String title;
  final IconData icon;
  final MaterialColor color;
}

const List<NavigationDestination> allDestinations = <NavigationDestination>[
  NavigationDestination(Strings.grocery_list, Icons.shopping_cart, Colors.yellow),
  NavigationDestination(Strings.food_planner, Icons.calendar_today, Colors.blue),
  NavigationDestination(Strings.recipe_list, Icons.list, Colors.red),
];

class NavigationDestinationView extends StatefulWidget{
  final NavigationDestination destination;
  Map<String, StreamController> streams = {
    Strings.food_plan_updated: new StreamController.broadcast()
  };
  NavigationDestinationView({Key key, this.destination}) : super(key:key);


  @override
  State createState(){
    if(destination.title == Strings.grocery_list)
      return GroceriesDestinationState();
    if(destination.title == Strings.food_planner)
      return PlannerDestinationState();
    if(destination.title == Strings.recipe_list)
      return RecipesDestinationState();


  }
}