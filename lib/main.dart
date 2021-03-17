import 'package:confpatapp/HomeScreen.dart';
import 'package:confpatapp/LoginUser.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  int matricula = pref.getInt('matricula');
  runApp(MaterialApp(
    home: matricula == null ? LoginUser() : HomeScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
