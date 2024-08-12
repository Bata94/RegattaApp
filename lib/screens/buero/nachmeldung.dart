// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:regatta_app/models/athlet.dart';
import 'package:regatta_app/models/meldung.dart';
import 'package:regatta_app/models/rennen.dart';
import 'package:regatta_app/models/verein.dart';
import 'package:regatta_app/widgets/athletwahl.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/clickable_listtile.dart';
import 'package:regatta_app/widgets/dialog.dart';
import 'package:regatta_app/widgets/easy_future_builder.dart';
import 'package:regatta_app/widgets/rennwahl.dart';
import 'package:regatta_app/widgets/text_btn.dart';
import 'package:regatta_app/widgets/vereinwahl.dart';

class BueroNachmeldung extends StatefulWidget {
  const BueroNachmeldung({super.key});

  @override
  State<BueroNachmeldung> createState() => _BueroNachmeldungState();
}

class _BueroNachmeldungState extends State<BueroNachmeldung> {
  Verein? verein;
  Rennen? rennen;
  Map<String, dynamic> athMap = {};
  bool doppeltesMeldegeldbefreiung = false;

  void sendReq() async {
    List<AthletPosition> postAth = [];
    athMap.forEach((k,v) => postAth.add(AthletPosition(v['athUuid'], k)));
    Meldung newMeld;

    dialogLoading(context);
    try {
      newMeld = await postNachmeldung(verein!.uuid, rennen!.uuid, doppeltesMeldegeldbefreiung, postAth);
    } catch (e) {
      Navigator.of(context).pop();
      dialogError(context, "Fehler beim Anlegen!", e.toString());
      return;
    }
    Navigator.of(context).pop();
    dialogOkay(context, "Meldung erfolgreich angelegt! (${newMeld.uuid})\nStartnummer ist: ${newMeld.startNr}\nAbteilung: ${newMeld.abteilung} - Bahn: ${newMeld.bahn}\nSollte Bahn: 1 gezeigt werden, sollte die Setzung manuell angepasst werden!");

    setState(() {
      athMap = {};
      doppeltesMeldegeldbefreiung = false;
    });
  }

  void chooseAth(List<Athlet> athLs, String index) {
    showDialog(context: context, builder: (context) => Dialog(
      child: AthletWahl(
        athletLs: athLs,
        onTap: (a) {
          setState(() {
            athMap[index]['athUuid'] = a.uuid;
            athMap[index]['athStr'] = a.toString();
          });
          Navigator.of(context).pop();
        }
      ),
    ));
  }

  Widget nachmeldungForm(List<Athlet> athletenLs) {
    Widget athletenForm() {
      List<Widget> formLs = [];
      int athNum = int.parse(rennen!.bootsklasse[0]);

      if (athMap.isEmpty) {
        for (var i = 1; i <= athNum; i++) {
          athMap[i.toString()] = {
            "athUuid": "",
            "athStr": "Nicht angegeben...",
          };
        }
        if (rennen!.bootsklasse.contains("+")) {
          athMap["stm"] = {
            "athUuid": "",
            "athStr": "Nicht angegeben...",
          };
        }
      }

      for (var i = 0; i < athNum; i+=2) {
        if (athNum - i - 2 < 0) {
          formLs.add(
            SizedBox(
              width: MediaQuery.of(context).size.width * .4,
              child: ClickableListTile(
                title: "${i+1}: ${athMap[(i+1).toString()]['athStr']}",
                subtitle: "Zum ändern hier klicken...",
                onTap: () => chooseAth(athletenLs, (i+1).toString()),
              ),
            ),
          );
        } else {
          formLs.add(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .4,
                  child: ClickableListTile(
                    title: "${i+1}: ${athMap[(i+1).toString()]['athStr']}",
                    subtitle: "Zum ändern hier klicken...",
                    onTap: () => chooseAth(athletenLs, (i+1).toString()),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .4,
                  child: ClickableListTile(
                    title: "${i+2}: ${athMap[(i+2).toString()]['athStr']}",
                    subtitle: "Zum ändern hier klicken...",
                    onTap: () => chooseAth(athletenLs, (i+2).toString()),
                  ),
                ),
              ],
            ),
          );
        }
      }

      if (rennen!.bootsklasse.contains("+")) {
        formLs.add(const Divider());
        formLs.add(
          SizedBox(
            width: MediaQuery.of(context).size.width * .4,
            child: ClickableListTile(
              title: "Stm.: ${athMap['stm']['athStr']}",
              subtitle: "Zum ändern hier klicken...",
              onTap: () => chooseAth(athletenLs, 'stm'),
            ),
          ),
        );
      }

      return Container(
        width: MediaQuery.of(context).size.width * .95,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        margin: const EdgeInsets.all(8),
        child: Column(
          children: formLs,  
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            ClickableListTile(
              title: "Verein: ${verein!.name}",
              subtitle: "Zum ändern hier klicken...",
              onTap: () => setState(() => verein = null),
            ),
            const Divider(),
            ClickableListTile(
              title: "Rennen: ${rennen!.nummer} - ${rennen!.bezeichnung}",
              subtitle: "Zum ändern hier klicken...",
              onTap: () => setState(() {
                athMap = {};
                rennen = null;
              }),
            ),
            const Divider(),
            Text("Teilnehmer:", style: Theme.of(context).textTheme.titleLarge),
            athletenForm(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Befreiung vom doppeltem Meldeentgeld?"),
                Switch(
                  value: doppeltesMeldegeldbefreiung,
                  onChanged: (val) => setState(() => doppeltesMeldegeldbefreiung = val),
                ),
              ],
            ),
            txtBtn(context, "Speichern", sendReq),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    if (verein == null) {
      return easyFutureBuilder(
        fetchVereinAll(),
        (data) => VereinWahl(
          onTap: (v) => setState(() => verein = v),
          vereinLs: data,
        ),
      );
    } else if (rennen == null) {
      return RennenWahl(
        onTap: (r) => setState(() => rennen = r),
      );
    } else {
      return easyFutureBuilder(
        fetchAllAthletsByVerein(verein!.uuid),
        (data) => nachmeldungForm(data),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      "Nachmeldung",
      _body(),
    );
  }
}
