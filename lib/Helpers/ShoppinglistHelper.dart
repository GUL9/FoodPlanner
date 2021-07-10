import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocerylister/Storage/FirebaseAPI/APIs.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Plans/DataModel/Plan.dart';
import 'package:grocerylister/Storage/FirebaseAPI/ShoppinglistIngredients/DataModel/ShoppinglistIngredient.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Shoppinglists/DataModel/Shoppinglist.dart';

class ShoppinglistHelper {
  static Future<Shoppinglist> generateNewShoppinglistFromPlan(Plan plan) async {
    var now = Timestamp.now();
    var shoppinglist = Shoppinglist(planId: plan.id, createdAt: now, lastModifiedAt: now);
    shoppinglist.id = await shoppinglistAPI.add(shoppinglist);

    for (var recipeId in plan.recipes) {
      var recipeIngredients = await recipeIngredientsAPI.getAllFromRecipeId(recipeId);
      for (var recipeIngredient in recipeIngredients) {
        var shoppinglistIngredient = ShoppinglistIngredient(
            shoppinglistId: shoppinglist.id,
            ingredientId: recipeIngredient.ingredientId,
            quantity: recipeIngredient.quantity,
            unit: recipeIngredient.unit,
            isBought: false);

        shoppinglistIngredient.id = await shoppinglistIngredientsAPI.add(shoppinglistIngredient);
      }
    }

    return shoppinglist;
  }
}
