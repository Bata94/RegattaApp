import 'package:flutter/material.dart';
import 'package:regatta_app/models/pause.dart';
import 'package:regatta_app/models/rennen.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/easy_future_builder.dart';
import 'package:regatta_app/widgets/text_btn.dart';

class Pausen extends StatefulWidget {
  const Pausen({super.key});

  @override
  State<Pausen> createState() => _PausenState();
}

class _PausenState extends State<Pausen> {
  List<Rennen> rennen = [];
  List<Pause> pausen = [];
  bool dataFetched = false;

  Future<bool> fetchData() async {
    List<Rennen> fetchedRennen = await fetchRennenAll();
    List<Pause> fetchedPausen = await fetchAllPausen();

    setState(() {
      rennen = fetchedRennen;
      pausen = fetchedPausen;
      dataFetched = true;
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (!dataFetched) {
      return BaseLayout(
        "Regatta Pausen",
        easyFutureBuilder(
          fetchData(),
          (val) {
            if (!val) {
              return const Center(child: Text("Error!"),);
            } else {
              return const Center(child: Text("Redirect should be coming..."),);
            }
          }
        ),
      );
    } else {
      List<Widget> body = [
        txtBtn(context, "Neue Pause", () {}),
      ];



      return BaseLayout(
        "Regatta Pausen",
        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            width: double.infinity,
            child: Column(
              children: body,
            ),
          ),
        ),
      );
    } 
  }
}
