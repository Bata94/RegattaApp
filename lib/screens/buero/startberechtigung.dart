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

class BueroStartberechtigung extends StatefulWidget {
  const BueroStartberechtigung({super.key});

  @override
  State<BueroStartberechtigung> createState() => _BueroStartberechtigungState();
}

class _BueroStartberechtigungState extends State<BueroStartberechtigung> {
  Verein? verein;
  List<Verein> vereinLs = [];
  List<VereinWithAthleten> vereinWithAthletenLs = [];
  List<AthletWithFirstRace> athletLs = [];


  void waageDialog(AthletWithFirstRace athletWithFirstRace) {
      showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Startberechtigung für ${athletWithFirstRace.athlet.toString()}"),
        content: const Text(
            "Haben Sie die Unterlagen vollständig vorliegen und haben diese im besten Fall digital gespeichert?"),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              "Nein",
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              dialogLoading(context);

              ApiResponse res = await updateAthletStartberechtigung(
                  athletWithFirstRace.athlet.uuid, true);

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
            child: const Text("Ja"),
          ),
        ],
      ),
    );
}


  Widget body() {
    if (verein == null) {
      return easyFutureBuilder(
        fetchAllMissStartberechtigungByVerein(),
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
