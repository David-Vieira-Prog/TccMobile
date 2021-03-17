import 'package:confpatapp/DrawerTiles.dart';
import 'package:confpatapp/LoginUser.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CustomDrawer extends StatefulWidget {
  PageController pageController;
  String nome;
  int matricula;
  CustomDrawer(this.pageController);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Future logout(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('matricula');
    pref.remove('nome');
    pref.remove('telefone');
    pref.remove('cpf');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginUser()),
    );
  }

  int matricula;
  String nome = '';
  String telefone = '';
  String cpf = '';
  Future getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      matricula = pref.getInt('matricula');
      nome = pref.getString('nome');
      telefone = pref.getString('telefone');
      cpf = pref.getString('cpf');
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          drawerHeader(matricula, nome),
          DrawerTiles('Setores', widget.pageController, 0, Colors.black),
          Divider(),
          InkWell(
              onTap: () {
                Navigator.of(context).pop();
                logout(context);
              },
              child: ListTile(
                title: Text(
                  'Sair',
                  style: GoogleFonts.kanit(
                    fontSize: 20,
                    color: Colors.red,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                trailing: Icon(Icons.arrow_right),
              ))
        ],
      ),
    );
  }
}

Widget drawerHeader(int matricula, String nome) {
  return DrawerHeader(
    margin: EdgeInsets.zero,
    padding: EdgeInsets.zero,
    decoration: BoxDecoration(color: Color.fromRGBO(84, 204, 11, 1)),
    child: Padding(
        padding: EdgeInsets.only(left: 14, top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confpat',
              textAlign: TextAlign.left,
              style: GoogleFonts.kanit(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
            ),
            Text(
              'Matrícula: $matricula',
              style: GoogleFonts.kanit(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
            ),
            Text(
              'Nome Completo: $nome',
              maxLines: 2,
              style: GoogleFonts.kanit(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
            )
          ],
        )),
  );
}
