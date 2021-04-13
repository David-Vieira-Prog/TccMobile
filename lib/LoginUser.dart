import 'dart:convert';
import 'package:confpatapp/CreateUser.dart';
import 'package:confpatapp/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:switcher/core/switcher_size.dart';
import 'package:switcher/switcher.dart';

class LoginUser extends StatefulWidget {
  @override
  _LoginUserState createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  Future authUser(matricula, senha) async {
    var url = "https://apiconfpat.herokuapp.com/api/AuthUserApi";

    var response = await http.post(
      url,
      body: {'matricula': '$matricula', 'senha': '$senha'},
    );

    var data = json.decode(response.body);
    if (data["authenticated"] == true) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setInt('matricula', data['data'][0]['Matricula']);
      pref.setString('nome', data['data'][0]['Nome']);
      pref.setString('telefone', data['data'][0]['Telefone']);
      pref.setString('cpf', data['data'][0]['Cpf']);
      return true;
    } else if (data["message"] == "Login Failed") {
      return false;
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final matriculacontroller = TextEditingController();
  final senhacontroller = TextEditingController();
  bool showPassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: MediaQuery.of(context).size.width * 0.775,
              bottom: MediaQuery.of(context).size.height * 0.865,
              child: Padding(
                  padding: EdgeInsets.only(
                    top: 2.0,
                  ),
                  child: Image.asset('images/QrTopLeft.png')),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.75,
              right: MediaQuery.of(context).size.width * 0.37,
              left: MediaQuery.of(context).size.width * 0.37,
              child: Container(
                child: Image.asset('images/QrCodeLoginUser.png', scale: 0.1),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.775,
              bottom: MediaQuery.of(context).size.height * 0.865,
              child: Padding(
                  padding: EdgeInsets.only(top: 5.0, right: 5.0),
                  child: Image.asset('images/QrTopRight.png')),
            ),
            Positioned(
                bottom: MediaQuery.of(context).size.height * 0.65,
                //left: MediaQuery.of(context).size.width * 0.35,
                width: 300,
                right: MediaQuery.of(context).size.width * 0.1,
                child: Container(
                  padding: EdgeInsets.only(bottom: 5),
                  width: 250,
                  child: Text(
                    'Entre em sua conta',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.kanit(
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                      color: Color.fromRGBO(84, 204, 11, 1),
                    ),
                  ),
                )),
            Container(
              width: 305,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(7),
                ),
                color: Color.fromRGBO(235, 235, 235, 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    input('Matrícula', TextInputType.number, false,
                        matriculacontroller),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 225,
                          child: input('Senha', TextInputType.text,
                              showPassword, senhacontroller),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Switcher(
                            animationDuration: Duration(milliseconds: 500),
                            value: false,
                            size: SwitcherSize.small,
                            switcherButtonRadius: 40,
                            switcherRadius: 10,
                            enabledSwitcherButtonRotate: true,
                            iconOff: Icons.lock,
                            iconOn: Icons.lock_open,
                            colorOff: Colors.redAccent.withOpacity(0.8),
                            colorOn: Color.fromRGBO(84, 204, 11, 1),
                            onChanged: (bool state) {
                              SchedulerBinding.instance
                                  .addPostFrameCallback((_) {
                                setState(() {
                                  showPassword = !state;
                                });
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 40,
                      width: 320,
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                          elevation: 4.0,
                          splashColor: Colors.green,
                          color: Color.fromRGBO(84, 204, 11, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(7.0)),
                          onPressed: () async {
                            if (matriculacontroller.value.text.isEmpty ||
                                senhacontroller.value.text.isEmpty) {
                              _scaffoldKey.currentState.showSnackBar(
                                  new SnackBar(
                                      duration: Duration(seconds: 1),
                                      backgroundColor: Colors.red,
                                      content: new Text('Há campos vazios')));
                            } else {
                              bool auth = await authUser(
                                  matriculacontroller.value.text,
                                  senhacontroller.value.text);
                              if (auth == true) {
                                _scaffoldKey.currentState.showSnackBar(
                                    new SnackBar(
                                        duration: Duration(seconds: 1),
                                        backgroundColor: Colors.green,
                                        content: new Text(
                                            'Login Realizado com sucesso')));
                                Navigator.of(context)
                                    .pushReplacement(PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      HomeScreen(),
                                  transitionDuration:
                                      Duration(milliseconds: 750),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    animation = CurvedAnimation(
                                        curve: Curves.ease, parent: animation);
                                    return Align(
                                      child: SizeTransition(
                                        sizeFactor: animation,
                                        child: child,
                                        axisAlignment: 1.5,
                                      ),
                                    );
                                  },
                                ));
                              } else {
                                _scaffoldKey.currentState.showSnackBar(
                                    new SnackBar(
                                        duration: Duration(seconds: 1),
                                        backgroundColor: Colors.red,
                                        content: new Text(
                                            'Matrícula e/ou Senha inválidas')));
                              }
                            }
                          },
                          child: Text(
                            'Entrar',
                            style: GoogleFonts.kanit(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                            ),
                          )),
                    ),
                    Divider(color: Colors.black38, height: 2),
                    SizedBox(
                      height: 20,
                      child: FlatButton(
                          splashColor: Color.fromRGBO(84, 204, 11, 1),
                          color: Colors.transparent,
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacement(_createRoute());
                          },
                          child: Text(
                            'Não tem conta? Cadastre-se aqui',
                            style: GoogleFonts.kanit(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Color.fromRGBO(84, 204, 11, 1),
                            ),
                          )),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              right: MediaQuery.of(context).size.width * 0.77,
              top: MediaQuery.of(context).size.height * 0.89,
              child: Padding(
                padding: EdgeInsets.only(bottom: 5.0, left: 5.0),
                child: Image.asset('images/QrBottomLeft.png'),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.77,
              top: MediaQuery.of(context).size.height * 0.89,
              child: Padding(
                padding: EdgeInsets.only(bottom: 5.0, right: 5.0),
                child: Image.asset('images/QrBottomRight.png'),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => CreateUser(),
    transitionDuration: Duration(milliseconds: 750),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      animation = CurvedAnimation(curve: Curves.ease, parent: animation);
      return Align(
        child: SizeTransition(
          sizeFactor: animation,
          child: child,
          axisAlignment: 1.5,
        ),
      );
    },
  );
}

Widget input(label, TextInputType keyboardType, value,
    TextEditingController controller) {
  return Container(
    height: 40,
    width: 280,
    child: TextField(
      controller: controller,
      obscureText: value,
      decoration: InputDecoration(
        labelText: "$label",
        labelStyle: GoogleFonts.kanit(
            fontSize: 16, fontWeight: FontWeight.w300, color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: Color.fromRGBO(84, 204, 11, 1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: Colors.black12,
          ),
        ),
      ),
      keyboardType: keyboardType,
    ),
  );
}
