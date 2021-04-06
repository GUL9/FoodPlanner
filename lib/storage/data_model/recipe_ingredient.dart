

import 'package:grocerylister/storage/data_model/ingredient.dart';
import 'package:grocerylister/storage/data_model/recipe.dart';

class RecipeIngredient {
  int id;
  Recipe recipe;
  Ingredient ingredient;
  String unit;
  double quantity;

  RecipeIngredient(int id, Recipe recipe, Ingredient ingredient, String unit, double quantity){
    this.id = id;
    this.recipe = recipe;
    this.ingredient = ingredient;
    this.unit = unit;
    this.quantity = quantity;
  }

  Map<String, dynamic> toMap (){
    return {
      'id' : id,
      'recipeID' : recipe.id,
      'ingredientID' : ingredient.id,
      'unit' : unit,
      'quantity' : quantity
    };
  }
}