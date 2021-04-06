import 'package:flutter/material.dart';
import 'package:grocerylister/storage/data_model/recipe.dart';
import 'package:grocerylister/storage/storage.dart';

class SelectRecipeContainer extends StatefulWidget {
  @override
  _SelectRecipeContainerState createState() => _SelectRecipeContainerState();
}

class _SelectRecipeContainerState extends State<SelectRecipeContainer> {
  List<Recipe> recipes = [];

  Future<void> loadRecipes() async {
    List<Recipe> tmp = await Storage.instance.getRecipes();
    setState(() {
      recipes = tmp;
    });
  }

  @override
  void initState() {
    super.initState();
    loadRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      height: MediaQuery.of(context).size.height - 30,
      child: ListView(
        children: [
          for (int i = 0; i < recipes.length; i++)
            Card( child: ListTile(title: Text(recipes[i].name), onTap: (){
              Navigator.pop(context, recipes[i]);
              },)
            )
        ],
      ),
    );
  }
}
