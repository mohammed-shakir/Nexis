/* The register_page and auth_page uses different columns that include 
  different widgets, this file is used to name the different types of 
  combinations of widgets in each column */

// type1: heading text + descriptive text + textfield
// type2: descriptive text + textfield + text with hyperlink
// type3: descriptive text + textfield
// type4: button + text with hyperlink
// type5: descriptive text + special textfield for 'date of birth'

enum ColumnType {
  type1,
  type2,
  type3,
  type4,
  type5,
}

// Returns heights between widgets
List<double> getMargins(ColumnType type){
  if (type == ColumnType.type1) { return [10,5,0,0]; }
  if (type == ColumnType.type2) { return [0,5,5,0]; }
  if (type == ColumnType.type3 || type == ColumnType.type5) { return [0,5,0,0]; }
  if (type == ColumnType.type4) { return [0,0,0,5]; }
  return [0,0,0,0];
}