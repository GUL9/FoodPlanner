import 'package:grocerylister/Storage/FirebaseAPI/APIs.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Ingredients/DataModel/Ingredient.dart';

class IngredientHelper {
  static Future<Ingredient> getFromNameOrCreateNew(String name) async {
    var ingredient = await ingredientsAPI.getFromName(name);
    if (ingredient == null) {
      ingredient = Ingredient(name: name);
      ingredient.id = await ingredientsAPI.add(ingredient);
    }
    return ingredient;
  }
}
