// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:regatta_app/models/athlet.dart';
import 'package:regatta_app/models/meldung.dart';
import 'package:regatta_app/models/verein.dart';
import 'package:regatta_app/widgets/athletwahl.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/clickable_listtile.dart';
import 'package:regatta_app/widgets/dialog.dart';
import 'package:regatta_app/widgets/easy_future_builder.dart';
import 'package:regatta_app/widgets/meldungwahl.dart';
import 'package:regatta_app/widgets/text_btn.dart';
import 'package:regatta_app/widgets/vereinwahl.dart';

class BueroUmmeldung extends StatefulWidget {
  const BueroUmmeldung({super.key});

  @override
  State<BueroUmmeldung> createState() => _BueroUmmeldungState();
}

class _BueroUmmeldungState extends State<BueroUmmeldung> {
  Verein? verein;
  Meldung? meldung;
  List<Meldung> meldungen = [];
  Map<String, dynamic> athMap = {};

  void sendReq() async {
    List<AthletPosition> postAth = [];
    athMap.forEach((k,v) => postAth.add(AthletPosition(v['athUuid'], k)));
    Meldung newMeld;

    dialogLoading(context);
    try {
      newMeld = await postUmmeldung(meldung!.uuid, postAth);
    } catch (e) {
      Navigator.of(context).pop();
      dialogError(context, "Fehler beim Anlegen!", e.toString());
      return;
    }
    Navigator.of(context).pop();
    dialogOkay(context, "Meldung erfolgreich geändert! (${newMeld.uuid})\nStartnummer ist: ${newMeld.startNr}\n${newMeld.athletenStr()}");

    setState(() {
      athMap = {};
      meldung = null;
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

  Widget ummeldungForm(List<Athlet> athletenLs) {
    Widget athletenForm() {
      List<Widget> formLs = [];
      int athNum = int.parse(meldung!.rennen!.bootsklasse[0]);

      if (athMap.isEmpty) {
        for (Athlet a in meldung!.athlets) {
          if (a.rolle == "Stm." && !athMap.containsKey("stm")) {
            athMap["stm"] = {
              "athUuid": a.uuid,
              "athStr": a.toString(),
            };
          } else {
            athMap[(a.position).toString()] = {
              "athUuid": a.uuid,
              "athStr": a.toString(),
            };
          }
        }
      }

      Widget athCard(String i, int athIndex) {
        const Color? sameAth = null;
        Color diffAth = Theme.of(context).colorScheme.errorContainer;
        bool sameAthBool = false;

        for (Athlet a in meldung!.athlets) {
          if (athIndex == -1 && a.rolle == "Stm." && a.uuid == athMap[i]['athUuid']) {
            sameAthBool = true;
            break;
          } else if (a.rolle == "Ruderer" && a.position == athIndex + 1 && a.uuid == athMap[i]['athUuid']) {
            sameAthBool = true;
            break;
          }
        }

        return SizedBox(
          width: MediaQuery.of(context).size.width * .4,
          child: ClickableListTile(
            title: "${i == "stm" ? "Stm." : i}: ${athMap[i]['athStr']}",
            subtitle: "Zum ändern hier klicken...",
            onTap: () => chooseAth(athletenLs, (i).toString()),
            bgColor: sameAthBool ? sameAth : diffAth,
          ),
        );
      }

      for (var i = 0; i < athNum; i+=2) {
        if (athNum - i - 2 < 0) {
          formLs.add(athCard((i+1).toString(), i));
        } else {
          formLs.add(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                athCard((i+1).toString(), i),
                athCard((i+2).toString(), i+1),
              ],
            ),
          );
        }
      }

      if (meldung!.rennen!.bootsklasse.contains("+")) {
        formLs.add(const Divider());
        formLs.add(
          athCard("stm", -1),
        );
      }

      return Container(
        width: MediaQuery.of(context).size.width * .95,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(20),
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
              title: "Startnr: ${meldung!.startNr} | Rennen: ${meldung!.rennen!.nummer} - ${meldung!.rennen!.bezeichnung} | ${verein!.name}",
              subtitle: "Zum ändern hier klicken...",
              onTap: () => setState(() {
                athMap = {};
                meldung = null;
              }),
            ),
            const Text("50% + Stm. können nach Regelwerk umgemeldet werden. Sollten mehr nötig sein, bedarf es einem guten Grund!"),
            const Text("Änderungen in der Besetzung, sind farblich markiert."),
            Text("Teilnehmer:", style: Theme.of(context).textTheme.titleLarge),
            athletenForm(),
            txtBtn(context, "Speichern", sendReq),
          ],
        ),
      ),
    );
  }

  Widget body() {
    if (verein == null) {
      return easyFutureBuilder(
        fetchVereinAll(),
        (data) {
          return VereinWahl(
            vereinLs: data,
            onTap: (v) {
              setState(() => verein = v);
            },
          );
        }
        );
      } else if (meldung == null) {
      return easyFutureBuilder(
        fetchMedlungForVerein(verein!.uuid),
        (snapshot) {
          meldungen = snapshot;

          for (Meldung meld in meldungen) {
            meld.verein = verein;
          }

          meldungen.removeWhere((meld) => meld.rennen!.bootsklasse == "1x");
          return MeldungWahl(
            rennId: "Meldungen für ${verein!.kuerzel}",
            meldungLS: meldungen,
            onTap: (meld) => setState(() => meldung = meld),
          );
        },
      );
    } else {
      return easyFutureBuilder(
        fetchAllAthletsByVerein(verein!.uuid),
        (data) => ummeldungForm(data),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout("Ummeldung", body());
  }
}
