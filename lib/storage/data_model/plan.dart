
import 'package:grocerylister/storage/data_model/recipe.dart';

class Plan{
  int id;
  String date;
  List recipes;

  Plan(int id, String date, List recipes){
    this.id = id;
    this.date = date;
    this.recipes = recipes;
  }

  Plan copy(){
    List<Recipe> recipesCopies = [];
    for (Recipe recipe in recipes){
      if (recipe == null)
        recipesCopies.add(null);
      else
        recipesCopies.add(recipe.copy());


    }

    return Plan(id, date, recipesCopies);
  }

  Map<String, dynamic> toMap (){
    return {
      'id' : id,
      'date' : date,
      'monday' : recipes[0].id,
      'tuesday' : recipes[1].id,
      'wednesday' : recipes[2].id,
      'thursday' : recipes[3].id,
      'friday' : recipes[4].id,
      'saturday' : recipes[5].id,
      'sunday' : recipes[6].id,
    };
  }
}