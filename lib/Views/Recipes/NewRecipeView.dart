import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocerylister/Helpers/RecipeHelper.dart';
import 'package:grocerylister/Styling/Themes/Themes.dart';
import 'package:grocerylister/Views/Components/IngredientInputDialog.dart';
import 'package:grocerylister/util/strings.dart';

class NewRecipeView extends StatefulWidget {
  @override
  NewRecipeViewState createState() => NewRecipeViewState();
}

class NewRecipeViewState extends State<NewRecipeView> {
  TextEditingController _recipeNameController = TextEditingController();
  List<Map<String, String>> _ingredientRows = [];
  ScrollController _ingredientListScrollController = ScrollController();

  void _saveRecipeAndReturn() {
    RecipeHelper.saveRecipe(_recipeNameController.text, _ingredientRows);
    Navigator.pop(context);
  }

  void _openNewRecipeIngredientDialog() {
    showDialog(context: context, builder: (_) => IngredientInputDialog()).then((newIngredientData) {
      if (newIngredientData != null)
        setState(() {
          _ingredientRows.add(newIngredientData);
          _ingredientListScrollController.jumpTo(_ingredientListScrollController.position.maxScrollExtent);
        });
    });
  }

  void _deleteIngredientRow(int index) => setState(() => _ingredientRows.removeAt(index));

  bool _isFloatingActionButtonColumnVisible() => MediaQuery.of(context).viewInsets.bottom == 0 ? true : false;

  Widget _newIngredientButton() => Padding(
      padding: EdgeInsets.all(1),
      child: Align(
          alignment: Alignment.center,
          child: SizedBox(
              height: 40,
              width: 500,
              child: TextButton(
                  child: Text(Strings.new_ingredient, style: Theme.of(context).textTheme.button),
                  style: Theme.of(context).textButtonTheme.style,
                  onPressed: _openNewRecipeIngredientDialog))));

  Widget _ingredientListTile(int index) => ListTile(
      title: Text(
          "${_ingredientRows[index]['quantity']} ${_ingredientRows[index]['unit']} ${_ingredientRows[index]['name']} ",
          style: Theme.of(context).textTheme.bodyText2),
      trailing: IconButton(icon: Icon(Icons.delete, color: primary3), onPressed: () => _deleteIngredientRow(index)));

  Widget _ingredientList() => Expanded(
      child: ListView.builder(
          controller: _ingredientListScrollController,
          itemCount: _ingredientRows.length + 1,
          itemBuilder: (context, index) =>
              Card(child: index == _ingredientRows.length ? _newIngredientButton() : _ingredientListTile(index))));

  Widget _floatingActionButtonColumn() => Visibility(
      visible: _isFloatingActionButtonColumnVisible(),
      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton.extended(
            icon: Icon(Icons.mic),
            label: Text(Strings.add),
            shape: Theme.of(context).buttonTheme.shape,
            heroTag: null,
            onPressed: () => takeVoiceInput()),
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        FloatingActionButton.extended(
            icon: Icon(Icons.check),
            label: Text(Strings.save_recipe),
            shape: Theme.of(context).buttonTheme.shape,
            heroTag: null,
            onPressed: _saveRecipeAndReturn),
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
      ]));

  @override
  build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(title: Text(Strings.new_recipe, style: Theme.of(context).textTheme.headline1)),
        body: Stack(children: [
          Container(
              margin: EdgeInsets.all(20),
              child: Column(children: <Widget>[
                Text(Strings.recipe_name, style: Theme.of(context).textTheme.headline2),
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                TextFormField(controller: _recipeNameController, style: Theme.of(context).textTheme.bodyText2),
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Text(Strings.ingredients, style: Theme.of(context).textTheme.headline2),
                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                _ingredientList()
              ])),
          Align(alignment: Alignment.bottomRight, child: _floatingActionButtonColumn())
        ]));
  }

  void takeVoiceInput() {
    // if (_recipeNameController.text.isEmpty)
    //   globals.sttHandler.listenToSpeech(null, handleTextFromSpeech);
    // else
    //   globals.sttHandler.listenToSpeech('Storbritannien', handleTextFromSpeech);
  }

  // Future handleTextFromSpeech(String text) async {
  //   if (_recipeNameController.text.isEmpty)
  //     _recipeNameController.text = text;
  //   else
  //     await globals.nlpServerComm.requestForIngredient(text, handleParsedIngredient);
  // }

  // void handleParsedIngredient(List ingredientTokens) {
  //   String name = ingredientTokens[0];
  //   String quantity = ingredientTokens[1];
  //   String unit = allUnitsAsStrings().contains(ingredientTokens[2]) ? ingredientTokens[2] : null;
  //   setState(() => _ingredientRows.add(IngredientInputRow(name: name, quantity: quantity, unit: unit)));
  // }
}
