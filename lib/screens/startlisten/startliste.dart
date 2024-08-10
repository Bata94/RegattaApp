import 'package:flutter/material.dart';
import 'package:regatta_app/models/rennen.dart';
import 'package:regatta_app/screens/startlisten/rennen.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/rennwahl.dart';

enum StartlisteWettkampf { all, langstrecke, slalom, kurzstrecke, staffel }

class Startliste extends StatefulWidget {
  final StartlisteWettkampf wettkampf;
  const Startliste({super.key, this.wettkampf = StartlisteWettkampf.all});

  @override
  State<Startliste> createState() => _StartlisteState();
}

class _StartlisteState extends State<Startliste> {
  List<Rennen> rennenLs = [];

  @override
  Widget build(BuildContext context) {
    StartlisteWettkampf wettkampf = widget.wettkampf;
    String wettkampfStr = "";

    switch (wettkampf) {
      case StartlisteWettkampf.langstrecke:
        wettkampfStr = "Langstrecke";
        break;
      case StartlisteWettkampf.slalom:
        wettkampfStr = "Slalom";
        break;
      case StartlisteWettkampf.kurzstrecke:
        wettkampfStr = "Kurzstrecke";
        break;
      case StartlisteWettkampf.staffel:
        wettkampfStr = "Staffel";
        break;
      default:
        wettkampfStr = "Unbekannt...";
    }

    return BaseLayout(
      "Startliste für $wettkampfStr",
      RennenWahl(
        wettkampfIdentifier: wettkampfStr.toLowerCase(),
        onTap: (rennen) => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => StartlisteRennen(rennen.uuid)),
        ),
      ),
    );
  }
}
