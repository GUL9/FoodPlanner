import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocerylister/Storage/FirebaseAPI/APIs.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Ingredients/DataModel/Ingredient.dart';
import 'package:grocerylister/Storage/FirebaseAPI/RecipeIngredients/DataModel/RecipeIngredient.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Recipes/DataModel/Recipe.dart';
import 'package:grocerylister/util/strings.dart';

import 'package:grocerylister/util/view/IngredientInputRow.dart';

class NewRecipeView extends StatefulWidget {
  @override
  NewRecipeViewState createState() => NewRecipeViewState();
}

class NewRecipeViewState extends State<NewRecipeView> {
  TextEditingController _recipeNameController = TextEditingController();
  List<IngredientInputRow> _ingredientRows = [];

  void _addEmptyIngredientInputRow() => setState(() => _ingredientRows.add(IngredientInputRow()));

  void _saveRecipe() async {
    var recipe = Recipe(name: _recipeNameController.text);
    recipe.id = await recipesAPI.add(recipe);
    for (var row in _ingredientRows) {
      var ingredient = Ingredient(name: row.getName());
      ingredient.id = await ingredientsAPI.add(ingredient);
      var recipeIngredient = RecipeIngredient(
          recipeId: recipe.id,
          ingredientId: ingredient.id,
          quantity: double.parse(row.getQuantity()),
          unit: row.getUnit());
      recipeIngredient.id = await recipeIngredientsAPI.add(recipeIngredient);
    }
  }

  void _saveRecipeAndReturn() {
    _saveRecipe();
    Navigator.pop(context);
  }

  Expanded _ingredientList() => Expanded(
      child: ListView.builder(
          itemCount: _ingredientRows.length,
          itemBuilder: (context, index) => Padding(padding: EdgeInsets.only(top: 5), child: _ingredientRows[index])));

  _isFloatingActionButtonColumnVisible() => MediaQuery.of(context).viewInsets.bottom == 0 ? true : false;

  Visibility _floatingActionButtonColumn() => Visibility(
      visible: _isFloatingActionButtonColumnVisible(),
      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton.extended(
            icon: Icon(Icons.mic), label: Text(Strings.add), heroTag: null, onPressed: () => takeVoiceInput()),
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        FloatingActionButton.extended(
            icon: Icon(Icons.add), label: Text(Strings.add), heroTag: null, onPressed: _addEmptyIngredientInputRow),
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        FloatingActionButton.extended(
            icon: Icon(Icons.check), label: Text(Strings.save_recipe), heroTag: null, onPressed: _saveRecipeAndReturn),
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
      ]));

  @override
  void initState() {
    super.initState();
    _addEmptyIngredientInputRow();
  }

  @override
  build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(title: Text(Strings.new_recipe)),
        body: Stack(children: [
          Container(
              margin: EdgeInsets.all(20),
              child: Column(children: <Widget>[
                Text(Strings.recipe_name, style: TextStyle(fontSize: 20)),
                TextFormField(
                    decoration: InputDecoration(border: OutlineInputBorder()), controller: _recipeNameController),
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Text(Strings.ingredients, style: TextStyle(fontSize: 20)),
                _ingredientList()
              ])),
          Align(alignment: Alignment.bottomRight, child: _floatingActionButtonColumn())
        ]));
  }

  void takeVoiceInput() {
    // if (_recipeNameController.text.isEmpty)
    //   globals.sttHandler.listenToSpeech(null, handleTextFromSpeech);
    // else
    //   globals.sttHandler.listenToSpeech('Storbritannien', handleTextFromSpeech);
  }

  // Future handleTextFromSpeech(String text) async {
  //   if (_recipeNameController.text.isEmpty)
  //     _recipeNameController.text = text;
  //   else
  //     await globals.nlpServerComm.requestForIngredient(text, handleParsedIngredient);
  // }

  // void handleParsedIngredient(List ingredientTokens) {
  //   String name = ingredientTokens[0];
  //   String quantity = ingredientTokens[1];
  //   String unit = allUnitsAsStrings().contains(ingredientTokens[2]) ? ingredientTokens[2] : null;
  //   setState(() => _ingredientRows.add(IngredientInputRow(name: name, quantity: quantity, unit: unit)));
  // }
}
