enum Units { unit, liter, kilogram, piece }

extension UnitExtension on Units {
  String asString() {
    return this.toString().split(".").last;
  }
}

List<String> allUnitsAsStrings() {
  List<String> strings = [];
  for (Units unit in Units.values) strings.add(unit.asString());

  return strings;
}

Units stringToUnit(String unitString) {
  switch (unitString) {
    case "liter":
      return Units.liter;
    case "kilogram":
      return Units.kilogram;
    case "piece":
      return Units.piece;
    default:
      return Units.unit;
  }
}
