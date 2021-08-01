import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Recipes/DataModel/Recipe.dart';
import 'package:grocerylister/Middleware/States/States.dart';
import 'package:grocerylister/Middleware/States/StatesHelper.dart';
import 'package:grocerylister/UI/Styling/Themes/Themes.dart';
import 'package:grocerylister/UI/Views/Components/IngredientInputDialog.dart';
import 'package:grocerylister/Utils/Loading.dart';
import 'package:grocerylister/Utils/strings.dart';

class EditRecipeView extends StatefulWidget {
  final Recipe _recipe;

  EditRecipeView(Recipe recipeToEdit) : _recipe = recipeToEdit;

  @override
  EditRecipeViewState createState() => EditRecipeViewState(_recipe);
}

class EditRecipeViewState extends State<EditRecipeView> {
  EditRecipeViewState(Recipe recipeToEdit) : _recipe = recipeToEdit;

  Recipe _recipe;
  TextEditingController _recipeNameController = TextEditingController();
  List<Map<String, String>> _ingredientRows = [];
  ScrollController _ingredientListScrollController = ScrollController();

  void _loadRecipe() {
    setState(() => _recipeNameController.text = _recipe.name);
    var recipeIngredients = recipeIngredientsState.where((ri) => ri.recipeId == _recipe.id);

    for (var ri in recipeIngredients) {
      var ingredient = ingredientsState.singleWhere((i) => i.id == ri.ingredientId, orElse: null);
      setState(
          () => _ingredientRows.add({'name': ingredient.name, 'quantity': ri.quantity.toString(), 'unit': ri.unit}));
    }
  }

  void _saveRecipeAndReturn() {
    _recipe.name = _recipeNameController.text;

    Loader.show(context: context, showWhile: StatesHelper.updateRecipe(_recipe, _ingredientRows))
        .then((_) => Navigator.pop(context));
  }

  void _openNewRecipeIngredientDialog() {
    showDialog(context: context, builder: (_) => IngredientInputDialog()).then((newIngredientData) {
      if (newIngredientData != null)
        setState(() {
          _ingredientRows.add(newIngredientData);
          _ingredientListScrollController.jumpTo(_ingredientListScrollController.position.maxScrollExtent);
        });
    });
  }

  void _deleteIngredientRow(int index) => setState(() => _ingredientRows.removeAt(index));

  bool _isFloatingActionButtonColumnVisible() => MediaQuery.of(context).viewInsets.bottom == 0 ? true : false;

  Widget _newIngredientButton() => Padding(
      padding: EdgeInsets.all(1),
      child: Align(
          alignment: Alignment.center,
          child: SizedBox(
              height: 40,
              width: 500,
              child: TextButton(
                  child: Text(Strings.new_ingredient, style: Theme.of(context).textTheme.button),
                  style: Theme.of(context).textButtonTheme.style,
                  onPressed: _openNewRecipeIngredientDialog))));

  Widget _ingredientListTile(int index) => ListTile(
      title: Text(
          "${_ingredientRows[index]['quantity']} ${_ingredientRows[index]['unit']} ${_ingredientRows[index]['name']} ",
          style: Theme.of(context).textTheme.bodyText2),
      trailing: IconButton(icon: Icon(Icons.delete, color: primary3), onPressed: () => _deleteIngredientRow(index)));

  Widget _ingredientList() => Expanded(
      child: ListView.builder(
          controller: _ingredientListScrollController,
          itemCount: _ingredientRows.length + 1,
          itemBuilder: (context, index) =>
              Card(child: index == _ingredientRows.length ? _newIngredientButton() : _ingredientListTile(index))));

  Widget _floatingActionButtonColumn() => Visibility(
      visible: _isFloatingActionButtonColumnVisible(),
      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton.extended(
            icon: Icon(Icons.mic),
            label: Text(Strings.add),
            shape: Theme.of(context).buttonTheme.shape,
            heroTag: null,
            onPressed: null),
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        FloatingActionButton.extended(
            icon: Icon(Icons.check),
            label: Text(Strings.save_recipe),
            shape: Theme.of(context).buttonTheme.shape,
            heroTag: null,
            onPressed: _saveRecipeAndReturn),
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
      ]));

  @override
  void initState() {
    _loadRecipe();
    super.initState();
  }

  @override
  build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(title: Text(Strings.new_recipe, style: Theme.of(context).textTheme.headline1)),
        body: Stack(children: [
          Container(
              margin: EdgeInsets.all(20),
              child: Column(children: <Widget>[
                Text(Strings.recipe_name, style: Theme.of(context).textTheme.headline2),
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                TextFormField(controller: _recipeNameController, style: Theme.of(context).textTheme.bodyText2),
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Text(Strings.ingredients, style: Theme.of(context).textTheme.headline2),
                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                _ingredientList()
              ])),
          Align(alignment: Alignment.bottomRight, child: _floatingActionButtonColumn())
        ]));
  }
}
