import 'package:confpatapp/LoginUser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_shifter/mask_shifter.dart';

class CreateUser extends StatefulWidget {
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  Future createUser(matricula, nome, telefone, cpf, senha) async {
    var url = 'http://apiconfpat.herokuapp.com/api/CreateUserApi';

    var response = await http.post(
      url,
      body: {
        'matricula': '$matricula',
        'nome': '$nome',
        'telefone': '$telefone',
        'cpf': '$cpf',
        'senha': '$senha'
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else
      return false;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final matriculacontroller = TextEditingController();
  final nomecontroller = TextEditingController();
  final telefonecontroller = TextEditingController();
  final cpfcontroller = TextEditingController();
  final senhacontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(alignment: Alignment.center, children: [
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
                child: Image.asset('images/QrCodeCreateUser.png', scale: 0.1),
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
                bottom: MediaQuery.of(context).size.height * 0.695,
                //left: MediaQuery.of(context).size.width * 0.35,
                width: 300,
                right: MediaQuery.of(context).size.width * 0.1,
                child: Container(
                  padding: EdgeInsets.only(bottom: 5),
                  width: 250,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Cadastre-se',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.kanit(
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                        color: Color.fromRGBO(84, 204, 11, 1),
                      ),
                    ),
                  ),
                )),
            Container(
              width: 305,
              height: 350,
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
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      input(
                        'Matrícula',
                        TextInputType.number,
                        false,
                        matriculacontroller,
                      ),
                      input(
                        'Nome Completo',
                        TextInputType.name,
                        false,
                        nomecontroller,
                      ),
                      Container(
                        height: 40,
                        width: 280,
                        child: TextField(
                          textAlignVertical: TextAlignVertical.bottom,
                          inputFormatters: [
                            MaskedTextInputFormatterShifter(
                                maskONE: "X XXXX-XXXX", maskTWO: "X XXXX-XXXX"),
                          ],
                          controller: telefonecontroller,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: 'Telefone(9 9999-9999)',
                            hintStyle: GoogleFonts.kanit(
                              textBaseline: TextBaseline.alphabetic,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.black54,
                            ),
                            //  labelText: "Telefone",
                            labelStyle: GoogleFonts.kanit(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.black54),
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
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 280,
                        child: TextField(
                          textAlignVertical: TextAlignVertical.bottom,
                          inputFormatters: [
                            MaskedTextInputFormatterShifter(
                                maskONE: "XXX.XXX.XXX-XX",
                                maskTWO: "XXX.XXX.XXX-XX"),
                          ],
                          controller: cpfcontroller,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: 'CPF',
                            hintStyle: GoogleFonts.kanit(
                              textBaseline: TextBaseline.alphabetic,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.black54,
                            ),
                            //  labelText: "Telefone",
                            labelStyle: GoogleFonts.kanit(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.black54),
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
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      input(
                        'Senha',
                        TextInputType.text,
                        true,
                        senhacontroller,
                      ),
                      SizedBox(
                        height: 40,
                        width: 320,
                        child: RaisedButton(
                            elevation: 4.0,
                            splashColor: Colors.green,
                            color: Color.fromRGBO(84, 204, 11, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(7.0)),
                            onPressed: () async {
                              if (matriculacontroller.value.text.isEmpty ||
                                  nomecontroller.value.text.isEmpty ||
                                  telefonecontroller.value.text.isEmpty ||
                                  cpfcontroller.value.text.isEmpty ||
                                  senhacontroller.value.text.isEmpty) {
                                _scaffoldKey.currentState.showSnackBar(
                                    new SnackBar(
                                        duration: Duration(seconds: 1),
                                        backgroundColor: Colors.red,
                                        content: new Text('Há campos vazios')));
                              } else {
                                bool created = await createUser(
                                    matriculacontroller.value.text,
                                    nomecontroller.value.text,
                                    telefonecontroller.value.text,
                                    cpfcontroller.value.text,
                                    senhacontroller.value.text);
                                if (created == true) {
                                  _scaffoldKey.currentState.showSnackBar(
                                      new SnackBar(
                                          duration: Duration(seconds: 1),
                                          backgroundColor: Colors.green,
                                          content: new Text(
                                              'Cadastro realiazado com sucesso!')));
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginUser()));
                                }
                              }
                            },
                            child: Text(
                              'Cadastrar',
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
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginUser()));
                            },
                            child: Text(
                              'Já possui conta? Entre aqui',
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
          ]),
        ),
      ),
    );
  }
}

Widget input(
  label,
  TextInputType keyboardType,
  value,
  TextEditingController controller,
) {
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
