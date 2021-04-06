enum Unit {
  unit,
  liter,
  gram,
  pieces
}

extension UnitExtension on Unit{
  String unitToString(){
    return this.toString().split(".").last;
  }

  Unit stringToUnit(String unitString){
    if (unitString == "unit")
      return Unit.unit;
    if (unitString == "liter")
      return Unit.liter;
    if ( unitString == "gram")
      return Unit.gram;
    if (unitString == "pieces")
      return Unit.pieces;

    return null;
  }

  List<String> getUnitsAsStrings(){
    List<String> strings = [];
    for (Unit unit in Unit.values){
      strings.add(unit.unitToString());
    }
    return strings;
  }
}
