import 'package:grocerylister/Storage/FirebaseAPI/Ingredients/IngredientsAPI.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Plans/PlansAPI.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Recipes/RecipesAPI.dart';
import 'package:grocerylister/Storage/FirebaseAPI/ShoppinglistIngredients/ShoppinglistIngredientsAPI.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Shoppinglists/ShoppinglistAPI.dart';
import 'RecipeIngredients/RecipeIngredientsAPI.dart';

const String RECIPES = 'recipes';
const String INGREDIENTS = 'ingredients';
const String RECIPE_INGREDIENTS = 'recipe_ingredients';
const String PLANS = 'plans';
const String SHOPPINGLISTS = 'shoppinglists';
const String SHOPPINGLIST_INGREDIENTS = 'shoppinglist_ingredients';

final recipesAPI = RecipesAPI();
final ingredientsAPI = IngredientsAPI();
final recipeIngredientsAPI = RecipeIngredientsAPI();
final plansAPI = PlansAPI();
final shoppinglistAPI = ShoppinglistAPI();
final shoppinglistIngredientsAPI = ShoppinglistIngredientsAPI();
