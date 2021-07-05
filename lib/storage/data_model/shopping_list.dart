import 'package:grocerylister/Storage/FirebaseAPI/Ingredients/DataModel/Ingredient.dart';
import 'package:grocerylister/storage/data_model/plan.dart';

class ShoppingListEntry {
  int id;
  String date;
  Plan plan;
  Ingredient ingredient;
  String unit;
  double quantity;
  bool isBought;

  ShoppingListEntry(
      int id, String date, Plan plan, Ingredient ingredient, String unit, double quantity, bool isBought) {
    this.id = id;
    this.date = date;
    this.plan = plan;
    this.ingredient = ingredient;
    this.unit = unit;
    this.quantity = quantity;
    this.isBought = isBought;
  }
}
