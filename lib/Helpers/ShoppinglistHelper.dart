import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocerylister/Storage/FirebaseAPI/APIs.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Ingredients/DataModel/Ingredient.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Plans/DataModel/Plan.dart';
import 'package:grocerylister/Storage/FirebaseAPI/ShoppinglistIngredients/DataModel/ShoppinglistIngredient.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Shoppinglists/DataModel/Shoppinglist.dart';

class ShoppinglistHelper {
  static Future<Shoppinglist> generateNewShoppinglistFromPlan(Plan plan) async {
    var now = Timestamp.now();
    var shoppinglist = Shoppinglist(planId: plan.id, createdAt: now, lastModifiedAt: now);
    shoppinglist.id = await shoppinglistAPI.add(shoppinglist);

    var shoppinglistIngredients = <ShoppinglistIngredient>[];
    for (var recipeId in plan.recipes) {
      var recipeIngredients = await recipeIngredientsAPI.getAllFromRecipeId(recipeId);
      for (var recipeIngredient in recipeIngredients) {
        shoppinglistIngredients.add(ShoppinglistIngredient(
            shoppinglistId: shoppinglist.id,
            ingredientId: recipeIngredient.ingredientId,
            quantity: recipeIngredient.quantity,
            unit: recipeIngredient.unit,
            isBought: false));
      }
    }

    shoppinglistIngredients = squashIngredientsInShoppinglist(shoppinglistIngredients);
    for (var shoppinglistIngredient in shoppinglistIngredients)
      shoppinglistIngredient.id = await shoppinglistIngredientsAPI.add(shoppinglistIngredient);

    return shoppinglist;
  }

  static List<ShoppinglistIngredient> squashSpecificIngredient(
      List<ShoppinglistIngredient> shoppinglistWithSameIngredient) {
    shoppinglistWithSameIngredient.sort((a, b) => a.unit.compareTo(b.unit));

    var squashedShoppinglist = <ShoppinglistIngredient>[];
    var quantity = shoppinglistWithSameIngredient[0].quantity;
    for (var i = 1; i < shoppinglistWithSameIngredient.length; i++) {
      if (shoppinglistWithSameIngredient[i].unit == shoppinglistWithSameIngredient[i - 1].unit)
        quantity += shoppinglistWithSameIngredient[i].quantity;
      if (shoppinglistWithSameIngredient[i].unit != shoppinglistWithSameIngredient[i - 1].unit ||
          i == shoppinglistWithSameIngredient.length - 1) {
        squashedShoppinglist.add(ShoppinglistIngredient(
            shoppinglistId: shoppinglistWithSameIngredient[i - 1].shoppinglistId,
            ingredientId: shoppinglistWithSameIngredient[i - 1].ingredientId,
            unit: shoppinglistWithSameIngredient[i - 1].unit,
            isBought: false,
            quantity: quantity));
        quantity = shoppinglistWithSameIngredient[i].quantity;
      }
    }
    return squashedShoppinglist;
  }

  static List<ShoppinglistIngredient> squashIngredientsInShoppinglist(List<ShoppinglistIngredient> shoppinglist) {
    shoppinglist.sort((a, b) => a.ingredientId.compareTo(b.ingredientId));
    var shoppinglistPerIngredient = Map<String, List<ShoppinglistIngredient>>();

    shoppinglistPerIngredient[shoppinglist[0].ingredientId] = [shoppinglist[0]];
    for (var i = 1; i < shoppinglist.length; i++) {
      if (shoppinglist[i].ingredientId == shoppinglist[i - 1].ingredientId)
        shoppinglistPerIngredient[shoppinglist[i].ingredientId].add(shoppinglist[i]);
      else
        shoppinglistPerIngredient[shoppinglist[i].ingredientId] = [shoppinglist[i]];
    }

    var squashedShoppinglist = <ShoppinglistIngredient>[];
    for (var shoppinglistIngredient in shoppinglistPerIngredient.values) {
      var squashedShoppinglistIngredients = squashSpecificIngredient(shoppinglistIngredient);
      squashedShoppinglist.addAll(squashedShoppinglistIngredients);
    }

    return squashedShoppinglist;
  }

  static Future<List<Ingredient>> getIngredientsFromShoppinglistIngredients(
      List<ShoppinglistIngredient> shoppinglistIngredients) async {
    List<Ingredient> ingredients = [];
    for (var shoppinglistIngredient in shoppinglistIngredients) {
      var ingredient = await ingredientsAPI.getFromId(shoppinglistIngredient.ingredientId);
      ingredients.add(ingredient);
    }
    return ingredients;
  }
}
