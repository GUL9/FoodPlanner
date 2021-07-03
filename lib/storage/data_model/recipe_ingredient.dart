import 'package:grocerylister/Storage/FirebaseAPI/Recipes/DataModel/Recipe.dart';
import 'package:grocerylister/storage/data_model/ingredient.dart';

class RecipeIngredient {
  int id;
  Recipe recipe;
  Ingredient ingredient;
  String unit;
  double quantity;

  RecipeIngredient(int id, Recipe recipe, Ingredient ingredient, String unit, double quantity) {
    this.id = id;
    this.recipe = recipe;
    this.ingredient = ingredient;
    this.unit = unit;
    this.quantity = quantity;
  }

  Map<String, dynamic> toMap() {}
}
