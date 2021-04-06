class Ingredient {
  int id;
  String name;

  Ingredient(int id, String name) {
    this.id = id;
    this.name = name;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }



}