import 'package:flutter/material.dart';
import 'package:regatta_app/models/meldung.dart';
import 'package:regatta_app/models/rennen.dart';
import 'package:regatta_app/widgets/clickable_listtile.dart';
import 'package:regatta_app/widgets/easy_future_builder.dart';

class AbteilungWahl extends StatefulWidget {
  final String rennId;
  final Function(String)? onMeldungTap;
  final Function(int)? onAbteilungTap;
  final bool getStarted;
  final bool meldungInfo;
  const AbteilungWahl({
    super.key,
    required this.rennId,
    this.onMeldungTap,
    this.onAbteilungTap,
    this.getStarted = true,
    this.meldungInfo = true,
  });

  @override
  State<AbteilungWahl> createState() => _AbteilungWahlState();
}

class _AbteilungWahlState extends State<AbteilungWahl> {
  Future<Rennen> fetchData(String rennId) async {
    return await fetchRennen(
      widget.rennId,
    );
  }

  List<Widget> _body(Rennen rennen) {
    List<Widget> abtWidLs = [];
    List<Widget> retLs = [];
    int aktAbteilung = 0;

    for (Meldung meldung in rennen.meldungen) {
      if (aktAbteilung < meldung.abteilung!) {
        retLs.add(
          GestureDetector(
            onTap: () => widget.onAbteilungTap != null
                ? widget.onAbteilungTap!(meldung.abteilung! - 1)
                : null,
            child: Column(children: abtWidLs),
          ),
        );
        abtWidLs = [];

        aktAbteilung = meldung.abteilung!;
        abtWidLs.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Abteilung $aktAbteilung:",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
        );
        abtWidLs.add(const Divider(
          indent: 8,
          endIndent: 8,
        ));
      }

      Widget meldungWidget = Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClickableListTile(
          title:
              "${meldung.startNr} - ${meldung.verein!.kurzform} | Abteilung ${meldung.abteilung} Bahn ${meldung.bahn}",
          subtitle: "Teilnehmer: ${meldung.athletenStr()}",
        ),
      );

      abtWidLs.add(
        widget.onMeldungTap != null
            ? GestureDetector(
                onTap: () => widget.onMeldungTap!(meldung.uuid),
                child: meldungWidget,
              )
            : meldungWidget,
      );
    }

    Widget abteilungWidget = Column(children: abtWidLs);

    retLs.add(
      widget.onAbteilungTap != null
          ? GestureDetector(
              onTap: () => widget.onAbteilungTap!(rennen.numAbteilungen),
              child: abteilungWidget,
            )
          : abteilungWidget,
    );

    return retLs;
  }

  @override
  Widget build(BuildContext context) {
    return easyFutureBuilder(
      fetchData(
        widget.rennId,
      ),
      (data) {
        Rennen rennen = data as Rennen;

        return SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: _body(rennen),
            ),
          ),
        );
      },
    );
  }
}

