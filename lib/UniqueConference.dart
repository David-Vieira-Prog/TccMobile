import 'package:confpatapp/PatrimonioConferencia.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

// ignore: must_be_immutable
class UniqueConference extends StatefulWidget {
  int idConferencia;
  dynamic tombamento;
  UniqueConference(this.idConferencia);
  @override
  _UniqueConferenceState createState() => _UniqueConferenceState();
}

class _UniqueConferenceState extends State<UniqueConference> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future myfunction;
  String currentSala = '';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
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
                        return Center(
                            child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromRGBO(84, 204, 11, 1)),
                        ));
                      default:
                        currentSala = snapshot.data["data"][0]['Sala'];
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
                    top: MediaQuery.of(context).size.width * 0.4),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FlatButton(
                        onPressed: () async {
                          scan(currentSala, _scaffoldKey);
                        },
                        child: Image.asset('images/QrCode.png'),
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
                                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PatrimonioConferencia(tombamentocontroller.value.text, currentSala, widget.idConferencia)));

                              },
                              elevation: 4,
                              color: Color.fromRGBO(84, 204, 11, 1),
                              child: Text('Pesquisar',
                                  style: GoogleFonts.kanit(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300)))
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
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
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PatrimonioConferencia(value, sala, widget.idConferencia))));
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
                        'Data de tombamento: ${snapshot.data["Patrimonios"][index]["DataTombamento"]}',
                        style: GoogleFonts.kanit(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        'Data de tombamento: ${snapshot.data["Patrimonios"][index]["DataTombamento"]}',
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
                      Text(
                        'Finalidade: ${snapshot.data["Patrimonios"][index]["Finalidade"]}',
                        style: GoogleFonts.kanit(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        'Depreciável: ${snapshot.data["Patrimonios"][index]["Depreciavel"]}',
                        style: GoogleFonts.kanit(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        'Valor: ${snapshot.data["Patrimonios"][index]["Valor"]}',
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
