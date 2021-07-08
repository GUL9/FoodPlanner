import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocerylister/Navigation/Navigation.dart';
import 'package:grocerylister/Storage/FirebaseAPI/APIs.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Plans/DataModel/Plan.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Plans/PlansAPI.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Recipes/DataModel/Recipe.dart';
import 'package:grocerylister/util/strings.dart';
import 'package:grocerylister/util/util.dart';

class PlanView extends State<NavigationView> {
  Plan _plan;
  List<Recipe> _recipes = [];

  @override
  void initState() {
    super.initState();
  }

  void _changerecipeOrder(int a, int b) => setState(() {
        Recipe tmpA = _recipes[a];
        Recipe tmpB = _recipes[b];
        _recipes.removeAt(a);
        _recipes.insert(a, tmpB);
        _recipes.removeAt(b);
        _recipes.insert(b, tmpA);
      });

  void _generatePlan() {}

  Future<void> _fetchMostRecentPlan() async {
    Plan plan = await plansAPI.getMostRecentlyCreatedPlan();
    List<Recipe> recipes = [];
    for (DocumentReference reference in plan.recipes) {
      Recipe recipe = await recipesAPI.getFromReference(reference);
      recipes.add(recipe);
    }
    setState(() {
      _plan = plan;
      _recipes = recipes;
    });
  }

  StreamBuilder _planFromStream() => StreamBuilder(
      stream: plansAPI.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) _fetchMostRecentPlan();
        return snapshot.hasData
            ? ReorderableListView.builder(
                onReorder: _changerecipeOrder,
                itemCount: _recipes.length,
                itemBuilder: (context, index) => Card(
                    key: ValueKey(_recipes[index]),
                    child: ListTile(
                        leading:
                            Text(indexToDayString(index), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        title: Text(_recipes[index].name))))
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
