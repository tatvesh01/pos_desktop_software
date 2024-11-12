import 'package:desktop_crud_app/UI/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'Helper/DBHelper.dart';
import 'UI/CategoryManager.dart';
import 'UI/HomeScreen.dart';
import 'UI/ProductListScreen.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await DBHelper().database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Desktop App',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
