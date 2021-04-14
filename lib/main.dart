import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:confpatapp/HomeScreen.dart';
import 'package:confpatapp/LoginUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences pref = await SharedPreferences.getInstance();
  int _matricula = pref.getInt('matricula');
  runApp(MaterialApp(
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate
    ],
    supportedLocales: [const Locale('pt')],
    home: Material(
      child: Stack(
        children: [
          AnimatedSplashScreen(
            curve: Curves.ease,
            duration: 2000,
            backgroundColor: Color.fromRGBO(84, 204, 11, 1),
            nextScreen: _matricula == null ? LoginUser() : HomeScreen(),
            splash: null,
          ),
          Center(
            child: Container(
              height: 600,
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset('images/LogoMobile.svg',
                      height: 300, width: 300),
                  Text(
                    'CONFPAT',
                    style: GoogleFonts.kanit(
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ),
    debugShowCheckedModeBanner: false,
  ));
}
