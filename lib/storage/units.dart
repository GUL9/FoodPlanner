enum Unit {
  unit,
  liter,
  kilogram,
  piece
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
    if ( unitString == "kilogram")
      return Unit.kilogram;
    if (unitString == "piece")
      return Unit.piece;

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
