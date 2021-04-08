class Recipe {
  int id;
  String name;

  Recipe(int id, String name) {
    this.id = id;
    this.name = name;
  }

  Recipe copy(){
    return (Recipe(id, name));
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name.toLowerCase(),
    };
  }
}