// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:regatta_app/models/rennen.dart';
import 'package:regatta_app/models/meldung.dart';
import 'package:regatta_app/services/api_request.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/clickable_listtile.dart';
import 'package:regatta_app/widgets/dialog.dart';
import 'package:regatta_app/widgets/rennwahl.dart';
import 'package:regatta_app/widgets/text_btn.dart';
import 'package:regatta_app/widgets/text_input.dart';

class SetzungChange extends StatefulWidget {
  const SetzungChange({super.key});

  @override
  State<SetzungChange> createState() => _SetzungChangeState();
}

class _SetzungChangeState extends State<SetzungChange> {
  final formKey = GlobalKey<FormState>();
  Rennen? rennen;

  void save() async {
    List<Map<String, dynamic>> postMeldungLs = [];
    try {
      if (formKey.currentState == null || !formKey.currentState!.validate()) {
        return;
      }

      final FormState form = formKey.currentState!;
      form.save();

      for (Meldung meld in rennen!.meldungen) {
        postMeldungLs.add({
          "uuid": meld.uuid,
          "abteilung": meld.abteilung,
          "bahn": meld.bahn,
        });
      }      
    } catch (e) {
      dialogError(context, "Eingabe üngültig!", "Eingabe üngültig!");
      return;
    }
    
    dialogLoading(context);

    ApiResponse res = await ApiRequester(baseUrl: ApiUrl.postSetzungLs).post(body: {"rennen_uuid": rennen!.uuid, "meldungen": postMeldungLs});
    String rennenUuid = rennen!.uuid;

    setState(() {
      rennen = null;        
    });
    // await Future.delayed(const Duration(milliseconds: 500));

    Rennen newRennen = await fetchRennen(rennenUuid);

    Navigator.of(context).pop();
    await Future.delayed(const Duration(milliseconds: 50));

    setState(() {
      rennen = newRennen;        
    });

    if (res.status) {  
      dialogOkay(context, "Setzung erfolgreich verändert!");
    } else {
      dialogApiError(context, res);
    }
  }

  Widget body() {
    List<Widget> bodyWidgets = [
      ClickableListTile(
        title: "${rennen!.nummer} - ${rennen!.bezeichnung}",
        subtitle: "${rennen!.numMeldungen} Meldungen in ${rennen!.numAbteilungen} Abteilungen\nZum wechseln klicken...",
        onTap: () => setState(() {
          rennen = null;
        }),
      ),
      Text("Meldungen:", style: Theme.of(context).textTheme.displaySmall),
      const Divider(),
    ];

    List<Widget> formWidgets = [];

    for (Meldung meld in rennen!.meldungen) {
      if (meld.abgemeldet) {continue;}

      formWidgets.add(
        Container(
          margin: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width * .8,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * .4, child: Text("StartNummer: ${meld.startNr}\nVerein: ${meld.verein?.name ?? "ApiError!"}", style: Theme.of(context).textTheme.titleLarge)),
                  SizedBox(width: MediaQuery.of(context).size.width * .15, child: textField(context, "Abteilung:", Icons.abc, (val) => meld.abteilung = int.parse(val ?? ""), initialValue: meld.abteilung.toString(), txtInpType: TextInputType.number)),
                  SizedBox(width: MediaQuery.of(context).size.width * .15, child: textField(context, "Bahn:", Icons.abc, (val) => meld.bahn = int.parse(val ?? ""), initialValue: meld.bahn.toString(), txtInpType: TextInputType.number)),
                ],
              ),
            ),
          ),
        )
      );
    }

    bodyWidgets.add(Form(key: formKey, child: Column(children: formWidgets,),),);

    bodyWidgets.add(Container(height: 120, margin: const EdgeInsets.all(16), child: txtBtn(context, "Speichern", save)));

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
