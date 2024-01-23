import 'package:flutter/material.dart';

ThemeData mytheme = ThemeData(
      primarySwatch: Colors.orange,
      primaryTextTheme: Typography().white,
      textTheme: Typography().white,
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor:Colors.orange,
        background: Colors.black,
      ),
      appBarTheme: const AppBarTheme(
        color: Colors.orange,
        foregroundColor: Colors.black,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: Colors.white,
        iconColor: Colors.orange,
      ),
      dialogTheme: const DialogTheme(
        backgroundColor: Colors.orange,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black
        ),
        contentTextStyle: TextStyle(color: Colors.black),
        shadowColor: Colors.white,
      ),
      textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStatePropertyAll(Colors.orange)
        ),
      ),
      unselectedWidgetColor: Colors.orange,
      useMaterial3: true,
    );