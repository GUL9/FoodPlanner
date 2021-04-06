import 'package:grocerylister/storage/data_model/ingredient.dart';
import 'package:grocerylister/storage/data_model/plan.dart';

class ShoppingListEntry {
  int id;
  String date;
  Plan plan;
  Ingredient ingredient;
  String unit;
  double quantity;
  bool isBought;

  ShoppingListEntry(int id, String date, Plan plan, Ingredient ingredient, String unit, double quantity, bool isBought){
    this.id = id;
    this.date = date;
    this.plan = plan;
    this.ingredient = ingredient;
    this.unit = unit;
    this.quantity = quantity;
    this.isBought = isBought;
  }

  Map<String, dynamic> toMap (){
    return {
      'id' : id,
      'date' : date,
      'planID' : plan.id,
      'ingredientID' : ingredient.id,
      'unit' : unit,
      'quantity' : quantity,
      'isBought' : isBought ? 1 : 0,
    };
  }
}