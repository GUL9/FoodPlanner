import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Plans/DataModel/Plan.dart';
import 'package:grocerylister/APIs/FirebaseAPI/RecipeIngredients/DataModel/RecipeIngredient.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Recipes/DataModel/Recipe.dart';
import 'package:grocerylister/APIs/FirebaseAPI/ShoppinglistIngredients/DataModel/ShoppinglistIngredient.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Shoppinglists/DataModel/Shoppinglist.dart';
import 'package:grocerylister/Middleware/Helpers/IngredientHelper.dart';
import 'package:grocerylister/Middleware/Helpers/PlanHelper.dart';
import 'package:grocerylister/Middleware/Helpers/RecipeHelper.dart';
import 'package:grocerylister/Middleware/Helpers/ShoppinglistHelper.dart';
import 'package:grocerylister/Middleware/States/States.dart';
import 'package:grocerylister/APIs/FirebaseAPI/APIs.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Ingredients/DataModel/Ingredient.dart';

class StatesHelper {
  static Future<void> initStates() async {
    await _loadIngredientsState();
    await _loadRecipesState();
    await _loadRecipeIngredientsState();
    await _loadPlanState();
    await _loadShoppinglistState();
    await _loadShoppinglistIngredientsState();
  }

  static _loadIngredientsState() async {
    var ingredients = await ingredientsAPI.getAll();
    ingredientsState = ingredients.map((i) => i as Ingredient).toList();
    ingredientsNotifierStream.sink.add(ingredientsState);
  }

  static _loadRecipesState() async {
    var recipes = await recipesAPI.getAll();
    recipesState = recipes.map((r) => r as Recipe).toList();
    recipesNotifierStream.sink.add(recipesState);
  }

  static _loadRecipeIngredientsState() async {
    var recipeIngredients = await recipeIngredientsAPI.getAll();
    recipeIngredientsState = recipeIngredients.map((ri) => ri as RecipeIngredient).toList();
    recipeIngredientsNotifierStream.sink.add(recipeIngredientsState);
  }

  static _loadPlanState() async {
    var plan = await plansAPI.getMostRecentlyCreated();
    currentPlanState = plan;

    _loadCurrentRecipesInPlanState();
    planNotifierStream.sink.add(currentPlanState);
  }

  static _loadShoppinglistState() async {
    var shoppinglist = await shoppinglistsAPI.getMostRecentlyCreated();
    currentShoppinglistState = shoppinglist;
    shoppinglistNotifierStream.sink.add(currentShoppinglistState);
  }

  static _loadShoppinglistIngredientsState() async {
    var shoppinglistIngredients = currentShoppinglistState != null
        ? await shoppinglistIngredientsAPI.getAllFromShoppinglistId(currentShoppinglistState.id)
        : <ShoppinglistIngredient>[];

    currentShoppinglistIngredientsState = shoppinglistIngredients;

    _loadCurrentIngredientsState();
    shoppinglistIngredientsNotifierStream.sink.add(currentShoppinglistIngredientsState);
  }

  static _loadCurrentRecipesInPlanState() {
    var recipes = <Recipe>[];
    if (currentPlanState != null) {
      for (var rId in currentPlanState.recipes) {
        var recipe = recipesState.singleWhere((r) => r.id == rId);
        recipes.add(recipe);
      }
    }

    currentRecipesInPlanState = recipes;
  }

  static _loadCurrentIngredientsState() {
    var ingredients = <Ingredient>[];
    for (var si in currentShoppinglistIngredientsState) {
      var ingredient = ingredientsState.singleWhere((i) => i.id == si.ingredientId);
      ingredients.add(ingredient);
    }
    currentIngredientsInShoppinglistState = ingredients;
  }

  static Future<void> updateIngredientsInStock(List<Ingredient> ingredientsInStock) async {
    await IngredientHelper.updateIngredients(ingredientsInStock);
    await _loadIngredientsState();
  }

  static Future<void> generateNewPlan() async {
    await PlanHelper.generateNewPlan(recipesState);
    await _loadPlanState();
  }

  static Future<void> updatePlan(Plan plan) async {
    await plansAPI.update(plan);
    await _loadPlanState();
  }

  static Future<void> generateNewShoppinglist() async {
    await ShoppinglistHelper.generateNewShoppinglist(currentPlanState, recipeIngredientsState, ingredientsState);
    await _loadShoppinglistState();
    await _loadShoppinglistIngredientsState();
  }

  static Future<void> updateShoppinglist() async {
    await ShoppinglistHelper.updateShoppinglist(
        currentShoppinglistState, currentPlanState, ingredientsState, recipeIngredientsState);
    await _loadShoppinglistState();
    await _loadShoppinglistIngredientsState();
  }

  static Future<void> updateShoppinglistFromJsonIngredientData(Map<String, dynamic> newIngredientData) async {
    await ShoppinglistHelper.updateShoppinglistFromJsonIngredientData(
        currentShoppinglistState, ingredientsState, currentShoppinglistIngredientsState, newIngredientData);
    await _loadIngredientsState();
    await _loadShoppinglistState();
    await _loadShoppinglistIngredientsState();
  }

  static Future<void> updateShoppinglistIngredient(ShoppinglistIngredient shoppinglistIngredient) async {
    await shoppinglistIngredientsAPI.update(shoppinglistIngredient);
    await _loadShoppinglistIngredientsState();

    var shoppinglist = Shoppinglist(
        id: currentShoppinglistState.id,
        planId: currentShoppinglistState.planId,
        createdAt: currentShoppinglistState.createdAt,
        lastModifiedAt: Timestamp.now());
    await shoppinglistsAPI.update(shoppinglist);
    await _loadShoppinglistState();
  }

  static Future<void> removeShoppinglistIngredient(ShoppinglistIngredient shoppinglistIngredient) async {
    await shoppinglistIngredientsAPI.delete(shoppinglistIngredient);
    await _loadShoppinglistIngredientsState();

    var shoppinglist = Shoppinglist(
        id: currentShoppinglistState.id,
        planId: currentShoppinglistState.planId,
        createdAt: currentShoppinglistState.createdAt,
        lastModifiedAt: Timestamp.now());
    await shoppinglistsAPI.update(shoppinglist);
    await _loadShoppinglistState();
  }

  static Future<void> saveRecipe(String recipeName, List<Map<String, String>> ingredientJsonRows) async {
    await RecipeHelper.saveRecipe(recipeName, ingredientJsonRows, ingredientsState);
    await _loadRecipesState();
    await _loadRecipeIngredientsState();
    await _loadIngredientsState();
  }

  static Future<void> removeRecipe(Recipe recipe) async {
    await RecipeHelper.removeRecipe(recipe, recipesState, recipeIngredientsState);
    await recipesAPI.delete(recipe);
    await _loadRecipesState();
    await _loadRecipeIngredientsState();
  }
}
