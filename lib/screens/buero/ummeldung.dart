import 'package:flutter/material.dart';
import 'package:regatta_app/models/meldung.dart';
import 'package:regatta_app/models/verein.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/easy_future_builder.dart';
import 'package:regatta_app/widgets/meldungwahl.dart';
import 'package:regatta_app/widgets/vereinwahl.dart';

class BueroUmmeldung extends StatefulWidget {
  const BueroUmmeldung({super.key});

  @override
  State<BueroUmmeldung> createState() => _BueroUmmeldungState();
}

class _BueroUmmeldungState extends State<BueroUmmeldung> {
  Verein? verein;
  Meldung? meldung;
  List<Meldung> meldungen = [];

  Widget body() {
    if (verein == null) {
      return easyFutureBuilder(
        fetchVereinAll(),
        (data) {
          return VereinWahl(
            vereinLs: data,
            onTap: (v) {
              setState(() => verein = v);
            },
          );
        }
        );
      } else {
      return easyFutureBuilder(
        fetchMedlungForVerein(verein!.uuid),
        (snapshot) {
          meldungen = snapshot;

          for (Meldung meld in meldungen) {
            meld.verein = verein;
          }
          return MeldungWahl(
            rennId: "Meldungen für ${verein!.kuerzel}",
            meldungLS: meldungen,
            onTap: (meld) => setState(() => meldung = meld),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout("Ummeldung", body());
  }
}
