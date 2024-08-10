import 'package:flutter/material.dart';
import 'package:regatta_app/models/meldung.dart';
import 'package:regatta_app/widgets/clickable_listtile.dart';
import 'package:regatta_app/widgets/easy_future_builder.dart';

class MeldungWahl extends StatefulWidget {
  final String rennId;
  final List<Meldung> meldungLS;
  final void Function(Meldung)? onTap;
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
          String athletenStr = meldung.athletenStr();
          String abgemeldet = meldung.abgemeldet ? "Ja" : "Nein";
          debugPrint(athletenStr);

          // TODO: Add If-Statement to catch Meldungen with Endzeit
          return ClickableListTile(
            title: "Start-Nr: ${meldung.startNr} - ${meldung.verein!.kurzform}",
            subtitle:
                "$athletenStr\nStartberechtigt: ${meldung.isStartBer()} - Leichtgewicht: ${meldung.isLeichtGW()} - Abgemeldet: $abgemeldet",
            onTap: () =>
                widget.onTap != null ? widget.onTap!(meldung) : null,
          );
        },
      );
    });
  }
}

