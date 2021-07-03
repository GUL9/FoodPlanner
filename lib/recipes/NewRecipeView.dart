import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Recipes/DataModel/Recipe.dart';
import 'package:grocerylister/storage/units.dart';
import 'package:grocerylister/util/strings.dart';

import 'package:grocerylister/util/globals.dart' as globals;
import 'package:grocerylister/util/util.dart' as utils;
import 'package:grocerylister/util/view/ingredient_input_row.dart';

class NewRecipeView extends StatefulWidget {
  @override
  NewRecipeViewState createState() => NewRecipeViewState();
}

class NewRecipeViewState extends State<NewRecipeView> {
  TextEditingController _recipeNameController = TextEditingController();
  List<IngredientInputRow> _ingredientRows = [];

  List<TextEditingController> _ingredientNameControllers = [];
  List<TextEditingController> _ingredientQuantityControllers = [];
  List<String> _units = [];

  Column _floatingActionButtonColumn() => Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        AvatarGlow(
            animate: globals.sttHandler.isListening,
            glowColor: Theme.of(context).primaryColor,
            duration: Duration(milliseconds: 1000),
            repeatPauseDuration: Duration(milliseconds: 100),
            endRadius: 50,
            repeat: true,
            child: FloatingActionButton.extended(
                icon: Icon(globals.sttHandler.isListening ? Icons.emoji_emotions_outlined : Icons.mic),
                label: Text(Strings.add),
                heroTag: null,
                onPressed: () => takeVoiceInput())),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: FloatingActionButton.extended(
                icon: Icon(Icons.add),
                label: Text(Strings.add),
                heroTag: null,
                onPressed: () => addEmptyIngredientInputRow())),
        Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: FloatingActionButton.extended(
                icon: Icon(Icons.check),
                label: Text(Strings.save_recipe),
                heroTag: null,
                onPressed: () => saveRecipesAndReturn(context)))
      ]);

  @override
  build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text(
            Strings.add_recipe,
          ),
        ),
        body: Stack(children: [
          Container(
              margin: EdgeInsets.all(20),
              child: Column(children: <Widget>[
                Text(Strings.recipe_name, style: TextStyle(fontSize: 20)),
                TextFormField(
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  controller: _recipeNameController,
                ),
                Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(Strings.ingredients, style: TextStyle(fontSize: 20))),
                Expanded(
                    child: ListView.builder(
                        itemCount: _ingredientRows.length,
                        itemBuilder: (context, index) =>
                            Padding(padding: EdgeInsets.only(top: 5), child: IngredientInputRow()))),
              ])),
          Align(alignment: Alignment.bottomRight, child: _floatingActionButtonColumn())
        ]));
  }

  void addEmptyIngredientInputRow() {
    setState(() {
      _ingredientNameControllers.add(TextEditingController());
      _ingredientQuantityControllers.add(TextEditingController());
      _units.add(null);
      _ingredientRows.add(IngredientInputRow(
        nameController: _ingredientNameControllers.last,
        quantityController: _ingredientQuantityControllers.last,
        unitController: _units.last,
      ));
    });
  }

  void saveRecipesAndReturn(BuildContext context) async {}

  Future<Recipe> saveRecipe() async {}

  bool checkRecipeFields(BuildContext context) {
    if (!utils.isInputNameFieldOk(context, _recipeNameController.text, "Recipe")) return false;

    for (int i = 0; i < _ingredientRows.length; i++) {
      if (!utils.isInputNameFieldOk(context, _ingredientNameControllers[i].text, "Ingredient") ||
          !utils.isInputQuantityFieldOk(context, _ingredientQuantityControllers[i].text)) return false;
    }

    return true;
  }

  void takeVoiceInput() {
    if (_recipeNameController.text.isEmpty)
      globals.sttHandler.listenToSpeech(null, handleTextFromSpeech);
    else
      globals.sttHandler.listenToSpeech('Storbritannien', handleTextFromSpeech);
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
      _ingredientRows.add(IngredientInputRow(
        nameController: _ingredientNameControllers.last,
        quantityController: _ingredientQuantityControllers.last,
        unitController: _units.last,
      ));
    });
  }
}
