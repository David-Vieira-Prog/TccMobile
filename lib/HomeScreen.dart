import 'package:confpatapp/CustomDrawer.dart';
import 'package:confpatapp/SelectSetor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  final pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(84, 204, 11, 1),
            title: Text(
              'Setores',
              style: GoogleFonts.kanit(
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          body: SelectSetor(),
          drawer: CustomDrawer(
            pageController,
          ),
        ),
      ],
    );
  }
}
