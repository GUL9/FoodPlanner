import 'dart:io';

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
import 'package:speech_to_text/speech_to_text.dart' as stt;

class NewRecipeWidget extends StatefulWidget {
  @override
  NewRecipeWidgetState createState() => NewRecipeWidgetState();
}

class NewRecipeWidgetState extends State<NewRecipeWidget> {
  stt.SpeechToText speechToText = stt.SpeechToText();
  bool isListening = false;
  String speechInput = "";
  double confidence;

  List recipeIngredients = [];
  TextEditingController recipeNameController = TextEditingController();
  List<TextEditingController> ingredientNameControllers = [];
  List<TextEditingController> ingredientQuantityControllers = [];
  List<String> units = [];

  Future<Recipe> saveRecipe() async {
    int entryID = UniqueKey().hashCode;
    int recipeID = UniqueKey().hashCode;
    String recipeName = recipeNameController.text;
    Recipe recipe = Recipe(recipeID, recipeName);

    for (int i = 0; i < recipeIngredients.length; i++) {
      int ingredientID = UniqueKey().hashCode;
      String ingredientName = ingredientNameControllers[i].text;
      Ingredient ingredient = Ingredient(ingredientID, ingredientName);

      String unit = units[i] == null ? Unit.unit.unitToString() : units[i];
      double quantity = double.parse(ingredientQuantityControllers[i].text);
      await Storage.instance.insertRecipeIngredient(RecipeIngredient(entryID, recipe, ingredient, unit, quantity));
    }
    return recipe;
  }

  bool checkRecipeFields(BuildContext context) {
    if (!utils.isInputNameFieldOk(context, recipeNameController.text, "Recipe")) return false;

    for (int i = 0; i < recipeIngredients.length; i++) {
      if (!utils.isInputNameFieldOk(context, ingredientNameControllers[i].text, "Ingredient") || !utils.isInputQuantityFieldOk(context, ingredientQuantityControllers[i].text))
        return false;
    }

    return true;
  }

  Card listCard(int index) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
        child: Row(children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: ingredientNameControllers[index],
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: Strings.ingredient_name),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
          ),
          Expanded(
            child: TextFormField(
              controller: ingredientQuantityControllers[index],
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: Strings.ingredient_quantity),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
          ),
          Expanded(
            child: DropdownButtonFormField(
              decoration: const InputDecoration.collapsed(),
              hint: Text(Strings.unit),
              value: units[index] == null ? Strings.unit.toLowerCase() : units[index],
              onChanged: (newValue) {
                setState(() {
                  units[index] = newValue;
                });
              },
              items: Unit.values.map((unit) {
                return DropdownMenuItem(
                  value: unit.unitToString(),
                  child: Text(unit.unitToString()),
                );
              }).toList(),
            ),
          ),
          Container(
              child: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => setState(
              () {
                recipeIngredients.removeAt(index);
                ingredientNameControllers.removeAt(index);
                ingredientQuantityControllers.removeAt(index);
                units.removeAt(index);
              },
            ),
          )),
        ]));
  }

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
                    controller: recipeNameController,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Text(Strings.ingredients),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: recipeIngredients.length,
              itemBuilder: (context, index) {
                return listCard(index);
              },
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
                      animate: isListening,
                      glowColor: Theme.of(context).primaryColor,
                      duration: Duration(milliseconds: 1000),
                      repeatPauseDuration: Duration(milliseconds: 100),
                      endRadius: 50,
                      repeat: true,
                      child: FloatingActionButton.extended(
                          label: Icon(isListening ? Icons.emoji_emotions_outlined : Icons.mic),
                          heroTag: null,
                          onPressed: () async {
                            listenToSpeech();
                          }))),
              Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton.extended(
                      label: Text(Strings.new_ingredient),
                      heroTag: null,
                      onPressed: () => setState(() {
                            ingredientNameControllers.add(TextEditingController());
                            ingredientQuantityControllers.add(TextEditingController());
                            units.add(null);
                            recipeIngredients.add(RecipeIngredient(null, null, null, null, null));
                          }))),
            ],
          ),
        ]));
  }

  void listenToSpeech() async {
    if (!isListening) {
      bool available = await speechToText.initialize(
        onStatus: (status) => print(status),
        onError: (error) => print(error),
      );
      if (available) {
        setState(() => isListening = true);
        speechToText.listen(
          cancelOnError: true,
          onResult: (input) => setState(() {
            speechInput = input.recognizedWords;
            isListening = false;
          }),
        );
      }
    }else{
      speechToText.stop();
      setState(() => isListening = false);
    }
  }
}
