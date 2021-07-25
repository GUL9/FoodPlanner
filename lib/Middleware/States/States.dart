import 'dart:async';

import 'package:grocerylister/APIs/FirebaseAPI/Ingredients/DataModel/Ingredient.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Plans/DataModel/Plan.dart';
import 'package:grocerylister/APIs/FirebaseAPI/RecipeIngredients/DataModel/RecipeIngredient.dart';
import 'package:grocerylister/APIs/FirebaseAPI/ShoppinglistIngredients/DataModel/ShoppinglistIngredient.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Shoppinglists/DataModel/Shoppinglist.dart';

final ingredientsNotifierStream = StreamController();
final recipesNotifierStream = StreamController();
final recipeIngredientsNotifierStream = StreamController();
final planNotifierStream = StreamController();
final shoppinglistNotifierStream = StreamController();
final shoppinglistIngredientsNotifierStream = StreamController();

final stockNotifierStream = StreamController();

List<Ingredient> ingredientsState;
List<RecipeIngredient> recipeIngredientsState;
Plan currentPlanState;
Shoppinglist currentShoppinglistState;
List<ShoppinglistIngredient> currentShoppinglistIngredientsState;
List<Ingredient> currentIngredientsState;
