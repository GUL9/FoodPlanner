enum Unit {
  unit,
  litre,
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
    if (unitString == "litre")
      return Unit.litre;
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
