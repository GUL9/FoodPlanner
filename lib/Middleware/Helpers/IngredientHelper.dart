import 'package:grocerylister/APIs/FirebaseAPI/APIs.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Ingredients/DataModel/Ingredient.dart';
import 'package:grocerylister/APIs/FirebaseAPI/ShoppinglistIngredients/DataModel/ShoppinglistIngredient.dart';

class IngredientHelper {
  static Future<Ingredient> getFromNameOrCreateNew(String name, List<Ingredient> ingredients) async {
    var ingredient = ingredients.singleWhere((i) => i.name == name, orElse: () => null);
    if (ingredient == null) {
      ingredient = Ingredient(name: name, isInStock: false);
      ingredient.id = await ingredientsAPI.add(ingredient);
    }
    return ingredient;
  }

  static Future<void> updateIngredients(List<Ingredient> ingredients) async {
    for (var i in ingredients) await ingredientsAPI.update(i);
  }

  static Future<List<Ingredient>> ingredientsFromRecipeIngredients(
      List<ShoppinglistIngredient> shoppinglistIngredients, List<Ingredient> ingredients) async {
    List<Ingredient> ingredients = [];
    for (var shoppinglistIngredient in shoppinglistIngredients) {
      var ingredient = ingredients.singleWhere((i) => i.id == shoppinglistIngredient.ingredientId);
      ingredients.add(ingredient);
    }
    return ingredients;
  }
}
