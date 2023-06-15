import 'package:flutter/material.dart';

enum ColumnType {
  type1,
  type2,
  type3,
  type4,
}

List<double> getMargins(ColumnType type){
  if (type == ColumnType.type1) { return [10,5,0,0]; }
  if (type == ColumnType.type2) { return [0,5,5,0]; }
  if (type == ColumnType.type3) { return [0,5,0,0]; }
  if (type == ColumnType.type4) { return [0,0,0,5]; }
  return [0,0,0,0];
}