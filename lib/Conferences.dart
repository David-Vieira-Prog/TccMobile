import 'package:confpatapp/UniqueConference.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                height: 110,
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
                            padding: EdgeInsets.only(right: 5, top: 5),
                            child: Text(
                                'Data: ' + snapshot.data["data"][index]['Data'],
                                style: GoogleFonts.kanit(
                                    fontSize: 20,
                                    color: (index % 2 == 0)
                                        ? Colors.white
                                        : Color.fromRGBO(84, 204, 11, 1),
                                    fontWeight: FontWeight.w300)))
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
                        FlatButton(
                            color: (index % 2 == 0)
                                ? Color.fromRGBO(84, 204, 11, 1)
                                : Colors.white,
                            onPressed: () {
                              {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UniqueConference(
                                              snapshot.data["data"][index]
                                                  ['Idconferencia'],
                                            )));
                              }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(7.0)),
                            child: Text('Iniciar',
                                style: GoogleFonts.kanit(
                                    fontSize: 20,
                                    color: (index % 2 == 0)
                                        ? Colors.white
                                        : Color.fromRGBO(84, 204, 11, 1),
                                    fontWeight: FontWeight.w300)))
                      ],
                    )
                  ],
                )),
          );
        });
  }
}
