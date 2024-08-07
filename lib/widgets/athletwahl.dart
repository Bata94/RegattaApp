import 'package:flutter/material.dart';
import 'package:regatta_app/models/athlet.dart';
import 'package:regatta_app/widgets/clickable_listtile.dart';

class AthletWahl extends StatefulWidget {
  final List<Athlet> athletLs;
  final void Function(Athlet) onTap;
  const AthletWahl({
    super.key,
    required this.athletLs,
    required this.onTap,
  });

  @override
  State<AthletWahl> createState() => _AthletWahlState();
}

class _AthletWahlState extends State<AthletWahl> {
  @override
  Widget build(BuildContext context) {
    List<Athlet> athletLs = widget.athletLs;

    return ListView.builder(
      itemCount: athletLs.length,
      itemBuilder: (context, i) {
        Athlet athlet = athletLs[i];

        return ClickableListTile(
          title: athlet.toString(),
          onTap: () => widget.onTap(athlet),
        );
      },
    );
  }
}

class AthletWithFirstRaceWahl extends StatefulWidget {
  final List<AthletWithFirstRace> athletLs;
  final void Function(AthletWithFirstRace) onTap;
  const AthletWithFirstRaceWahl({
    super.key,
    required this.athletLs,
    required this.onTap,
  });

  @override
  State<AthletWithFirstRaceWahl> createState() => _AthletWithFirstRaceWahlState();
}

class _AthletWithFirstRaceWahlState extends State<AthletWithFirstRaceWahl> {
  @override
  Widget build(BuildContext context) {
    List<AthletWithFirstRace> athletLs = widget.athletLs;

    return ListView.builder(
      itemCount: athletLs.length,
      itemBuilder: (context, i) {
        AthletWithFirstRace athletWithFirstRace = athletLs[i];

        return ClickableListTile(
          title: athletWithFirstRace.athlet.toString(),
          subtitle: "Erster Start: ${athletWithFirstRace.firstRace.tag.toUpperCase()} - ${athletWithFirstRace.firstRace.startZeit} #${athletWithFirstRace.firstRace.nummer} - ${athletWithFirstRace.firstRace.bezeichnung}",
          onTap: () => widget.onTap(athletWithFirstRace),
        );
      },
    );
  }
}

