import 'package:grocerylister/APIs/FirebaseAPI/RecipeIngredients/DataModel/RecipeIngredient.dart';
import 'package:grocerylister/Middleware/Helpers/IngredientHelper.dart';
import 'package:grocerylister/Middleware/Helpers/ShoppinglistHelper.dart';
import 'package:grocerylister/Middleware/States/States.dart';
import 'package:grocerylister/APIs/FirebaseAPI/APIs.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Ingredients/DataModel/Ingredient.dart';

class StatesHelper {
  static Future<void> initStates() async {
    await _loadIngredientsState();
    await _loadRecipeIngredientsState();
    await _loadPlanState();
    await _loadShoppinglistState();
    await _loadShoppinglistIngredientState();
  }

  static _loadIngredientsState() async {
    var ingredients = await ingredientsAPI.getAll();
    ingredientsState = ingredients.map((i) => i as Ingredient).toList();
    ingredientsNotifierStream.sink.add(ingredients);
  }

  static _loadRecipeIngredientsState() async {
    var recipeIngredients = await recipeIngredientsAPI.getAll();
    recipeIngredientsState = recipeIngredients.map((ri) => ri as RecipeIngredient).toList();
    recipeIngredientsNotifierStream.sink.add(recipeIngredients);
  }

  static _loadPlanState() async {
    var plan = await plansAPI.getMostRecentlyCreated();
    currentPlanState = plan;
    ingredientsNotifierStream.sink.add(plan);
  }

  static _loadShoppinglistState() async {
    var shoppinglist = await shoppinglistsAPI.getMostRecentlyCreated();
    currentShoppinglistState = shoppinglist;
    shoppinglistNotifierStream.sink.add(shoppinglist);
  }

  static _loadShoppinglistIngredientState() async {
    var shoppinglistIngredients =
        await shoppinglistIngredientsAPI.getAllFromShoppinglistId(currentShoppinglistState.id);
    currentShoppinglistIngredientsState = shoppinglistIngredients;

    await _loadCurrentIngredientsState();
    shoppinglistIngredientsNotifierStream.sink.add(shoppinglistIngredients);
  }

  static _loadCurrentIngredientsState() async {
    var ingredients = <Ingredient>[];
    for (var si in currentShoppinglistIngredientsState) {
      var ingredient = ingredientsState.singleWhere((i) => i.id == si.ingredientId);
      ingredients.add(ingredient);
    }
    currentIngredientsState = ingredients;
  }

  static Future<void> updateIngredientsInStock(List<Ingredient> ingredientsInStock) async {
    await IngredientHelper.updateIngredients(ingredientsInStock);
    await _loadIngredientsState();
  }

  static Future<void> updateShoppinglist() async {
    await ShoppinglistHelper.updateShoppinglist(
        currentShoppinglistState, currentPlanState, ingredientsState, recipeIngredientsState);
    await _loadShoppinglistState();
    await _loadShoppinglistIngredientState();
  }

  static Future<void> updateShoppinglistFromJsonIngredientData(Map<String, dynamic> newIngredientData) async {
    await ShoppinglistHelper.updateShoppinglistFromJsonIngredientData(
        currentShoppinglistState, ingredientsState, currentShoppinglistIngredientsState, newIngredientData);
    await _loadIngredientsState();
    await _loadShoppinglistState();
    await _loadShoppinglistIngredientState();
  }
}
