import 'package:flutter/material.dart';
import 'package:regatta_app/models/meldung.dart';
import 'package:regatta_app/models/athlet.dart';
import 'package:regatta_app/widgets/clickable_listtile.dart';
import 'package:regatta_app/widgets/easy_future_builder.dart';

class MeldungWahl extends StatefulWidget {
  final String rennId;
  final List<Meldung> meldungLS;
  final void Function(String)? onTap;
  const MeldungWahl({
    super.key,
    required this.rennId,
    this.onTap,
    this.meldungLS = const [],
  });

  @override
  State<MeldungWahl> createState() => _MeldungWahlState();
}

class _MeldungWahlState extends State<MeldungWahl> {
  Future<List<Meldung>> fetchData(String rennId) async {
    // TODO: Impl fetch, API Route neccesary
    // RennenAuschreibung rennen = await fetchRennenAuschreibungOne(id);

    // if (rennen.meldungen.isNotEmpty) {
    //   for (Meldung meld in rennen.meldungen) {
    //     mel
    //   }
    // }
    return widget.meldungLS;
  }

  @override
  Widget build(BuildContext context) {
    return easyFutureBuilder(fetchData(widget.rennId), (data) {
      List<Meldung> meldungLs = data as List<Meldung>;

      return ListView.builder(
        itemCount: meldungLs.length,
        itemBuilder: (BuildContext context, int i) {
          Meldung meldung = meldungLs[i];

          // TODO: Athlet Reihenfolge/Positionen
          String athletStr = "";
          int t = 1;
          if (meldung.athlets != []) {
            for (Athlet athlet in meldung.athlets.reversed) {
              if (athletStr != "") {
                athletStr += " - ";
              }
              athletStr += t == 5 ? "Stm:" : "# $t: ";
              athletStr += athlet.toString();

              t++;
            }
          } else {
            athletStr = "Keine Athlet gefunden!";
          }

          // TODO: Add If-Statement to catch Meldungen with Endzeit
          return ClickableListTile(
            title: "Start-Nr: ${meldung.startNr} - ${meldung.verein!.kurzform}",
            subtitle:
                "$athletStr\nStartberechtigt: ${meldung.isStartBer()} - Leichtgewicht: ${meldung.isLeichtGW()}",
            onTap: () =>
                widget.onTap != null ? widget.onTap!(meldung.uuid) : null,
          );
        },
      );
    });
  }
}

