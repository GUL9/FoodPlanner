import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grocerylister/util/view/ingredient_input_container.dart';
import 'package:grocerylister/Navigation/Navigation.dart';
import 'package:grocerylister/storage/data_model/shopping_list.dart';
import 'package:grocerylister/util/strings.dart';

class ShoppinglistView extends State<NavigationView> {
  List<ShoppingListEntry> shoppingList = [];
  List<ShoppingListEntry> checked = [];
  List<ShoppingListEntry> removed = [];

  @override
  void initState() {
    // super.initState();
    // loadShoppingList();
    // globals.planStream.stream.listen((savedPlan) => loadShoppingList());
    // globals.recipeStream.stream.listen((savedRecipe) {
    //   if (savedRecipe == null) loadShoppingList();
    // });
  }

  void loadShoppingList() async {
    // List<ShoppingListEntry> list = [];

    // Plan latestPlan = await Storage.instance.getLatestPlan();
    // if (latestPlan != null) list = await Storage.instance.getShoppingListWithPlanId(latestPlan.id);

    // setState(() {
    //   shoppingList = list == null ? [] : list;
    // });

    // for (int i = 0; i < shoppingList.length; i++) {
    //   if (shoppingList[i].isBought) checked.add(shoppingList[i]);
    // }
  }

  Future<void> saveShoppingList() async {
    //   for (ShoppingListEntry entry in shoppingList) await Storage.instance.insertShoppinglistEntry(entry);
    // }

    // Future<void> addNewIngredient(Map newIngredient) async {
    //   bool isUnique = true;
    //   for (ShoppingListEntry entry in shoppingList) {
    //     if (entry.ingredient.name == newIngredient['name'] && entry.unit == newIngredient['unit']) {
    //       setState(() {
    //         entry.quantity += newIngredient['quantity'];
    //       });
    //       await Storage.instance.insertShoppinglistEntry(entry);
    //       isUnique = false;
    //     }
    //   }
    //   if (isUnique) {
    //     Ingredient ingredient = await Storage.instance.getIngredientWithName(newIngredient['name']);
    //     if (ingredient == null) ingredient = Ingredient(UniqueKey().hashCode, newIngredient['name']);

    //     ShoppingListEntry entry = ShoppingListEntry(UniqueKey().hashCode, DateTime.now().toString(),
    //         shoppingList.first.plan, ingredient, newIngredient['unit'], newIngredient['quantity'], false);

    //     setState(() {
    //       shoppingList.add(entry);
    //     });

    //     await Storage.instance.insertShoppinglistEntry(entry);
    //   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.destination.title}'),
        backgroundColor: widget.destination.color,
      ),
      backgroundColor: widget.destination.color[100],
      body: Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: ListView.builder(
            itemCount: shoppingList.length,
            itemBuilder: (context, index) {
              ShoppingListEntry recipeIngredient = shoppingList[index];

              return Card(
                child: CheckboxListTile(
                  title: Text(recipeIngredient.ingredient.name +
                      ": " +
                      recipeIngredient.quantity.toString() +
                      " " +
                      recipeIngredient.unit),
                  secondary: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      setState(() {
                        removed.add(recipeIngredient);
                        shoppingList.remove(recipeIngredient);
                      });
                      //await Storage.instance.deleteShoppinglistEntryWithId(recipeIngredient.id);
                    },
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                  value: checked.contains(shoppingList[index]),
                  onChanged: (bool isChecked) async {
                    setState(() {
                      if (isChecked) {
                        checked.add(shoppingList[index]);
                        shoppingList[index].isBought = true;
                      } else {
                        checked.remove(shoppingList[index]);
                        shoppingList[index].isBought = false;
                      }
                    });
                    //await Storage.instance.insertShoppinglistEntry(shoppingList[index]);
                  },
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(content: IngredientInputContainer());
              }).then((newIngredient) {
            if (newIngredient != null) {
              //addNewIngredient(newIngredient);
            }
          });
        },
        icon: Icon(Icons.add),
        label: Text(Strings.add_grocery),
        heroTag: null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
