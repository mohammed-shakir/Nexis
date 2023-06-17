import 'package:flutter/material.dart';

class RouteChange {
  final String route;
  final BuildContext context;
  RouteChange(this.context, this.route);

  reDir() async {
    try {
      await Navigator.pushReplacementNamed(context, route);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('oopsie: $e')),
      );
    }
  }
}