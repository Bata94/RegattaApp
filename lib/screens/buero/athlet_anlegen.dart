// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:regatta_app/models/athlet.dart';
import 'package:regatta_app/models/verein.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/clickable_listtile.dart';
import 'package:regatta_app/widgets/dialog.dart';
import 'package:regatta_app/widgets/easy_future_builder.dart';
import 'package:regatta_app/widgets/text_input.dart';
import 'package:regatta_app/widgets/vereinwahl.dart';

class BueroAthletAnlegen extends StatefulWidget {
  const BueroAthletAnlegen({super.key});

  @override
  State<BueroAthletAnlegen> createState() => _BueroAthletAnlegenState();
}

class _BueroAthletAnlegenState extends State<BueroAthletAnlegen> {
  final formKey = GlobalKey<FormState>();
  double padFormEntry = 12.0;

  List<Verein> vereinLs = [];
  Verein? verein;

  String _vorname = "";
  String _nachname = "";
  String _jahrgang = "";

  bool _aerzlicheBescheinigung = false;
  bool _geschlechtMaennlich = false;


  Widget _bodyState(BuildContext context) {
    if (vereinLs.isEmpty) {
      return easyFutureBuilder(
        fetchVereinAll(),
        (data) {
          vereinLs = data;
          return VereinWahl(
            onTap: (v) => setState(() => verein = v),
            vereinLs: data,
          );
        },
      );
    } else if (verein == null) {
      return VereinWahl(
        onTap: (v) => setState(() => verein = v),
        vereinLs: vereinLs,
      );
    } else {
      return _body();
    }
  }

  void _sendReq() async {
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return;
    }

    final FormState form = formKey.currentState!;
    form.save();

    if (_jahrgang.length != 4) {
      dialogError(context, "Ungültige Eingabe", "Die Jahrgangseingabe muss aus 4 Zeichen bestehen!");
      return;
    }
    
    Athlet? newAthlet;
    String? err;
    try {
      newAthlet = await createAthlet(
        verein!.uuid,
        _vorname,
        _nachname,
        _jahrgang,
        _geschlechtMaennlich,
        _aerzlicheBescheinigung,
      );
    } catch (e) {
      err = e.toString();
    }

    if (newAthlet == null) {
      dialogError(context, "Fehler bei Athletenanlage", err ?? "Unbekannter Fehler!");
    } else {
      dialogOkay(context, "Athlet $newAthlet erfolgreich angelegt!");
      form.reset();
      setState(() {
        _geschlechtMaennlich = false;
        _aerzlicheBescheinigung = false;
      });
    }
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ClickableListTile(
              title: verein!.name,
              subtitle: "Um Verein zu ändern hier klicken!",
              onTap: () => setState(() => verein = null),
            ),
            Form(
              key: formKey,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .7,
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.all(padFormEntry),
                      child: textField(
                        context,
                        "Vorname",
                        Icons.abc,
                        (value) => _vorname = value ?? "",
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(padFormEntry),
                      child: textField(
                        context,
                        "Nachname",
                        Icons.abc,
                        (value) => _nachname = value ?? "",
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(padFormEntry),
                      child: textField(
                        context,
                        "Jahrgang",
                        Icons.numbers,
                        (value) => _jahrgang = value ?? "",
                        txtInpType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.all(padFormEntry),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("Männlich"),
                          Switch(
                            value: _geschlechtMaennlich,
                            onChanged: (val) => setState(() {
                              _geschlechtMaennlich = val;
                            }),
                          ),
                          const Text("Weiblich"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(padFormEntry),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("Ärztliche Bescheinigung vorhanden?"),
                          Switch(
                            value: _aerzlicheBescheinigung,
                            onChanged: (val) => setState(() {
                              _aerzlicheBescheinigung = val;
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    ElevatedButton(
                      onPressed: () => _sendReq(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Abschicken",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      "Athlet anlegen",
      _bodyState(context)
    );
  }
}
