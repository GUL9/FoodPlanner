import 'package:grocerylister/Middleware/States/StateNotifierStreams/StateNotifierStreams.dart';
import 'package:grocerylister/APIs/FirebaseAPI/APIs.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Ingredients/DataModel/Ingredient.dart';

List<Ingredient> ingredientsState;

class StatesHelper {
  static void initStates() async {
    ingredientsState = await ingredientsAPI.getAll();

    ingredientsNotifierStream.stream.listen((_) async => ingredientsState = await ingredientsAPI.getAll());
  }

  static void updateIngredientsState() => ingredientsNotifierStream.sink.add(null);
}
