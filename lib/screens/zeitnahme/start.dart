// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:regatta_app/models/athlet.dart';
import 'package:regatta_app/models/meldung.dart';
import 'package:regatta_app/models/rennen.dart';
import 'package:regatta_app/models/zeitnahme.dart';
import 'package:regatta_app/screens/leiter/startnummernvergabe.dart';
import 'package:regatta_app/services/audio_controller.dart';
import 'package:regatta_app/widgets/abteilungwahl.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/dialog.dart';
import 'package:regatta_app/widgets/loading_spinner.dart';
import 'package:regatta_app/widgets/meldungwahl.dart';
import 'package:regatta_app/widgets/nav_bar.dart';
import 'package:regatta_app/widgets/rennwahl.dart';
import 'package:uuid/uuid.dart';

class ZeitnahmeStart extends StatefulWidget {
  const ZeitnahmeStart({super.key});

  @override
  State<ZeitnahmeStart> createState() => _ZeitnahmeStartState();
}

class _ZeitnahmeStartState extends State<ZeitnahmeStart> {
  // TODO: Move Compute and State Mgt to Provider!
  // late ZeitnahmeStartProvider zeitnahmeStartProvider;
  late AudioController audioController;

  int numBahnen = 1;
  double bahnenWidgetHeight = 500;

  Rennen? aktRennen;
  int? aktAbteilung;
  String aktWettkampf = "Langstrecke";
  int maxBahnen = 4;
  Map<int, Meldung?> bahnenMap = {0: null};

  void restetBahnenAsignment() {
    int i = 0;
    bahnenMap = {};

    while (i < numBahnen) {
      bahnenMap[i] = null;
      i++;
    }

    setState(() {});
  }

  void _startRennenBtn() async {
    if (aktRennen == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Kein Rennen gewählt"),
          content: const Text(
            "Es ist kein Rennen ausgewählt und somit auch keine Meldungen. So kann ein Rennen leider nicht gestartet werden!",
          ),
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

    List<Meldung> meldungLs = [];

    for (MapEntry meld in bahnenMap.entries) {
      if (meld.value != null) {
        meldungLs.add(meld.value);
      }
    }

    // zeitnahmeStartProvider.newStart(
    //   meldungen: meldungLs,
    //   rennNr: aktRennen!.rennNr,
    // );
    audioController.playAirHorn();
    List<String> startNummern = [];

    for (Meldung meld in meldungLs) {
      startNummern.add(meld.startNr.toString());
    }

    bool sucess = await postStart(aktRennen!.nummer, startNummern);
    if (!sucess) {
      dialogError(
      context, "Error", "Rennen nicht übermittelt!");
    }

    // TODO: Add Startabbruch abfrage

    for (MapEntry meld in bahnenMap.entries) {
      if (meld.value != null) {
        aktRennen!.meldungen
            .removeWhere((element) => element.uuid == meld.value.uuid);
      }
    }

    for (var i = 0; i < numBahnen; i++) {
      bahnenMap[i] = null;
    }

    setState(() {});
  }

  void _testToneBtn() {
    debugPrint("Test Ton");
    audioController.playAirHorn();
  }

  Widget _rennenListView(String wettkampfIdentifier) {
    void selectAbteilung(String rennenId) async {
      showDialog(
        context: context,
        builder: (context) {
          return loadingSpinner(context);
        },
      );

      Rennen rennen = await fetchRennen(
        rennenId,
        // meldungInfo: true,
        // getStarted: false,
      );
      Navigator.of(context).pop();

      if (rennen.numAbteilungen <= 1) {
        numBahnen = 0;
        restetBahnenAsignment();

        if (wettkampfIdentifier == "Langstrecke") {
          bahnenMap[0] = rennen.meldungen[0];
          numBahnen = 1;
        } else {
          for (Meldung meldung in rennen.meldungen) {
            bahnenMap[numBahnen] = meldung;
            numBahnen++;
          }
        }

        numBahnen == 0 ? numBahnen = 1 : null;

        setState(() {
          aktRennen = rennen;
          aktAbteilung = rennen.numAbteilungen;
          aktWettkampf = rennen.wettkampf;
        });

        Navigator.of(context).pop();
        return;
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Scaffold(
                appBar: NavBar(
                  context,
                  title: "Abteilung auswählen",
                ),
                body: AbteilungWahl(
                  rennUuid: rennenId,
                  getStarted: false,
                  onAbteilungTap: (abteilung) {
                    numBahnen = 0;
                    restetBahnenAsignment();

                    for (Meldung meldung in rennen.meldungen) {
                      if (meldung.abteilung == abteilung) {
                        bahnenMap[numBahnen] = meldung;
                        numBahnen++;
                      }
                    }

                    numBahnen == 0 ? numBahnen = 1 : null;

                    setState(() {
                      aktRennen = rennen;
                      aktAbteilung = abteilung;
                      aktWettkampf = rennen.wettkampf;
                    });

                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            );
          },
        );
      }
    }

    return RennenWahl(
      wettkampfIdentifier: wettkampfIdentifier,
      getStartedMeldungen: false,
      onTap: (rennen) => selectAbteilung(rennen.uuid),
    );
  }

  void _rennenWahlBtn() {
    int initIndex = 0;

    switch (aktWettkampf) {
      case "Langstrecke":
        initIndex = 0;
        break;
      case "Slalom":
        initIndex = 1;
        break;
      case "Kurzstrecke":
        initIndex = 2;
        break;
      case "Staffel":
        initIndex = 3;
        break;
      default:
        initIndex = 0;
        break;
    }

    showDialog(
      context: context,
      builder: (context) {
        return DefaultTabController(
          length: 4,
          initialIndex: initIndex,
          child: Scaffold(
            appBar: NavBar(
              context,
              title: "ZeitnahmeStart - Rennenwahl",
              bottom: TabBar(
                tabs: [
                  Tab(
                    child: Text(
                      "Langstrecke",
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Colors.white,
                              ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Slalom",
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Colors.white,
                              ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Kurzstrecke",
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Colors.white,
                              ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Staffel",
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Colors.white,
                              ),
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _rennenListView("Langstrecke"),
                _rennenListView("Slalom"),
                _rennenListView("Kurzstrecke"),
                _rennenListView("Staffel"),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _rennenWahl() {
    Widget body() {
      if (aktRennen == null || aktAbteilung == null) {
        return Center(
          child: Text(
            "Kein Rennen ausgewählt!\nHier Klicken um eins auszuwählen.",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        );
      } else {
        Rennen rennen = aktRennen!;
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Rennen-Nummer:",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  rennen.nummer.toString(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  "Abteilung:",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  "$aktAbteilung von ${rennen.numAbteilungen}",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            const Divider(),
            Text(
              "${rennen.bezeichnung} ${rennen.zusatz}",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        );
      }
    }

    return GestureDetector(
      onTap: _rennenWahlBtn,
      child: Card(
        elevation: 16,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            width: MediaQuery.of(context).size.width * .8,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 20.0,
            ),
            child: body(),
          ),
        ),
      ),
    );
  }

  Widget _bahnenWidget() {
    void addBahnBtn() {
      if (numBahnen >= maxBahnen) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Kann keine weiteren Bahnen hinzufügen!",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              content: const Text(
                "Es können nicht mehr als 4 Bahnen hinzugefügt werden! Sollte dies ein Problem darstellen wenden Sie sich bitte an den Administrator!",
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    "Okay",
                  ),
                ),
              ],
            );
          },
        );
        return;
      }

      setState(() {
        numBahnen++;
      });
    }

    void removeBahnBtn() {
      if (numBahnen <= 1) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Kann die letzte Bahn nicht entfernen!",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              content: const Text(
                "Es kann die letzte Bahn nicht entfernt werden! Logischerweise muss ein Rennen mit mindestens einem Teilnehmer gestartet werden.",
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    "Okay",
                  ),
                ),
              ],
            );
          },
        );
        return;
      }

      setState(() {
        numBahnen--;
        bahnenMap[numBahnen] = null;
      });
    }

    void meldungWahlBtn(int bahnNumber) {
      if (aktRennen == null) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Kein Rennen gewählt!",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              content: const Text(
                "Bitte wählen Sie zuerst ein Rennen aus, bevor Sie eine Bahn zuweisen können! Um dies zu umgehen wechseln Sie in den freien Startmodus.",
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    "Okay",
                  ),
                ),
              ],
            );
          },
        );
        return;
      }

      List<Meldung> choosableMeldungen = [];

      debugPrint("Aktuelles Rennen: $aktRennen");

      for (Meldung meld in aktRennen!.meldungen) {
        bool inBahnen = false;

        for (int i in bahnenMap.keys) {
          if (bahnenMap[i] != null && bahnenMap[i]!.uuid == meld.uuid) {
            inBahnen = true;
            break;
          }
        }

        if (!inBahnen) {
          choosableMeldungen.add(meld);
        }
      }

      if (choosableMeldungen.isEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Keine Meldungen gefunden!",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              content: const Text(
                "Es wurden keine weitere Meldung zu diesem Rennen gefunden! Um dies zu umgehen wechseln Sie in den freien Startmodus.",
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    "Okay",
                  ),
                ),
              ],
            );
          },
        );
        return;
      }

      showDialog(
        context: context,
        builder: (context) {
          for (var meld in choosableMeldungen) {
            meld.rennen = aktRennen!;            
          }

          return Dialog(
            child: Scaffold(
                appBar: NavBar(
                  context,
                  title: "Meldung auswählen",
                ),
                body: Column(
                  children: [
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: Center(
                      child: ElevatedButton(
                        child: const Text("Manuelle Eingabe"),
                        onPressed: () async {
                        // Manuelle Eingabe 
                        Navigator.of(context).pop();
                        showDialog(context: context, builder: (context) {
                            TextEditingController startNummerController = TextEditingController();
                            var uuid = Uuid();
                            uuid.v4();

                            return AlertDialog(
                                title: const Text("Manuelle Eingabe:", textAlign: TextAlign.center,),
                                content: SizedBox(
                                  height: 100,
                                  width: 400,
                                  child: TextField(
                                    autofocus: true,
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
                                    Meldung meld = Meldung(
                                      uuid: uuid.toString(), 
                                      startNr: int.parse(startNummerController.text),
                                      rennNr: '0',
                                      abgemeldet: false,
                                      dns: false,
                                      dsq: false,
                                      dnf: false,
                                      meldungstyp: "temp",
                                      vereinUuid: "",
                                      rennenUuid: "",
                                    );
                                    setState(() {
                                      bahnenMap[bahnNumber - 1] = meld;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Bestaetigen"),
                                  ),
                                ],
                              );
                            }
                          );
                        },
                        ),
                      ),
                    ),
                    Expanded(
                      child: MeldungWahl(
                        rennId: aktRennen!.uuid,
                        meldungLS: choosableMeldungen,
                        onTap: (meldung) {
                          Meldung? choosenMeldung;
                      
                          for (Meldung meld in choosableMeldungen) {
                            if (meldung.uuid == meld.uuid) {
                              choosenMeldung = meld;
                            }
                          }
                      
                          setState(() {
                            bahnenMap[bahnNumber - 1] = choosenMeldung;
                          });
                      
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                )),
          );
        },
      );
    }

    Widget bahnWidget(int bahnNummer, {Meldung? meldung}) {
      TableRow tableRow(String title, String content) {
        double padVert = 2.0;
        double padHor = 2.0;

        return TableRow(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: padVert,
                horizontal: padHor,
              ),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: padVert,
                horizontal: padHor,
              ),
              child: Text(
                content,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ],
        );
      }

      void dnsBtn(String meldId) {
        // TODO: Implement
        debugPrint("dnsBtn meldID: $meldId");
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Funktion noch nicht hinzugefügt!",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              content: const Text(
                "Diese Funktion wurde noch nicht hinzugefügt oder freigeschaltet!",
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    "Okay",
                  ),
                ),
              ],
            );
          },
        );
      }

      void dsqBtn(String meldId) {
        // TODO: Implement
        debugPrint("dsqBtn meldID: $meldId");
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Funktion noch nicht hinzugefügt!",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              content: const Text(
                "Diese Funktion wurde noch nicht hinzugefügt oder freigeschaltet!",
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    "Okay",
                  ),
                ),
              ],
            );
          },
        );
      }

      Widget body = Center(
        child: Text(
          "Keine Meldung gewählt!",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );

      if (meldung != null) {
        List<TableRow> tableRowLS = [
          tableRow("Start-Nr:", meldung.startNr.toString()),
          tableRow("Verein:", meldung.verein == null ? "unknown" : meldung.verein!.kuerzel),
          tableRow("", meldung.verein == null ? "unknown" : meldung.verein!.kurzform),
          tableRow("Startber.:", meldung.isStartBer()),
          tableRow("LGW:", meldung.isLeichtGW()),
          // TODO: Add Teilnehmer
          tableRow("Teiln.:", ""),
        ];

        int i = 1;

        // TODO: Teilnehmer Reihenfolge/Positionen
        if (meldung.athlets.isNotEmpty) {
          for (Athlet teilnehmer in meldung.athlets.reversed) {
            tableRowLS.add(
              tableRow(
                i == 5 ? "Stm:" : "# $i:",
                teilnehmer.toString(),
              ),
            );
            i++;
          }
        }

        body = Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(4),
          },
          children: tableRowLS,
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 8,
        ),
        child: GestureDetector(
          onTap: () => meldungWahlBtn(bahnNummer),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Card(
              elevation: 8,
              child: SizedBox(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: (MediaQuery.of(context).size.width * 0.9) / 3,
                    minHeight: bahnenWidgetHeight * 0.9,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "# $bahnNummer",
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              // ElevatedButton(
                              //   style: ButtonStyle(
                              //     backgroundColor: MaterialStatePropertyAll(
                              //         Theme.of(context).colorScheme.error),
                              //   ),
                              //   onPressed: () => dnsBtn(meldung!.id),
                              //   child: Text(
                              //     "DNS",
                              //     style: Theme.of(context)
                              //         .textTheme
                              //         .labelLarge!
                              //         .copyWith(
                              //           color: Colors.white,
                              //         ),
                              //   ),
                              // ),
                              // ElevatedButton(
                              //   style: ButtonStyle(
                              //     backgroundColor: MaterialStatePropertyAll(
                              //         Theme.of(context).colorScheme.error),
                              //   ),
                              //   onPressed: () => dsqBtn(meldung!.id),
                              //   child: Text(
                              //     "DSQ",
                              //     style: Theme.of(context)
                              //         .textTheme
                              //         .labelLarge!
                              //         .copyWith(
                              //           color: Colors.white,
                              //         ),
                              //   ),
                              // ),
                              IconButton(
                                onPressed: () => setState(() {
                                  bahnenMap[bahnNummer - 1] = null;
                                }),
                                icon: Icon(
                                  Icons.delete,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                        ],
                      ),
                      body,
                      const SizedBox(
                        height: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    List<Widget> bahnenWidLS = [];

    int i = 1;
    while (i <= numBahnen) {
      if (bahnenMap.isNotEmpty && bahnenMap.length >= i) {
        bahnenWidLS.add(bahnWidget(i, meldung: bahnenMap[i - 1]));
      } else {
        bahnenWidLS.add(bahnWidget(i));
      }

      i++;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // const Divider(
        //   thickness: 2,
        // ),
        const SizedBox(
          height: 4,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Bahnen:",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const Divider(
                thickness: 2,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _testToneBtn,
                    icon: Icon(
                      Icons.volume_up,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  IconButton(
                    onPressed: restetBahnenAsignment,
                    icon: Icon(
                      Icons.clear,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  IconButton(
                    onPressed: removeBahnBtn,
                    icon: Icon(
                      Icons.remove,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  IconButton(
                    onPressed: addBahnBtn,
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 2,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: bahnenWidLS,
            ),
          ),
        ),
        // const Divider(
        //   thickness: 2,
        // ),
      ],
    );
  }

  Widget _startBtn() {
    return GestureDetector(
      onTap: _startRennenBtn,
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
                    "Starte\nRennen!",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  Icon(
                    Icons.flag,
                    color: Colors.white,
                    size:
                        Theme.of(context).textTheme.headlineMedium!.fontSize! *
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

  Widget _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flex(
          direction: Axis.horizontal,
          children: [
            Flexible(
              flex: 28,
              child: _rennenWahl(),
            ),
            const Spacer(
              flex: 1,
            ),
            Flexible(
              flex: 12,
              child: _startBtn(),
            ),
          ],
        ),
        _bahnenWidget(),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    audioController = AudioController();
    // TODO: Check why sometimes errors on reload!
    // audioController.preloadAirHorn();
  }

  @override
  void dispose() {
    // zeitnahmeStartProvider.closeConnection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // zeitnahmeStartProvider =
    //     Provider.of<ZeitnahmeStartProvider>(context, listen: true);
    // zeitnahmeStartProvider.init();

    return BaseLayout(
      "ZeitnahmeStart",
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: _body(),
        ),
      ),
    );
  }
}

