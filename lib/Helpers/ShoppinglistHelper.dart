import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocerylister/Helpers/IngredientHelper.dart';
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
      for (var ri in recipeIngredients) {
        var ingredient = await ingredientsAPI.getFromId(ri.ingredientId) as Ingredient;
        if (!ingredient.isInStock)
          shoppinglistIngredients.add(ShoppinglistIngredient(
              shoppinglistId: shoppinglist.id,
              ingredientId: ri.ingredientId,
              quantity: ri.quantity,
              unit: ri.unit,
              isBought: false));
      }
    }

    shoppinglistIngredients = _squashShoppinglistIngredients(shoppinglistIngredients);
    for (var si in shoppinglistIngredients) si.id = await shoppinglistIngredientsAPI.add(si);

    return shoppinglist;
  }

  static Future<Shoppinglist> updateShoppinglistFromPlan(Plan plan) async {
    var shoppinglist = await shoppinglistAPI.getFromPlanId(plan.id);
    await shoppinglistIngredientsAPI.deleteAllfromShoppinglistId(shoppinglist.id);

    var shoppinglistIngredients = <ShoppinglistIngredient>[];
    for (var recipeId in plan.recipes) {
      var recipeIngredients = await recipeIngredientsAPI.getAllFromRecipeId(recipeId);
      for (var ri in recipeIngredients) {
        shoppinglistIngredients.add(ShoppinglistIngredient(
            shoppinglistId: shoppinglist.id,
            ingredientId: ri.ingredientId,
            quantity: ri.quantity,
            unit: ri.unit,
            isBought: false));
      }
    }

    shoppinglistIngredients = _squashShoppinglistIngredients(shoppinglistIngredients);
    for (var si in shoppinglistIngredients) si.id = await shoppinglistIngredientsAPI.add(si);

    shoppinglist.lastModifiedAt = Timestamp.now();
    shoppinglistAPI.update(shoppinglist);
    return shoppinglist;
  }

  static Future<void> updateShoppinglistFromNewShoppinglistIngredientData(Shoppinglist shoppinglist,
      List<ShoppinglistIngredient> shoppinglistIngredients, Map<String, String> newIngredientData) async {
    var name = newIngredientData['name'];
    var quantity = double.tryParse(newIngredientData['quantity']);
    var unit = newIngredientData['unit'];

    var ingredient = await IngredientHelper.getFromNameOrCreateNew(name);

    var shoppinglistIngredient =
        shoppinglistIngredients.firstWhere((si) => si.ingredientId == ingredient.id, orElse: () => null);

    if (shoppinglistIngredient == null) {
      shoppinglistIngredient = ShoppinglistIngredient(
          shoppinglistId: shoppinglist.id,
          ingredientId: ingredient.id,
          quantity: quantity,
          unit: unit,
          isBought: false);

      shoppinglistIngredient.id = await shoppinglistIngredientsAPI.add(shoppinglistIngredient);
    } else {
      shoppinglistIngredient.quantity += quantity;
      await shoppinglistIngredientsAPI.update(shoppinglistIngredient);
    }

    shoppinglist.lastModifiedAt = Timestamp.now();
    await shoppinglistAPI.update(shoppinglist);
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

  static List<ShoppinglistIngredient> _squashForSpecificIngredient(
      List<ShoppinglistIngredient> shoppinglistIngredients) {
    shoppinglistIngredients.sort((a, b) => a.unit.compareTo(b.unit));

    var squashedShoppinglistIngredients = <ShoppinglistIngredient>[];
    var quantity = shoppinglistIngredients[0].quantity;
    for (var i = 1; i < shoppinglistIngredients.length; i++) {
      var current = shoppinglistIngredients[i];
      var previous = shoppinglistIngredients[i - 1];

      if (current.unit == previous.unit) quantity += current.quantity;

      if (current.unit != previous.unit || i == shoppinglistIngredients.length - 1) {
        squashedShoppinglistIngredients.add(ShoppinglistIngredient(
            shoppinglistId: previous.shoppinglistId,
            ingredientId: previous.ingredientId,
            unit: previous.unit,
            isBought: false,
            quantity: quantity));
        quantity = current.quantity;
      }
    }
    return squashedShoppinglistIngredients;
  }

  static List<ShoppinglistIngredient> _squashShoppinglistIngredients(
      List<ShoppinglistIngredient> shoppinglistIngredients) {
    shoppinglistIngredients.sort((a, b) => a.ingredientId.compareTo(b.ingredientId));
    var perIngredientMap = Map<String, List<ShoppinglistIngredient>>();

    perIngredientMap[shoppinglistIngredients[0].ingredientId] = [shoppinglistIngredients[0]];
    for (var i = 1; i < shoppinglistIngredients.length; i++) {
      var previous = shoppinglistIngredients[i - 1];
      var current = shoppinglistIngredients[i];

      if (current.ingredientId == previous.ingredientId)
        perIngredientMap[current.ingredientId].add(current);
      else
        perIngredientMap[current.ingredientId] = [current];
    }

    var squashedShoppinglist = <ShoppinglistIngredient>[];
    for (var siList in perIngredientMap.values) {
      var squashedShoppinglistIngredients = siList.length == 1 ? siList : _squashForSpecificIngredient(siList);
      squashedShoppinglist.addAll(squashedShoppinglistIngredients);
    }
    return squashedShoppinglist;
  }
}
