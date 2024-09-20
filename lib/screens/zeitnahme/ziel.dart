// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:regatta_app/models/athlet.dart';
import 'package:regatta_app/models/zeitnahme.dart';
import 'package:regatta_app/services/audio_controller.dart';
import 'package:regatta_app/provider/zeitnahme_ziel.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/clickable_listtile.dart';
import 'package:regatta_app/widgets/easy_future_builder.dart';

class ZeitnahmeZiel extends StatefulWidget {
  const ZeitnahmeZiel({super.key});

  @override
  State<ZeitnahmeZiel> createState() => _ZeitnahmeZielState();
}

class _ZeitnahmeZielState extends State<ZeitnahmeZiel> {
  late ZeitnahmeZielProvider zeitnahmeZielProvider;
  late AudioController audioController;

  List<Zeitnahme> zeitnahmeZielLS = [];

  void _zeileinlaufBtn() {
    debugPrint("New Zieleinlauf");
    zeitnahmeZielProvider.newZieleinlauf();
    audioController.playAirHorn();
  }

  void _refreshListBtn() {
    zeitnahmeZielProvider.reloadList();
  }

  void _testToneBtn() {
    audioController.playAirHorn();
  }

  void _changeStartNummerDialog(int id) {
    showDialog(
        context: context,
        builder: (context) {
        return Dialog(
            child: easyFutureBuilder(fetchOpenStarts(), (data) {
              List<Widget> bodyWidLs = [];

              List<Zeitnahme> openStarts = data;
              Map<String, Map> openStartsByRennen = {};

              for (Zeitnahme start in openStarts) {
              // String rennNr = start['rennen_nummer'];
              // String teilnehmerStr = "";
              //
              // for (Map<String, dynamic> teilnehmer in start["meldung"]
              //     ["athleten"]) {
              // Athlet teil = Athlet.fromJson(teilnehmer);
              //
              // if (teilnehmerStr != "") {
              // teilnehmerStr += " - ";
              // }
              //
              // teilnehmerStr += teil.toString();
              // }

              // Map startMap = {
              //   "id": start['id'],
              //   "start_nummer": start["start_nummer"],
              //   "teilnehmer_str": teilnehmerStr,
              //   "verein": start["meldung"]["verein"]["name"],
              // };
              //
              // if (openStartsByRennen.containsKey(rennNr)) {
              //   openStartsByRennen[rennNr]!['starts'].add(startMap);
              // } else {
              //   openStartsByRennen[rennNr] = {
              //     "rennen_nummer": rennNr,
              //     "starts": [startMap]
              //   };
              // }
                Map startMap = {
                  "id": start.id,
                  "start_nummer": start.startNummer,
                  "teilnehmer_str": "",
                  "verein": "",
                };
                String rennNr = start.rennenNummer ?? "unknown";
              if (openStartsByRennen.containsKey(rennNr)) {
                openStartsByRennen[rennNr]!['starts'].add(startMap);
              } else {
                openStartsByRennen[rennNr] = {
                  "rennen_nummer": rennNr,
                  "starts": [startMap]
                };
              }
              }

              for (String rennNr in openStartsByRennen.keys) {
                Map rennen = openStartsByRennen[rennNr]!;

                bodyWidLs.add(
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        "Rennen: $rennNr",
                        style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    );
                bodyWidLs.add(const Divider());

                for (Map start in rennen["starts"]) {
                  bodyWidLs.add(
                      ClickableListTile(
                        title:
                        "Start-Nummer ${start['start_nummer']} - ${start['verein']}",
                        subtitle: start["teilnehmer_str"],
                        onTap: () {
                        zeitnahmeZielProvider.setStartnummer(
                            id, start["start_nummer"]);
                        Navigator.of(context).pop();
                        },
                        ),
                      );
                }

                bodyWidLs.add(const Divider());
              }

              Widget _body = Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: bodyWidLs,
                  );

              return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.arrow_back,
                            color: Theme.of(context).colorScheme.primary,
                            size: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .fontSize,
                            ),
                          ),
                        Text(
                          "Offene Starts:",
                          style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ElevatedButton(
                            onPressed: () async {
                            Navigator.of(context).pop();
                            showDialog(context: context, builder: (context) {
                                TextEditingController startNummerController = TextEditingController();

                                return AlertDialog(
                                    title: const Text("Manuelle Eingabe:"),
                                    content: SizedBox(
                                      height: 400,
                                      width: 600,
                                      child: TextField(
                                        controller: startNummerController,
                                        keyboardType: TextInputType.number,
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
                                      zeitnahmeZielProvider.setStartnummer(
                                          id, startNummerController.text);
                                      Navigator.of(context).pop();
                                      },
                                      child: const Text("Bestaetigen"),
                                      ),
                                    ],
                                    );
                            });
                            },
                            child: const Text("Manuelle Eingabe"),
                          ),
                        ],
                        ),
                        const Divider(),
                        SingleChildScrollView(
                            child: _body,
                            ),
                        ],
                        ),
                        ),
                        );
            }),
        );
        });
  }

  Map<String, dynamic> zieleinlaufRow(
    Zeitnahme zeitnahme,
  ) {
    double widSmall = 50;
    double widBig = 268;

    int id = zeitnahme.id;
    DateTime time =
        zeitnahme.timeServer ??= zeitnahme.timeClient ??= DateTime(1970);

    String placeholder = "-----";
    String startNummer = zeitnahme.startNummer ??= placeholder;
    startNummer = startNummer == "" ? placeholder : startNummer;

    return {
      "id": id,
      "widget": Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: widSmall,
                  child: Text(
                    "#$id",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                GestureDetector(
                  onTap: () => _changeStartNummerDialog(id),
                  child: Card(
                    child: Container(
                      width: widBig,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Startnummer:",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            startNummer,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const Icon(Icons.edit),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: widBig,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Einlauf Zeit:",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(
                        width: 32,
                      ),
                      Text(
                        "${time.hour}:${time.minute}:${time.second}.${time.millisecond}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: widSmall,
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Zieleinlauf #$id sicher löschen?"),
                            content: Text(
                                "Sind Sie sicher, dass Sie Zieleinlauf Nummer #$id unwideruflich löschen möchten?"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Nein")),
                              ElevatedButton(
                                onPressed: () {
                                  zeitnahmeZielProvider.deleteZieleinlauf(
                                    id,
                                  );
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Ja"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(
                      Icons.delete_forever,
                      color: Theme.of(context).colorScheme.error,
                      size: 32,
                    ),
                    iconSize: 32,
                    splashRadius: 40,
                  ),
                ),
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    };
  }

  Widget _zielHist() {
    List<Widget> hist = [
      Text(
        "Verlauf:",
        style: Theme.of(context).textTheme.displaySmall,
      ),
      const Divider(),
    ];

    List<Map<String, dynamic>> widgetLS = [];

    for (Zeitnahme zeitnahme in zeitnahmeZielLS) {
      Map<String, dynamic> zeitnahmeMap = zieleinlaufRow(zeitnahme);
      widgetLS.add(zeitnahmeMap);

      hist.add(zeitnahmeMap['widget']);
    }

    return Container(
      height: double.infinity,
      width: double.infinity,
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: hist,
        ),
      ),
    );
  }

  Widget _zielBtn() {
    return GestureDetector(
      onTap: _zeileinlaufBtn,
      child: Card(
        color: Theme.of(context).primaryColor,
        elevation: 16,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            width: MediaQuery.of(context).size.width * .8,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 20.0,
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Zieleinlauf",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                  ),
                  Icon(
                    Icons.flag,
                    color: Colors.white,
                    size: Theme.of(context).textTheme.displayMedium!.fontSize! *
                        2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    audioController = AudioController();
    audioController.preloadAirHorn();
  }

  @override
  void dispose() {
    zeitnahmeZielProvider.closeConnection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    zeitnahmeZielProvider =
        Provider.of<ZeitnahmeZielProvider>(context, listen: true);
    zeitnahmeZielProvider.init();

    zeitnahmeZielLS = zeitnahmeZielProvider.zieleinlaufLS;

    return BaseLayout(
      "Zielgericht",
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 2,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _refreshListBtn,
                      child: Text(
                        "Refresh Verlauf",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    ElevatedButton(
                      onPressed: _testToneBtn,
                      child: Text(
                        "Test Ton",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: _zielBtn(),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .6,
            width: double.infinity,
            child: _zielHist(),
          )
        ],
      ),
    );
  }
}
