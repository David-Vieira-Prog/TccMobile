import 'package:confpatapp/HomeScreen.dart';
import 'package:confpatapp/LoginUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  int matricula = pref.getInt('matricula');

  runApp(MaterialApp(
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate
    ],
    supportedLocales: [const Locale('pt')],
    home: matricula == null ? LoginUser() : HomeScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
