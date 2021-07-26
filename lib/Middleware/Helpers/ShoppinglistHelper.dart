import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocerylister/APIs/FirebaseAPI/RecipeIngredients/DataModel/RecipeIngredient.dart';
import 'package:grocerylister/Middleware/Helpers/IngredientHelper.dart';
import 'package:grocerylister/APIs/FirebaseAPI/APIs.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Ingredients/DataModel/Ingredient.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Plans/DataModel/Plan.dart';
import 'package:grocerylister/APIs/FirebaseAPI/ShoppinglistIngredients/DataModel/ShoppinglistIngredient.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Shoppinglists/DataModel/Shoppinglist.dart';

class ShoppinglistHelper {
  static Future<Shoppinglist> generateNewShoppinglist(
      Plan plan, List<RecipeIngredient> allRecipeIngredients, List<Ingredient> allIngredients) async {
    var now = Timestamp.now();
    var shoppinglist = Shoppinglist(planId: plan.id, createdAt: now, lastModifiedAt: now, allIngredientsBought: false);
    shoppinglist.id = await shoppinglistsAPI.add(shoppinglist);

    var shoppinglistIngredients = <ShoppinglistIngredient>[];
    for (var recipeId in plan.recipes) {
      var recipeIngredients = allRecipeIngredients.where((ri) => ri.recipeId == recipeId).toList();
      for (var ri in recipeIngredients) {
        var ingredient = allIngredients.singleWhere((i) => i.id == ri.ingredientId);
        if (!ingredient.isInStock)
          shoppinglistIngredients.add(ShoppinglistIngredient(
              shoppinglistId: shoppinglist.id,
              ingredientId: ri.ingredientId,
              quantity: ri.quantity,
              unit: ri.unit,
              isBought: false,
              isExtra: false));
      }
    }
    if (shoppinglistIngredients.isNotEmpty)
      shoppinglistIngredients = _squashShoppinglistIngredients(shoppinglistIngredients);
    for (var si in shoppinglistIngredients) si.id = await shoppinglistIngredientsAPI.add(si);

    return shoppinglist;
  }

  static Future<Shoppinglist> updateShoppinglist(Shoppinglist currentShoppinglist, Plan currentPlan,
      List<Ingredient> currentIngredients, List<RecipeIngredient> currentRecipeIngredients) async {
    await shoppinglistIngredientsAPI.deleteAllNotExtrafromShoppinglistId(currentShoppinglist.id);

    var shoppinglistIngredients = <ShoppinglistIngredient>[];
    for (var recipeId in currentPlan.recipes) {
      var recipeIngredients = currentRecipeIngredients.where((ri) => ri.recipeId == recipeId).toList();
      for (var ri in recipeIngredients) {
        var ingredient = currentIngredients.singleWhere((i) => i.id == ri.ingredientId);
        if (!ingredient.isInStock)
          shoppinglistIngredients.add(ShoppinglistIngredient(
              shoppinglistId: currentShoppinglist.id,
              ingredientId: ri.ingredientId,
              quantity: ri.quantity,
              unit: ri.unit,
              isBought: false,
              isExtra: false));
      }
    }
    if (shoppinglistIngredients.isNotEmpty)
      shoppinglistIngredients = _squashShoppinglistIngredients(shoppinglistIngredients);
    for (var si in shoppinglistIngredients) await shoppinglistIngredientsAPI.add(si);

    currentShoppinglist.lastModifiedAt = Timestamp.now();
    await shoppinglistsAPI.update(currentShoppinglist);

    return currentShoppinglist;
  }

  static Future<void> updateShoppinglistFromJsonIngredientData(Shoppinglist shoppinglist, List<Ingredient> ingredients,
      List<ShoppinglistIngredient> shoppinglistIngredients, Map<String, String> newIngredientData) async {
    var name = newIngredientData['name'];
    var quantity = double.tryParse(newIngredientData['quantity']);
    var unit = newIngredientData['unit'];

    var ingredient = await IngredientHelper.getFromNameOrCreateNew(name, ingredients);

    var shoppinglistIngredient =
        shoppinglistIngredients.singleWhere((si) => si.ingredientId == ingredient.id, orElse: () => null);

    if (shoppinglistIngredient == null) {
      shoppinglistIngredient = ShoppinglistIngredient(
          shoppinglistId: shoppinglist.id,
          ingredientId: ingredient.id,
          quantity: quantity,
          unit: unit,
          isBought: false,
          isExtra: true);

      shoppinglistIngredient.id = await shoppinglistIngredientsAPI.add(shoppinglistIngredient);
    } else {
      shoppinglistIngredient.quantity += quantity;
      await shoppinglistIngredientsAPI.update(shoppinglistIngredient);
    }

    shoppinglist.lastModifiedAt = Timestamp.now();
    await shoppinglistsAPI.update(shoppinglist);
  }

  static bool isAllIngredientsChecked(List<ShoppinglistIngredient> shoppinglistIngredients) {
    for (var si in shoppinglistIngredients) if (!si.isBought) return false;

    return true;
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
            quantity: quantity,
            isBought: false,
            isExtra: false));
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
