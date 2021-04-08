import 'dart:async';
import 'dart:core';
import 'package:grocerylister/storage/data_model/ingredient.dart';
import 'package:grocerylister/storage/data_model/recipe.dart';
import 'package:grocerylister/storage/data_model/shopping_list.dart';

import 'data_model/plan.dart';
import 'data_model/recipe_ingredient.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';



class Storage {
  Storage();

  static const databaseName = "database.db";
  static final Storage instance = Storage();
  static Database db;

  Future<Database> get database async {
    if (db == null) {
      return await initializeDatabase();
    }
  }

  initializeDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), databaseName),
        version: 1,
        onConfigure: (Database db) async{



          //await db.execute("PRAGMA foreign_keys = OFF");
          //await db.execute("DROP TABLE recipes");
          //await db.execute("DROP TABLE ingredients");
          //await db.execute("DROP TABLE plans");
          //await db.execute("DROP TABLE recipe_ingredients");
          //await db.execute("DROP TABLE shoppinglists");

          await db.execute("PRAGMA foreign_keys = ON");



          await db.execute("CREATE TABLE IF NOT EXISTS recipes"
              "("
              "id INTEGER PRIMARY KEY,"
              "name TEXT"
              ")"
          );

          await db.execute("CREATE TABLE IF NOT EXISTS ingredients"
              "("
              "id INTEGER PRIMARY KEY,"
              "name TEXT)"
          );

          await db.execute("CREATE TABLE IF NOT EXISTS plans"
              "("
              "id INTEGER PRIMARY KEY,"
              "date TEXT,"
              "monday INTEGER,"
              "tuesday INTEGER,"
              "wednesday INTEGER,"
              "thursday INTEGER,"
              "friday INTEGER,"
              "saturday INTEGER,"
              "sunday INTEGER,"
              "FOREIGN KEY(monday) REFERENCES recipes(id) ON DELETE CASCADE,"
              "FOREIGN KEY(tuesday) REFERENCES recipes(id) ON DELETE CASCADE,"
              "FOREIGN KEY(wednesday) REFERENCES recipes(id) ON DELETE CASCADE,"
              "FOREIGN KEY(thursday) REFERENCES recipes(id) ON DELETE CASCADE,"
              "FOREIGN KEY(friday) REFERENCES recipes(id) ON DELETE CASCADE,"
              "FOREIGN KEY(saturday) REFERENCES recipes(id) ON DELETE CASCADE,"
              "FOREIGN KEY(sunday) REFERENCES recipes(id) ON DELETE CASCADE"
              ")"
          );
          await db.execute("CREATE TABLE IF NOT EXISTS recipe_ingredients"
              "("
              "id INTEGER PRIMARY KEY,"
              "recipeID INTEGER,"
              "ingredientID INTEGER,"
              "unit TEXT,"
              "quantity REAL,"
              "FOREIGN KEY(recipeID) REFERENCES recipes(id) ON DELETE CASCADE,"
              "FOREIGN KEY(ingredientID) REFERENCES ingredients(id)"
              ")"
          );
          await db.execute("CREATE TABLE IF NOT EXISTS shoppinglists"
              "("
              "id INTEGER PRIMARY KEY,"
              "date TEXT,"
              "planID INTEGER,"
              "ingredientID INTEGER,"
              "unit TEXT,"
              "quantity REAL,"
              "isBought INTEGER,"
              "FOREIGN KEY(planID) REFERENCES plans(id) ON DELETE CASCADE,"
              "FOREIGN KEY(ingredientID) REFERENCES ingredients(id)"
              ")"
          );

        },
        onCreate: (Database db, int version) async {

          await db.execute("PRAGMA foreign_keys = ON");

          await db.execute("CREATE TABLE recipes"
              "("
              "id INTEGER PRIMARY KEY,"
              "name TEXT"
              ")"
          );

          await db.execute("CREATE TABLE ingredients"
              "("
              "id INTEGER PRIMARY KEY,"
              "name TEXT"
              ")"
          );

          await db.execute("CREATE TABLE  plans"
              "("
              "id INTEGER PRIMARY KEY,"
              "date TEXT,"
              "monday INTEGER,"
              "tuesday INTEGER,"
              "wednesday INTEGER,"
              "thursday INTEGER,"
              "friday INTEGER,"
              "saturday INTEGER,"
              "sunday INTEGER,"
              "FOREIGN KEY(monday) REFERENCES recipes(id) ON DELETE CASCADE,"
              "FOREIGN KEY(tuesday) REFERENCES recipes(id) ON DELETE CASCADE,"
              "FOREIGN KEY(wednesday) REFERENCES recipes(id) ON DELETE CASCADE,"
              "FOREIGN KEY(thursday) REFERENCES recipes(id) ON DELETE CASCADE,"
              "FOREIGN KEY(friday) REFERENCES recipes(id) ON DELETE CASCADE,"
              "FOREIGN KEY(saturday) REFERENCES recipes(id) ON DELETE CASCADE,"
              "FOREIGN KEY(sunday) REFERENCES recipes(id) ON DELETE CASCADE"
              ")"
          );
          await db.execute("CREATE TABLE recipe_ingredients"
              "("
              "id INTEGER PRIMARY KEY,"
              "recipeID INTEGER,"
              "ingredientID INTEGER,"
              "unit TEXT,"
              "quantity REAL,"
              "FOREIGN KEY(recipeID) REFERENCES recipes(id) ON DELETE CASCADE,"
              "FOREIGN KEY(ingredientID) REFERENCES ingredients(id)"
              ")"
          );
          await db.execute("CREATE TABLE shoppinglists"
              "("
              "id INTEGER PRIMARY KEY,"
              "date TEXT,"
              "planID INTEGER,"
              "ingredientID INTEGER,"
              "unit TEXT,"
              "quantity REAL,"
              "isBought INTEGER,"
              "FOREIGN KEY(planID) REFERENCES plans(id) ON DELETE CASCADE,"
              "FOREIGN KEY(ingredientID) REFERENCES ingredients(id)"
              ")"
          );
        });

  }

  Future<void> insertRecipe(Recipe recipe) async {
    final Database db = await database;
    await db.insert(
      'recipes',
      recipe.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Recipe> getRecipeWithId(int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM recipes WHERE id = $id'
    );
    return maps.isEmpty ? null : Recipe(maps.first['id'], maps.first['name']);
  }

  Future<void> deleteRecipeWithId(int id) async {
    final Database db = await database;
    await db.rawQuery(
        'DELETE FROM recipes WHERE id = $id'
    );
  }

  Future<Recipe> getRecipeWithName(String name) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM recipes WHERE name = \"$name\"'
    );
    return maps.isEmpty ? null : Recipe(maps.first['id'], maps.first['name']);
  }

  Future<List<Recipe>> getRecipes() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recipes');
    return List.generate(maps.length, (i) {
      return Recipe(
        maps[i]['id'],
        maps[i]['name'],
      );
    });
  }

  Future<void> insertIngredient(Ingredient ingredient) async {
    final Database db = await database;
    await db.insert(
      'ingredients',
      ingredient.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Ingredient>> getIngredients() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM ingredients'
    );
    return List.generate(maps.length, (i) {
      return Ingredient(
        maps[i]['io'],
        maps[i]['name'],
      );
    });
  }

  Future<Ingredient> getIngredientWithId(int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM ingredients WHERE id = $id'
    );
    return maps.isEmpty ? null : Ingredient(maps.first['id'], maps.first['name']);
  }

  Future<Ingredient> getIngredientWithName(String name) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM ingredients WHERE name = \"$name\"'
    );
    return maps.isEmpty ? null : Ingredient(maps.first['id'], maps.first['name']);
  }

  Future<List<RecipeIngredient>> getRecipeIngredients() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM recipe_ingredients',
    );

    List recipeIngredients = [];

    for(Map entry in maps){
      Ingredient ingredient = await getIngredientWithId(entry['ingredientID']);
      Recipe recipe = await getRecipeWithId(entry['recipeID']);
      recipeIngredients.add(RecipeIngredient(entry['id'], recipe, ingredient, entry['unit'], entry['quantity']));
    }

    return recipeIngredients;
  }

  Future<List<RecipeIngredient>> getRecipeIngredientsForRecipeWithId(int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM recipe_ingredients WHERE recipeID = $id',
    );

    List<RecipeIngredient> recipeIngredients = [];

    for(Map entry in maps){
      Recipe recipe = await getRecipeWithId(entry['recipeID']);
      Ingredient ingredient = await getIngredientWithId(entry['ingredientID']);
      recipeIngredients.add(RecipeIngredient(entry['id'], recipe, ingredient, entry['unit'], entry['quantity']));
    }

    return recipeIngredients;
  }

  Future<void> insertRecipeIngredient(RecipeIngredient recipeIngredient) async {
    final Database db = await database;

    Recipe recipe = await getRecipeWithName(recipeIngredient.recipe.name);
    Ingredient ingredient = await getIngredientWithName(recipeIngredient.ingredient.name);

    if(recipe == null)
      await insertRecipe(recipeIngredient.recipe);
    if(ingredient == null)
      await insertIngredient(recipeIngredient.ingredient);

    await db.insert(
      'recipe_ingredients',
      recipeIngredient.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertPlan(Plan plan) async {
    final Database db = await database;
    await db.insert(
      'plans',
      plan.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Plan> getPlanWithId(int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM plans WHERE id = $id'
    );

    if (maps.isEmpty)
      return null;

    List recipes = [];
    recipes.add(await getRecipeWithId(maps.first['monday']));
    recipes.add(await getRecipeWithId(maps.first['tuesday']));
    recipes.add(await getRecipeWithId(maps.first['wednesday']));
    recipes.add(await getRecipeWithId(maps.first['thursday']));
    recipes.add(await getRecipeWithId(maps.first['friday']));
    recipes.add(await getRecipeWithId(maps.first['saturday']));
    recipes.add(await getRecipeWithId(maps.first['sunday']));

    return Plan(maps.first['id'], maps.first['date'], recipes);
  }

  Future<Plan> getLatestPlan() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM plans ORDER BY strftime(\'%s\', date)'
    );

    if (maps.isEmpty)
      return null;

    List recipes = [];
    recipes.add(await getRecipeWithId(maps.last['monday']));
    recipes.add(await getRecipeWithId(maps.last['tuesday']));
    recipes.add(await getRecipeWithId(maps.last['wednesday']));
    recipes.add(await getRecipeWithId(maps.last['thursday']));
    recipes.add(await getRecipeWithId(maps.last['friday']));
    recipes.add(await getRecipeWithId(maps.last['saturday']));
    recipes.add(await getRecipeWithId(maps.last['sunday']));

    return Plan(maps.last['id'], maps.last['date'], recipes);
  }

  Future<List<Plan>> getPlans() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT* FROM plans'
    );

    List<Plan> plans = [];

    for (Map entry in maps){
      List recipes = [];
      recipes.add(await getRecipeWithId(entry['monday']));
      recipes.add(await getRecipeWithId(entry['tuesday']));
      recipes.add(await getRecipeWithId(entry['wednesday']));
      recipes.add(await getRecipeWithId(entry['thursday']));
      recipes.add(await getRecipeWithId(entry['friday']));
      recipes.add(await getRecipeWithId(entry['saturday']));
      recipes.add(await getRecipeWithId(entry['sunday']));
      plans.add(Plan(entry['id'], entry['date'], recipes));
    }

    return plans;
  }


  Future<void> insertShoppinglistEntry(ShoppingListEntry shoppingListEntry) async {
    final Database db = await database;

    Ingredient ingredient = await getIngredientWithId(shoppingListEntry.ingredient.id);
    if (ingredient == null)
      await insertIngredient(shoppingListEntry.ingredient);

    await db.insert(
      'shoppinglists',
      shoppingListEntry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );


  }

  Future<List<ShoppingListEntry>> getShoppingListWithPlanId(int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM shoppinglists WHERE planID = $id'
    );

    List<ShoppingListEntry> entries = [];
    for (Map entry in maps){
      Ingredient ingredient = await getIngredientWithId(entry['ingredientID']);
      Plan plan = await getPlanWithId(entry['planID']);
      entries.add(ShoppingListEntry(
          entry['id'],
          entry['date'],
          plan,
          ingredient,
          entry['unit'],
          entry['quantity'],
          entry['isBought'] == 1 ? true: false)
      );
    }
    return entries;
  }

  Future<void> deleteShoppinglistEntryWithId(int id) async {
    final Database db = await database;
    await db.rawQuery(
      "DELETE FROM shoppinglists WHERE id = $id",
    );
  }
}
