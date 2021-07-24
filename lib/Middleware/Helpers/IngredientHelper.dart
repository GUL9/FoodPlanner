import 'package:grocerylister/APIs/FirebaseAPI/APIs.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Ingredients/DataModel/Ingredient.dart';

class IngredientHelper {
  static Future<Ingredient> getFromNameOrCreateNew(String name) async {
    var ingredient = await ingredientsAPI.getFromName(name);
    if (ingredient == null) {
      ingredient = Ingredient(name: name, isInStock: false);
      ingredient.id = await ingredientsAPI.add(ingredient);
    }
    return ingredient;
  }
}
