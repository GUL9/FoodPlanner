import 'package:grocerylister/APIs/FirebaseAPI/APIs.dart';
import 'package:grocerylister/APIs/FirebaseAPI/RecipeIngredients/DataModel/RecipeIngredient.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Recipes/DataModel/Recipe.dart';

import 'IngredientHelper.dart';

class RecipeHelper {
  static Future<void> saveRecipe(String recipeName, List<Map<String, String>> ingredientRows) async {
    var recipe = Recipe(name: recipeName);
    recipe.id = await recipesAPI.add(recipe);
    for (var row in ingredientRows) {
      var ingredient = await IngredientHelper.getFromNameOrCreateNew(row['name'], await ingredientsAPI.getAll());
      var recipeIngredient = RecipeIngredient(
        recipeId: recipe.id,
        ingredientId: ingredient.id,
        quantity: double.parse(row['quantity']),
        unit: row['unit'],
      );
      recipeIngredient.id = await recipeIngredientsAPI.add(recipeIngredient);
    }
  }
}
