import 'package:flutter/material.dart';
import 'package:grocerylister/Navigation/Navigation.dart';
import 'package:grocerylister/Storage/FirebaseAPI/APIs.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Plans/DataModel/Plan.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Plans/PlansAPI.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Recipes/DataModel/Recipe.dart';
import 'package:grocerylister/util/strings.dart';

class PlanView extends State<NavigationView> {
  Plan _currentPlan;
  List<Recipe> _recipes;

  @override
  void initState() {
    super.initState();
  }

  void _changerecipeOrder(int a, int b) {}

  void _generatePlan() {}

  StreamBuilder _planFromStream() => StreamBuilder(
      stream: plansAPI.stream,
      builder: (context, snapshot) {
        //var a = getPlansFromSnapshot(snapshot);
        //_currentPlan = getLatestPlan();
        return snapshot.hasData
            ? ReorderableListView.builder(
                onReorder: _changerecipeOrder,
                itemCount: _currentPlan.recipes.length,
                itemBuilder: (context, index) => Card(child: ListTile(leading: Text('apa'), title: Text('papa'))))
            : Text(Strings.loading);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.destination.title}'), backgroundColor: widget.destination.color),
      backgroundColor: widget.destination.color[100],
      body: Container(padding: const EdgeInsets.all(20), child: _planFromStream()),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: _generatePlan,
          label: Text(Strings.generate_food_plan),
          icon: Icon(Icons.insert_emoticon),
          heroTag: null),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
