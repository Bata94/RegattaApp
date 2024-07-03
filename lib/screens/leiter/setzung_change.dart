import 'package:flutter/material.dart';
import 'package:regatta_app/models/rennen.dart';
import 'package:regatta_app/models/meldung.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/clickable_listtile.dart';
import 'package:regatta_app/widgets/dialog.dart';
import 'package:regatta_app/widgets/rennwahl.dart';

class SetzungChange extends StatefulWidget {
  const SetzungChange({super.key});

  @override
  State<SetzungChange> createState() => _SetzungChangeState();
}

class _SetzungChangeState extends State<SetzungChange> {
  Rennen? rennen;

  Widget body() {
    List<Widget> bodyWidgets = [
      ClickableListTile(
        title: "${rennen!.nummer} - ${rennen!.bezeichnung}",
        subtitle: "${rennen!.anzMeldungen} Meldungen in ${rennen!.anzAbteilungen} Abteilungen\nZum wechseln klicken...",
        onTap: () => setState(() {
          rennen = null;
        }),
      ),
    ];

    debugPrint(rennen!.meldungen.toString());
    for (Meldung meld in rennen!.meldungen) {
      bodyWidgets.add(Text("${meld.id} ${meld.abteilung} ${meld.bahn}"));
    }

    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: bodyWidgets,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (rennen == null) {
      return BaseLayout(
        "Setzung anpasen - Rennen wählen",
        RennenWahl(
          onTap: (r) async {
            dialogLoading(context);
            
            Rennen fetchedRennen = await fetchRennen(r.uuid);
            setState(() {
              rennen = fetchedRennen;
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            });
          },
        ),
      );
    } else {
      return BaseLayout(
        "Setzung anpassen",
        body(),
      );
    }
  }
}
