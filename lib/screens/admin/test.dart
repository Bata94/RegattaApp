import 'package:flutter/material.dart';
import 'package:regatta_app/models/athlet.dart';
import 'package:regatta_app/models/verein.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/easy_future_builder.dart';

class AdminTest extends StatefulWidget {
  const AdminTest({super.key});

  @override
  State<AdminTest> createState() => _AdminTestState();
}

class _AdminTestState extends State<AdminTest> {
  Widget _infoContainer(Widget child) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(12.0),
        height: MediaQuery.of(context).size.height * 0.45,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              offset: Offset(2.0, 4.0), //(x,y)
              blurRadius: 8.0,
            ),
          ],
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(16),
        ),
        child: child,
      ),
    );
  }

  Widget _infoEntryContainer(String title, subtitle, Function() onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 4.0,
            horizontal: 2.0,
          ),
          padding: const EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width * 0.21,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                offset: Offset(2.0, 4.0), //(x,y)
                blurRadius: 8.0,
              ),
            ],
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.labelMedium,),
              Text(subtitle, style: Theme.of(context).textTheme.labelSmall,),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _waageInfo() {
    return _infoContainer(
      easyFutureBuilder(
        fetchAllMissWaageByVerein(),
        (data) {
          if (data.isEmpty) {
            return const Text("Alle Athleten verwogen!");
          }

          List<Widget> vereinWidgets = [];
          List<Widget> athletWidgets = [];
          List<AthletWithFirstRace> athletenLs = [];

          for (VereinWithAthleten verein in data) {
            vereinWidgets.add(_infoEntryContainer(verein.verein.name, "${verein.athleten.length} Athleten fehlend", () {}));
            athletenLs.addAll(verein.athleten);
          }

          athletenLs.sort((a,b) => a.firstRace.sortId.compareTo(b.firstRace.sortId));

          int i = 0;
          int athLimit = 20;
          for (AthletWithFirstRace ath in athletenLs) {
            athletWidgets.add(_infoEntryContainer(ath.athlet.toString(), "Erster Start: ${ath.firstRace.tag.toUpperCase()} ${ath.firstRace.startZeit} Uhr", () {}));
            i++;
            if (i >= athLimit) {
              break;
            }
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Waage:", style: Theme.of(context).textTheme.titleMedium!.copyWith(decoration: TextDecoration.underline)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Vereine:", style: Theme.of(context).textTheme.titleSmall),
                  Text("Athleten (nächsten $athLimit):", style: Theme.of(context).textTheme.titleSmall),
                ],
              ),
              const Divider(),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.335,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: vereinWidgets,
                        ),
                      ),
                    ),
                    const VerticalDivider(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: athletWidgets,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _startberechtigungInfo() {
    return _infoContainer(
      easyFutureBuilder(
        fetchAllMissStartberechtigungByVerein(),
        (data) {
          if (data.isEmpty) {
            return const Text("Alle Athleten startberechtigt!");
          }

          List<Widget> vereinWidgets = [];
          List<Widget> athletWidgets = [];
          List<AthletWithFirstRace> athletenLs = [];

          for (VereinWithAthleten verein in data) {
            vereinWidgets.add(_infoEntryContainer(verein.verein.name, "${verein.athleten.length} Athleten fehlend", () {}));
            athletenLs.addAll(verein.athleten);
          }

          athletenLs.sort((a,b) => a.firstRace.sortId.compareTo(b.firstRace.sortId));

          int i = 0;
          int athLimit = 20;
          for (AthletWithFirstRace ath in athletenLs) {
            athletWidgets.add(_infoEntryContainer(ath.athlet.toString(), "Erster Start: ${ath.firstRace.tag.toUpperCase()} ${ath.firstRace.startZeit} Uhr", () {}));
            i++;
            if (i >= athLimit) {
              break;
            }
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Ärztliche Bescheinigungen:", style: Theme.of(context).textTheme.titleMedium!.copyWith(decoration: TextDecoration.underline)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Vereine:", style: Theme.of(context).textTheme.titleSmall),
                  Text("Athleten (nächsten $athLimit):", style: Theme.of(context).textTheme.titleSmall),
                ],
              ),
              const Divider(),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: vereinWidgets,
                      ),
                    ),
                    const VerticalDivider(),
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: athletWidgets,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _kasseInfo() {
    return _infoContainer(
      Column(
        children: [
          Text("Kasse:", style: Theme.of(context).textTheme.titleMedium!.copyWith(decoration: TextDecoration.underline)),
          const Divider(),
          _infoEntryContainer("Next Verein", "x Athleten miss", () {debugPrint("click");}),
        ],
      ),
    );
  }

  Widget _buttons() {
    Widget container(Widget child) {
      return Container(
        margin: const EdgeInsets.all(12),
        width: MediaQuery.of(context).size.width * 0.13,
        height: 72,
        child: child,
      );
    }

    Widget btn(String label, Function()? onPressed) {
      return container(
        ElevatedButton(
          onPressed: onPressed,
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      );
    }
    
    Widget spacer() {
      return container(
        const SizedBox(height: 2,),
      );
    }

    return _infoContainer(
      Column(
        children: [
          Text("Funktionen:", style: Theme.of(context).textTheme.titleMedium!.copyWith(decoration: TextDecoration.underline)),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              btn(
                "Verein Meldewesen",
                () {},
              ),
              btn(
                "Verein Athletenverwaltung",
                () {},
              ),
              btn(
                "Verein Sonstiges",
                () {},
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              btn(
                "Startnummern- wechsel",
                () {},
              ),
              btn(
                "Setzungs- änderung",
                () {},
              ),
              spacer(),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     btn(
          //       "Startnummern- wechsel",
          //       () {},
          //     ),
          //     btn(
          //       "Setzungs- änderung",
          //       () {},
          //     ),
          //     spacer(),
          //   ],
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      "Regattabüro",
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _waageInfo(),
                _startberechtigungInfo(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _kasseInfo(),
                _buttons(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
