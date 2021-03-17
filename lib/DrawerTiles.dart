import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerTiles extends StatelessWidget {
  final String nameTile;
  final PageController pageController;
  final int page;
  final Color textcolor;

  DrawerTiles(this.nameTile, this.pageController, this.page, this.textcolor);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
              pageController.jumpToPage(page);
            },
            child: ListTile(
              title: Text(
                '$nameTile',
                style: GoogleFonts.kanit(
                  fontSize: 20,
                  color: textcolor,
                  fontWeight: FontWeight.w300,
                ),
              ),
              trailing: Icon(Icons.arrow_right),
            )));
  }
}
