import 'package:confpatapp/HomeScreen.dart';
import 'package:confpatapp/UniqueConference.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class Conferences extends StatefulWidget {
  int codSetor;
  Conferences(this.codSetor);
  @override
  _ConferencesState createState() => _ConferencesState();
}

class _ConferencesState extends State<Conferences> {
  Future myfunction;
  @override
  void initState() {
    super.initState();
    myfunction = getConferences();
  }

  Future getConferences() async {
    http.Response response;
    response = await http.get(
        "https://apiconfpat.herokuapp.com/api/getConferences/${widget.codSetor}");
    return json.decode(response.body);
  }

  Future addRegisterConference(int idconferencia) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int matricula = pref.getInt('matricula');
    final f = new DateFormat('yyyy-MM-dd HH:mm:ss', 'pt');
    var url = "https://apiconfpat.herokuapp.com/api/registerconference";
    var response = await http.post(url, body: {
      'Idconferencia': '$idconferencia',
      'Matricula': '$matricula',
      'DataInit': f.format(DateTime.now()),
      'DataClose': '',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
        backgroundColor: Color.fromRGBO(84, 204, 11, 1),
        title: Text(
          'Conferências',
          style: GoogleFonts.kanit(
            fontSize: 20,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
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
                  if (snapshot.hasError) {
                    return Center(
                        child: Text('Falha ao carregar os dados da API'));
                  }
                  if (snapshot.data["data"].length != 0) {
                    return cardConferences(context, snapshot);
                  } else {
                    return Center(
                      child: Text(
                        'Não há conferências para esse setor',
                        style: GoogleFonts.kanit(
                            fontSize: 20,
                            color: Color.fromRGBO(84, 204, 11, 1),
                            fontWeight: FontWeight.w300),
                      ),
                    );
                  }
              }
            }),
      ),
    );
  }

  Widget cardConferences(BuildContext context, AsyncSnapshot snapshot) {
    return ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 10),
        itemCount: snapshot.data["data"].length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            color: Colors.transparent,
            elevation: 4,
            child: Container(
                width: 350,
                height: 115,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(7),
                    ),
                    color: (index % 2 == 0)
                        ? Color.fromRGBO(84, 204, 11, 1)
                        : Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 5, top: 5),
                          child: Text(
                            'Setor: ' +
                                snapshot.data["data"][index]['NomeSetor'],
                            style: GoogleFonts.kanit(
                                fontSize: 20,
                                color: (index % 2 == 0)
                                    ? Colors.white
                                    : Color.fromRGBO(84, 204, 11, 1),
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(right: 5, top: 5),
                                    child: Text(
                                        'Data: ' +
                                            formatDate(snapshot.data["data"]
                                                [index]['Data']),
                                        style: GoogleFonts.kanit(
                                            fontSize: 20,
                                            color: (index % 2 == 0)
                                                ? Colors.white
                                                : Color.fromRGBO(
                                                    84, 204, 11, 1),
                                            fontWeight: FontWeight.w300))),
                                Text(
                                  formatHour(
                                      snapshot.data["data"][index]['Data']),
                                  style: GoogleFonts.kanit(
                                      fontSize: 20,
                                      color: (index % 2 == 0)
                                          ? Colors.white
                                          : Color.fromRGBO(84, 204, 11, 1),
                                      fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ))
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 5, top: 5),
                          child: Text(
                            'Sala: ' + snapshot.data["data"][index]['Sala'],
                            style: GoogleFonts.kanit(
                                fontSize: 20,
                                color: (index % 2 == 0)
                                    ? Colors.white
                                    : Color.fromRGBO(84, 204, 11, 1),
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        snapshot.data["data"][index]["Estado"] == "Pronta"
                            ? Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: RaisedButton(
                                    elevation: 4,
                                    color: (index % 2 == 0)
                                        ? Color.fromRGBO(84, 204, 11, 1)
                                        : Colors.white,
                                    onPressed: () async {
                                      await addRegisterConference(
                                          snapshot.data["data"][index]
                                              ['Idconferencia']);
                                      Navigator.of(context)
                                          .pushReplacement(PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            UniqueConference(
                                                snapshot.data["data"][index]
                                                    ['Idconferencia'],
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
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(7.0)),
                                    child: Text('Iniciar',
                                        style: GoogleFonts.kanit(
                                            fontSize: 20,
                                            color: (index % 2 == 0)
                                                ? Colors.white
                                                : Color.fromRGBO(
                                                    84, 204, 11, 1),
                                            fontWeight: FontWeight.w300))))
                            : Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: RaisedButton(
                                    elevation: 4,
                                    color: (index % 2 == 0)
                                        ? Color.fromRGBO(84, 204, 11, 1)
                                        : Colors.white,
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushReplacement(PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            UniqueConference(
                                                snapshot.data["data"][index]
                                                    ['Idconferencia'],
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
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(7.0)),
                                    child: Text('Continuar',
                                        style: GoogleFonts.kanit(
                                            fontSize: 20,
                                            color: (index % 2 == 0)
                                                ? Colors.white
                                                : Color.fromRGBO(
                                                    84, 204, 11, 1),
                                            fontWeight: FontWeight.w300))))
                      ],
                    )
                  ],
                )),
          );
        });
  }

  String formatDate(String date) {
    List<String> dates = date.split(' ');
    List<String> date1 = dates[0].split('-');
    return date1[2] + '/' + date1[1] + '/' + date1[0];
  }

  String formatHour(String date) {
    List<String> dates = date.split(' ');
    return dates[1];
  }
}
