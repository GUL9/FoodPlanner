import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocerylister/DataNotifierStreams/DataNotifierStreams.dart';
import 'package:grocerylister/Helpers/ShoppinglistHelper.dart';
import 'package:grocerylister/Navigation/Navigation.dart';
import 'package:grocerylister/Helpers/PlanHelper.dart';
import 'package:grocerylister/Storage/FirebaseAPI/APIs.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Plans/DataModel/Plan.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Recipes/DataModel/Recipe.dart';
import 'package:grocerylister/Styling/Themes/Themes.dart';
import 'package:grocerylister/Views/Components/SelectRecipeDialog.dart';
import 'package:grocerylister/util/strings.dart';
import 'package:grocerylister/util/InputValidator.dart';

class PlanView extends State<NavigationView> {
  bool _isCurrentPlanModified = false;
  Plan _currentPlan;
  List<Recipe> _currentPlanRecipes = [];

  void _swapRecipeOrder(int oldIndex, int newIndex) => setState(() {
        _isCurrentPlanModified = true;

        if (oldIndex < newIndex) newIndex -= 1;
        var recipe = _currentPlanRecipes.removeAt(oldIndex);
        _currentPlanRecipes.insert(newIndex, recipe);
      });

  void _openSelectRecipeDialog(int indexToChange) {
    showDialog(context: context, builder: (_) => SelectRecipeDialog(oldRecipe: _currentPlanRecipes[indexToChange]))
        .then((newRecipe) {
      if (newRecipe != null)
        setState(() {
          _currentPlanRecipes[indexToChange] = newRecipe;
          _isCurrentPlanModified = true;
        });
    });
  }

  Future<void> _generateNewPlanAndShoppinglist() async {
    var newPlan = await PlanHelper.generateNewPlan();
    var newRecipes = await PlanHelper.getRecipesFromPlan(newPlan);
    var newShoppinglist = await ShoppinglistHelper.generateNewShoppinglistFromPlan(newPlan);
    shoppinglistNotifierStream.sink.add(newShoppinglist);
    setState(() {
      _currentPlan = newPlan;
      _currentPlanRecipes = newRecipes;
      _isCurrentPlanModified = false;
    });
  }

  Future<void> _savePlanAndUpdateShoppinglist() async {
    setState(() {
      _currentPlan.recipes = _currentPlanRecipes.map((r) => r.id).toList();
      _currentPlan.lastModifiedAt = Timestamp.now();
      _isCurrentPlanModified = false;
    });
    await plansAPI.update(_currentPlan);
    // TODO: update shoppinglist in db
  }

  Future<void> _loadMostRecentPlan() async {
    Plan mostRecentPlan = await plansAPI.getMostRecentlyCreatedPlan();
    List<Recipe> recipesInMostRecentPlan = await PlanHelper.getRecipesFromPlan(mostRecentPlan);
    setState(() {
      _currentPlan = mostRecentPlan;
      _currentPlanRecipes = recipesInMostRecentPlan;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMostRecentPlan();
  }

  Widget _planRecipeList() => ReorderableListView.builder(
      onReorder: _swapRecipeOrder,
      itemCount: _currentPlanRecipes.length,
      itemBuilder: (context, index) => Card(
          key: ValueKey(_currentPlanRecipes[index]),
          child: ListTile(
              leading: Container(
                  width: 65, child: Text(indexToDayString(index), style: Theme.of(context).textTheme.bodyText1)),
              title: Text(
                _currentPlanRecipes[index].name,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              trailing: IconButton(
                icon: Icon(Icons.swap_horiz, color: primary3),
                onPressed: () => _openSelectRecipeDialog(index),
              ))));

  Widget _newPlanButton() => FloatingActionButton.extended(
        onPressed: _generateNewPlanAndShoppinglist,
        icon: Icon(Icons.add),
        label: Text(Strings.new_plan),
        shape: Theme.of(context).buttonTheme.shape,
        heroTag: null,
      );

  Widget _savePlanButton() => FloatingActionButton.extended(
        onPressed: _savePlanAndUpdateShoppinglist,
        backgroundColor: _isCurrentPlanModified ? secondary2 : primary3,
        icon: Icon(Icons.check),
        label: Text(Strings.save_plan),
        shape: Theme.of(context).buttonTheme.shape,
        heroTag: null,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.destination.title}', style: Theme.of(context).textTheme.headline1)),
      body: Container(padding: const EdgeInsets.all(20), child: _planRecipeList()),
      floatingActionButton: _isCurrentPlanModified ? _savePlanButton() : _newPlanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
