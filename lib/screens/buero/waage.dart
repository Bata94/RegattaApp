// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:regatta_app/models/athlet.dart';
import 'package:regatta_app/models/verein.dart';
import 'package:regatta_app/services/api_request.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/dialog.dart';
import 'package:regatta_app/widgets/easy_future_builder.dart';
import 'package:regatta_app/widgets/athletwahl.dart';
import 'package:regatta_app/widgets/vereinwahl.dart';

class BueroWaage extends StatefulWidget {
  const BueroWaage({super.key});

  @override
  State<BueroWaage> createState() => _BueroWaageState();
}

class _BueroWaageState extends State<BueroWaage> {
  Verein? verein;
  List<Verein> vereinLs = [];
  List<VereinWithAthleten> vereinWithAthletenLs = [];
  List<AthletWithFirstRace> athletLs = [];

  void waageDialog(AthletWithFirstRace athletWithFirstRace) {
    TextEditingController gewichtController =
        TextEditingController(text: athletWithFirstRace.athlet.gewicht.toString());

    List<Widget> bodyLs = [
      Text("Erster Start: ${athletWithFirstRace.firstRace.tag.toUpperCase()} - ${athletWithFirstRace.firstRace.startZeit} #${athletWithFirstRace.firstRace.nummer} - ${athletWithFirstRace.firstRace.bezeichnung}Erster"),
      const SizedBox(
        height: 12,
      ),
    ];

    bodyLs.add(Table(
      children: const [
        TableRow(
          children: [
            TableCell(
              child: Text(
                "Alter",
              ),
            ),
            TableCell(
              child: Text(
                "Jungen",
              ),
            ),
            TableCell(
              child: Text(
                "Mädchen",
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Text(
                "14 Jahre",
              ),
            ),
            TableCell(
              child: Text(
                "55 kg",
              ),
            ),
            TableCell(
              child: Text(
                "52,5 kg",
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Text(
                "13 Jahre",
              ),
            ),
            TableCell(
              child: Text(
                "50 kg",
              ),
            ),
            TableCell(
              child: Text(
                "50 kg",
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Text(
                "12 Jahre",
              ),
            ),
            TableCell(
              child: Text(
                "45 kg",
              ),
            ),
            TableCell(
              child: Text(
                "45 kg",
              ),
            ),
          ],
        ),
      ],
    ));

    bodyLs.add(
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 36,
          ),
          Text(
            "Gewicht:",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          TextField(
            controller: gewichtController,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Einwaage für ${athletWithFirstRace.athlet} - ${verein!.kuerzel}"),
        content: SizedBox(
          height: 400,
          width: 600,
          child: Column(
                children: bodyLs,
              ),
          ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              "Abbrechen",
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              late double gewicht;
              try {
                gewicht = double.parse(gewichtController.text);
              } catch (e) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(
                      "Eingabe fehlerhaft",
                    ),
                    content: const Text(
                        "Eingabe konnte nicht verarbeitet werden! Bitte überprüfen Sie die Eingabe."),
                    actions: [
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          "Okay",
                        ),
                      ),
                    ],
                  ),
                );
                return;
              }

              dialogLoading(context);

              ApiResponse res = await updateAthletGewicht(
                  athletWithFirstRace.athlet.uuid, gewicht);

              setState(() {
                athletLs.remove(athletWithFirstRace);
              });

              Navigator.of(context).pop();
              Navigator.of(context).pop();

              if (res.status) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(
                      "Erfolg",
                    ),
                    content:
                        Text("${athletWithFirstRace.athlet} wurde erfolgreich angepasst."),
                    actions: [
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          "Okay",
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                dialogError(context, res);
              }
            },
            child: const Text("Abschicken"),
          ),
        ],
      ),
    );
  }


  Widget body() {
    if (verein == null) {
      return easyFutureBuilder(
        fetchAllMissWaageByVerein(),
        (data) {
          vereinWithAthletenLs = data;
          vereinLs = [];
          for (VereinWithAthleten v in data) {
            vereinLs.add(v.verein);
          }

          return VereinWahl(
            onTap: (ver) {
              setState(() {
                verein = ver;
                for (VereinWithAthleten v in vereinWithAthletenLs) {
                  if (v.verein.uuid == ver.uuid) {
                    athletLs = v.athleten;
                  }
                }
              });
            },
            vereinLs: vereinLs,
          );
        }
      );
    }

    return AthletWithFirstRaceWahl(
      onTap: (ath) => waageDialog(ath),
      athletLs: athletLs,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout("Waage", body());
  }
}
