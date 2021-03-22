import 'package:flutter/material.dart';
import 'package:ninety9names/pages/home/home.dart';
import 'package:ninety9names/pages/names/details.dart';

Map<String, Widget Function(BuildContext)> getRoutes() {
  return {
    '/': (context) => Home(title: 'ninety9names'),
    '/details': (context) => Details(),
  };
}
