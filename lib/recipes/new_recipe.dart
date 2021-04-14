import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocerylister/storage/data_model/ingredient.dart';
import 'package:grocerylister/storage/data_model/recipe.dart';
import 'package:grocerylister/storage/data_model/recipe_ingredient.dart';
import 'package:grocerylister/storage/storage.dart';
import 'package:grocerylister/storage/units.dart';
import 'package:grocerylister/util/strings.dart';

import 'package:grocerylister/util/globals.dart' as globals;
import 'package:grocerylister/util/util.dart' as utils;
import 'package:grocerylister/util/view/ingredient_input_row.dart';

class NewRecipeWidget extends StatefulWidget {
  @override
  NewRecipeWidgetState createState() => NewRecipeWidgetState();
}

class NewRecipeWidgetState extends State<NewRecipeWidget> {
  TextEditingController _recipeNameController = TextEditingController();
  List<IngredientInputRow> _ingredientRows = [];

  List<TextEditingController> _ingredientNameControllers = [];
  List<TextEditingController> _ingredientQuantityControllers = [];
  List<String> _units = [];

  @override
  build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text(Strings.add_recipe),
        ),
        body: Column(children: <Widget>[
          Container(
            height: 100,
            margin: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Text(Strings.recipe_name),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    controller: _recipeNameController,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Text(Strings.ingredients),
          ),
          Expanded(
            child: ListView(
              children: [
                for (int i = 0; i < _ingredientRows.length; i++)
                  Card(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                      child: Row(
                          children:[Expanded(child: _ingredientRows[i]), IconButton(icon: Icon(Icons.delete), onPressed: () => setState(() => _ingredientRows.removeAt(i)))]
                      )
                  )
              ],
            ),
          ),
          Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomLeft,
                child: Builder(
                  builder: (context) => FloatingActionButton.extended(
                    label: Text(Strings.save_recipe),
                    heroTag: null,
                    onPressed: () async {
                      if (checkRecipeFields(context)) {
                        Recipe savedRecipe = await saveRecipe();
                        globals.recipeStream.sink.add(savedRecipe);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: AvatarGlow(
                      animate: globals.sttHandler.isListening,
                      glowColor: Theme.of(context).primaryColor,
                      duration: Duration(milliseconds: 1000),
                      repeatPauseDuration: Duration(milliseconds: 100),
                      endRadius: 50,
                      repeat: true,
                      child: FloatingActionButton.extended(
                          label: Icon(globals.sttHandler.isListening ? Icons.emoji_emotions_outlined : Icons.mic),
                          heroTag: null,
                          onPressed: () {
                            if (_recipeNameController.text.isEmpty)
                              globals.sttHandler.listenToSpeech(null, handleTextFromSpeech);
                            else
                              globals.sttHandler.listenToSpeech('Storbritannien', handleTextFromSpeech);
                          }))),
              Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton.extended(
                      label: Text(Strings.new_ingredient),
                      heroTag: null,
                      onPressed: () => setState(() {
                            _ingredientNameControllers.add(TextEditingController());
                            _ingredientQuantityControllers.add(TextEditingController());
                            _units.add(null);
                            _ingredientRows.add(
                                IngredientInputRow(
                                  nameController: _ingredientNameControllers.last,
                                  quantityController: _ingredientQuantityControllers.last,
                                  unitController: _units.last,
                                ));
                          }))),
            ],
          ),
        ]));
  }

  Future<Recipe> saveRecipe() async {
    int recipeID = UniqueKey().hashCode;
    String recipeName = _recipeNameController.text;
    Recipe recipe = Recipe(recipeID, recipeName);

    for (int i = 0; i < _ingredientRows.length; i++) {
      int entryID = UniqueKey().hashCode;

      int ingredientID = UniqueKey().hashCode;
      String ingredientName = _ingredientNameControllers[i].text;
      Ingredient ingredient = Ingredient(ingredientID, ingredientName);

      double quantity = double.parse(_ingredientQuantityControllers[i].text);
      String unit = _units[i] == null ? Unit.unit.unitToString() : _units[i];
      await Storage.instance.insertRecipeIngredient(RecipeIngredient(entryID, recipe, ingredient, unit, quantity));
    }
    return recipe;
  }

  bool checkRecipeFields(BuildContext context) {
    if (!utils.isInputNameFieldOk(context, _recipeNameController.text, "Recipe")) return false;

    for (int i = 0; i < _ingredientRows.length; i++) {
      if (!utils.isInputNameFieldOk(context, _ingredientNameControllers[i].text, "Ingredient") || !utils.isInputQuantityFieldOk(context, _ingredientQuantityControllers[i].text))
        return false;
    }

    return true;
  }

  Future handleTextFromSpeech(String text) async {
    if (_recipeNameController.text.isEmpty)
      _recipeNameController.text = text;
    else
      await globals.nlpServerComm.requestForIngredient(text, handleParsedIngredient);
  }

  void handleParsedIngredient(List ingredientTokens) {
    TextEditingController name = TextEditingController();
    TextEditingController quantity = TextEditingController();
    String unit = '';

    name.text = ingredientTokens[0];
    quantity.text = ingredientTokens[1];
    unit = Unit.unit.getUnitsAsStrings().contains(ingredientTokens[2]) ? ingredientTokens[2] : null;

    setState(() {
      _ingredientNameControllers.add(name);
      _ingredientQuantityControllers.add(quantity);
      _units.add(unit);
      _ingredientRows.add(
          IngredientInputRow(
            nameController: _ingredientNameControllers.last,
            quantityController: _ingredientQuantityControllers.last,
            unitController: _units.last,
          )
      );
    });
  }
}
