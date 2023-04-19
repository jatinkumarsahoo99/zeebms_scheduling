import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData primaryThemeData = ThemeData(
  focusColor: Colors.deepPurple[200],
  // scaffoldBackgroundColor: Colors.grey[300],
  scaffoldBackgroundColor: Colors.white,

  primarySwatch: Colors.deepPurple,
  appBarTheme: const AppBarTheme(
    toolbarHeight: 48,
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.white,
  ),

  primaryIconTheme: const IconThemeData(color: Colors.deepPurple),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: const TextStyle(fontSize: 12),
    contentPadding: const EdgeInsets.only(left: 30),
    focusColor: Colors.deepPurple[200],
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.deepPurpleAccent),
    ),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.deepPurpleAccent),
    ),
  ),
);
