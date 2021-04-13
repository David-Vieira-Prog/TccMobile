import 'package:confpatapp/Conferences.dart';
import 'package:confpatapp/PatrimonioConferencia.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class UniqueConference extends StatefulWidget {
  int idConferencia;
  int codSetor;
  dynamic tombamento;
  UniqueConference(this.idConferencia, this.codSetor);
  @override
  _UniqueConferenceState createState() => _UniqueConferenceState();
}

class _UniqueConferenceState extends State<UniqueConference> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future myfunction;
  String currentSala = '';
  int quantidade;
  final tombamentocontroller = TextEditingController();
  @override
  void initState() {
    super.initState();
    myfunction = getUniqueConference();
  }

  Future getUniqueConference() async {
    http.Response response;
    response = await http.get(
        "https://apiconfpat.herokuapp.com/api/getUniqueConference/${widget.idConferencia}");
    return json.decode(response.body);
  }

  Future closeConference(var dataclose) async {
    var url =
        "https://apiconfpat.herokuapp.com/api/closeconference/${widget.idConferencia}";
    var response = await http.post(url, body: {'DataClose': '$dataclose'});
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Conferences(widget.codSetor)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Conferences(widget.codSetor)));
            },
          ),
          backgroundColor: Color.fromRGBO(84, 204, 11, 1),
          title: Text(
            'Conferência',
            style: GoogleFonts.kanit(
              fontSize: 20,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                  future: myfunction,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Center(
                                child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color.fromRGBO(84, 204, 11, 1)),
                            )));
                      default:
                        currentSala = snapshot.data["data"][0]['Sala'];
                        quantidade = snapshot.data["Quantidade"];
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width * 0.25,
                          color: Color.fromRGBO(84, 204, 11, 1),
                          child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          'Setor: ' +
                                              snapshot.data["data"][0]
                                                  ['NomeSetor'],
                                          style: GoogleFonts.kanit(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300)),
                                      Text(
                                          'Sala: ' +
                                              snapshot.data["data"][0]['Sala'],
                                          style: GoogleFonts.kanit(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300))
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text('Patrimônios: ',
                                              style: GoogleFonts.kanit(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300)),
                                          FlatButton(
                                              color: Colors.transparent,
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                {
                                                  mymodal(context, snapshot);
                                                }
                                              },
                                              child: Icon(Ionicons.md_eye,
                                                  color: Colors.white))
                                        ],
                                      ),
                                      Text(
                                          'Quantidade: ${snapshot.data["Quantidade"]}',
                                          style: GoogleFonts.kanit(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300))
                                    ],
                                  )
                                ],
                              )),
                        );
                    }
                  }),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.2),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FlatButton(
                        splashColor: Color.fromRGBO(84, 204, 11, 1),
                        onPressed: () async {
                          scan(currentSala, _scaffoldKey);
                        },
                        child: Lottie.network(
                          'https://assets2.lottiefiles.com/packages/lf20_bJCmvw.json',
                          repeat: true,
                          width: 250,
                          height: 250,
                        ),
                      ),
                      Text(
                          'Ao apertar, aponte a sua câmera para o patrimônio desejado.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.kanit(
                              fontSize: 20,
                              color: Color.fromRGBO(84, 204, 11, 1),
                              fontWeight: FontWeight.w300)),
                      Text('Ou',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.kanit(
                              fontSize: 20,
                              color: Color.fromRGBO(84, 204, 11, 1),
                              fontWeight: FontWeight.w300)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                              height: 40,
                              width: 220,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: tombamentocontroller,
                                decoration: InputDecoration(
                                  labelText: "Número de Tombamento",
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
                              )),
                          RaisedButton(
                              onPressed: () async {
                                if (tombamentocontroller.text.isNotEmpty) {
                                  Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        PatrimonioConferencia(
                                            tombamentocontroller.value.text,
                                            currentSala,
                                            widget.idConferencia,
                                            widget.codSetor),
                                    transitionDuration:
                                        Duration(milliseconds: 750),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      animation = CurvedAnimation(
                                          curve: Curves.ease,
                                          parent: animation);
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
                                          content: new Text('Campo vazio!')));
                                }
                              },
                              elevation: 4,
                              color: Color.fromRGBO(84, 204, 11, 1),
                              child: Text('Pesquisar',
                                  style: GoogleFonts.kanit(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300)))
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: RaisedButton(
                            onPressed: () {
                              showAlertDialog(context);
                            },
                            elevation: 4,
                            color: Colors.redAccent,
                            child: Text('Finalizar',
                                style: GoogleFonts.kanit(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300))),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  showAlertDialog(BuildContext context) {
    Widget cancelar = FlatButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text(
        "Cancelar",
        style: GoogleFonts.kanit(
          color: Colors.redAccent,
          fontSize: 17,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
    Widget ok = FlatButton(
      onPressed: () async {
        final f = new DateFormat('yyyy-MM-dd HH:mm:ss', 'pt');
        await closeConference(f.format(DateTime.now()));
      },
      child: Text(
        "Continuar",
        style: GoogleFonts.kanit(
          color: Color.fromRGBO(84, 204, 11, 1),
          fontSize: 17,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
    AlertDialog alerta = AlertDialog(
      title: Text(
        'Confirmação',
        style: GoogleFonts.kanit(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.w300,
        ),
      ),
      content: quantidade != 0
          ? Text(
              "Ainda restam $quantidade  patrimônios",
              style: GoogleFonts.kanit(
                fontSize: 17,
                color: Colors.black,
                fontWeight: FontWeight.w300,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SafeArea(
                  child: Text(
                    "Todos os patrimônios\n foram conferidos",
                    style: GoogleFonts.kanit(
                      fontSize: 17,
                      color: Color.fromRGBO(84, 204, 11, 1),
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Icon(Icons.done_all, color: Colors.green),
              ],
            ),
      actions: [cancelar, ok],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alerta;
        });
  }

  Future<void> scan(String sala, GlobalKey<ScaffoldState> _scaffoldKey) async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      await FlutterBarcodeScanner.scanBarcode(
              "#000000", "Cancelar", true, ScanMode.QR)
          .then((value) => value == '-1'
              ? _scaffoldKey.currentState.showSnackBar(new SnackBar(
                  duration: Duration(seconds: 1),
                  backgroundColor: Colors.red,
                  content: new Text('Nada foi escaneado')))
              : Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      PatrimonioConferencia(
                          value, sala, widget.idConferencia, widget.codSetor),
                  transitionDuration: Duration(milliseconds: 750),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    animation =
                        CurvedAnimation(curve: Curves.ease, parent: animation);
                    return Align(
                      child: SizeTransition(
                        sizeFactor: animation,
                        child: child,
                        axisAlignment: 1.5,
                      ),
                    );
                  },
                )));
    } on PlatformException {
      SnackBar(
          content: Text('Erro ao escanear patrimônio',
              style: GoogleFonts.kanit(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w300)),
          backgroundColor: Colors.red);
    }
  }
}

void mymodal(context, AsyncSnapshot snapshot) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        child: ListView.builder(
          padding: EdgeInsets.all(7),
          itemCount: snapshot.data["Patrimonios"].length,
          itemBuilder: (context, index) {
            return ExpansionTile(
              leading: snapshot.data["Patrimonios"][index]["Verificado"] == true
                  ? Icon(MaterialIcons.done, color: Colors.green)
                  : Icon(MaterialIcons.clear, color: Colors.red),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              title: Text(
                ' ${snapshot.data["Patrimonios"][index]["Denominacao"]}',
                style: GoogleFonts.kanit(
                  fontSize: 15,
                  color: Color.fromRGBO(84, 204, 11, 1),
                  fontWeight: FontWeight.w300,
                ),
              ),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Número de tombamento: ${snapshot.data["Patrimonios"][index]["CodPatrimonio"]}',
                        style: GoogleFonts.kanit(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        'Data de garantia: ${snapshot.data["Patrimonios"][index]["DataGarantia"]}',
                        style: GoogleFonts.kanit(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        'Marca: ${snapshot.data["Patrimonios"][index]["Marca"]}',
                        style: GoogleFonts.kanit(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        'Estado: ${snapshot.data["Patrimonios"][index]["Estado"]}',
                        style: GoogleFonts.kanit(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      );
    },
  );
}
