import 'package:grocerylister/APIs/FirebaseAPI/APIs.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Ingredients/DataModel/Ingredient.dart';
import 'package:grocerylister/APIs/FirebaseAPI/RecipeIngredients/DataModel/RecipeIngredient.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Recipes/DataModel/Recipe.dart';

import 'IngredientHelper.dart';

class RecipeHelper {
  static Future<void> saveNewRecipe(
      String recipeName, List<Map<String, String>> ingredientJsonRows, List<Ingredient> ingredients) async {
    var recipe = Recipe(name: recipeName);
    recipe.id = await recipesAPI.add(recipe);
    for (var row in ingredientJsonRows) {
      var ingredient = await IngredientHelper.getFromNameOrCreateNew(row['name'], ingredients);
      var recipeIngredient = RecipeIngredient(
        recipeId: recipe.id,
        ingredientId: ingredient.id,
        quantity: double.parse(row['quantity']),
        unit: row['unit'],
      );
      recipeIngredient.id = await recipeIngredientsAPI.add(recipeIngredient);
    }
  }

  static Future<void> removeAllRecipeIngredientsWithRecipe(
      Recipe recipe, List<RecipeIngredient> recipeIngredients) async {
    var toRemove = recipeIngredients.where((ri) => ri.recipeId == recipe.id);
    for (var ri in toRemove) await recipeIngredientsAPI.delete(ri);
  }

  static Future<void> updateRecipe(Recipe recipe, List<Map<String, String>> ingredientJsonRows,
      List<Ingredient> ingredients, List<RecipeIngredient> recipeIngredients) async {
    await removeAllRecipeIngredientsWithRecipe(recipe, recipeIngredients);

    for (var row in ingredientJsonRows) {
      var ingredient = await IngredientHelper.getFromNameOrCreateNew(row['name'], ingredients);
      var recipeIngredient = RecipeIngredient(
        recipeId: recipe.id,
        ingredientId: ingredient.id,
        quantity: double.parse(row['quantity']),
        unit: row['unit'],
      );
      recipeIngredient.id = await recipeIngredientsAPI.add(recipeIngredient);
    }

    await recipesAPI.update(recipe);
  }

  static Future<void> removeRecipe(
      Recipe recipe, List<Recipe> recipes, List<RecipeIngredient> recipeIngredients) async {
    var toRemove = recipeIngredients
        .where(
          (ri) => ri.recipeId == recipe.id,
        )
        .toList();
    for (var ri in toRemove) await recipeIngredientsAPI.delete(ri);

    await recipesAPI.delete(recipe);
  }
}
