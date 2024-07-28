// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:regatta_app/models/meldung.dart';
import 'package:regatta_app/models/verein.dart';
import 'package:regatta_app/services/api_request.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/dialog.dart';
import 'package:regatta_app/widgets/easy_future_builder.dart';
import 'package:regatta_app/widgets/meldungwahl.dart';
import 'package:regatta_app/widgets/vereinwahl.dart';

class BueroAbmeldung extends StatefulWidget {
  const BueroAbmeldung({super.key});

  @override
  State<BueroAbmeldung> createState() => _BueroAbmeldungState();
}

class _BueroAbmeldungState extends State<BueroAbmeldung> {
  Verein? verein;
  List<Meldung> meldungen = [];

  void abmeldungDialog(String uuid) async {
    Meldung? meld;
    String vereinName = "unknown";

    for (Meldung meldung in meldungen) {
      if (meldung.uuid == uuid) {
        meld = meldung;
      }
    }
    if (meld == null) {
      throw Exception("Meldungs UUID nicht in Meldungsliste! Dies kann eigenltich nicht passieren");
    }
    if (meld.verein != null) {
      vereinName = meld.verein!.name;
    }

    bool confirm = await dialogConfim(
      context,
      "Sind Sie sicher, dass Sie die Meldung mit der Startnummer ${meld.startNr} vom $vereinName mit den Athleten:\n${meld.athletenStr()}\nwirklich abmelden möchten?", 
      reverseColorsBtn: true,
    );

    if (confirm) {
      dialogLoading(context);
      ApiResponse res = await postAbmeldung(uuid);
      if (!res.status) {
        Navigator.of(context).pop();
        await Future.delayed(const Duration(milliseconds: 50));
        dialogError(context, res);
      } else {
        List<Meldung> newMeldungen = await fetchMedlungForVerein(verein!.uuid);
        Navigator.of(context).pop();
        await Future.delayed(const Duration(milliseconds: 50));
        setState(() => meldungen = newMeldungen);
        dialogOkay(context, "Meldung erfolgreich abgemeldet!");
      }
    }
  }

  Widget body() {
    if (verein == null) {
      return VereinWahl(
        onTap: (v) {
          setState(() => verein = v);
        },
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
            onTap: (uuid) => abmeldungDialog(uuid),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout("Abmeldung", body());
  }
}
