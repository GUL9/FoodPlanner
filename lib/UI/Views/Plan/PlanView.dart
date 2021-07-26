import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocerylister/Middleware/States/States.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Plans/DataModel/Plan.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Recipes/DataModel/Recipe.dart';
import 'package:grocerylister/Middleware/States/StatesHelper.dart';
import 'package:grocerylister/UI/Views/Navigation/Navigation.dart';
import 'package:grocerylister/UI/Styling/Themes/Themes.dart';
import 'package:grocerylister/UI/Views/Components/SelectRecipeDialog.dart';
import 'package:grocerylister/Utils/Loading.dart';
import 'package:grocerylister/Utils/strings.dart';
import 'package:grocerylister/Utils/InputValidator.dart';

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
    Loader.show(
        context: context,
        showWhile: StatesHelper.generateNewPlan().then((_) => StatesHelper.generateShoppinglistIngredients()));
    setState(() => _isCurrentPlanModified = false);
  }

  Future<void> _savePlanAndUpdateShoppinglist() async {
    var toUpdate = Plan(
        id: _currentPlan.id,
        createdAt: _currentPlan.createdAt,
        lastModifiedAt: Timestamp.now(),
        recipes: _currentPlanRecipes.map((r) => r.id).toList());

    Loader.show(
        context: context,
        showWhile: StatesHelper.updatePlan(toUpdate).then((_) => StatesHelper.updateShoppinglistIngredients()));
    setState(() => _isCurrentPlanModified = false);
  }

  Future<void> _loadAndListenToState() async {
    setState(() {
      _currentPlan = currentPlanState;
      _currentPlanRecipes = currentRecipesInPlanState;
    });

    planNotifierStream.stream.listen((_) => setState(() {
          _currentPlan = currentPlanState;
          _currentPlanRecipes = currentRecipesInPlanState;
        }));
  }

  @override
  void initState() {
    super.initState();
    _loadAndListenToState();
  }

  Widget _planRecipeList() => ReorderableListView.builder(
      onReorder: _swapRecipeOrder,
      itemCount: _currentPlanRecipes.length,
      itemBuilder: (context, index) => Card(
          key: ValueKey(index),
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
        backgroundColor: _isCurrentPlanModified ? affirmative : primary3,
        icon: Icon(Icons.check),
        label: Text(Strings.save_plan),
        shape: Theme.of(context).buttonTheme.shape,
        heroTag: null,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.destination.title}', style: Theme.of(context).textTheme.headline1)),
      body: Container(padding: EdgeInsets.symmetric(horizontal: 5), child: _planRecipeList()),
      floatingActionButton: _isCurrentPlanModified ? _savePlanButton() : _newPlanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
