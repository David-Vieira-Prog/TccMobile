import 'package:confpatapp/Conferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SelectSetor extends StatefulWidget {
  @override
  _SelectSetorState createState() => _SelectSetorState();
}

class _SelectSetorState extends State<SelectSetor> {
  Future myfunction;
  @override
  void initState() {
    super.initState();
    myfunction = getSetores();
  }

  Future getSetores() async {
    http.Response response;
    response =
        await http.get("https://apiconfpat.herokuapp.com/api/allsetores");
    var data = json.decode(response.body);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
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
                  } else
                    return cardSetores(context, snapshot);
              }
            }),
      ),
    );
  }
}

Widget cardSetores(context, snapshot) {
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    snapshot.data["data"][index]['nome'],
                    style: GoogleFonts.kanit(
                        fontSize: 35,
                        color: (index % 2 == 0)
                            ? Colors.white
                            : Color.fromRGBO(84, 204, 11, 1),
                        fontWeight: FontWeight.w300),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Conferences(
                                  snapshot.data["data"][index]["CodSetor"],
                                )));
                  },
                  child: Icon(
                    Icons.arrow_right,
                    size: 35,
                    color: (index % 2 == 0)
                        ? Colors.white
                        : Color.fromRGBO(84, 204, 11, 1),
                  ),
                )
              ],
            ),
          ),
        );
      });
}
