// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:regatta_app/services/api_request.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/dialog.dart';
import 'package:regatta_app/widgets/text_input.dart';

class Zeitplan extends StatefulWidget {
  const Zeitplan({super.key});

  @override
  State<Zeitplan> createState() => _ZeitplanState();
}

class _ZeitplanState extends State<Zeitplan> {
  final formKey = GlobalKey<FormState>();
  String _saStartHour = "";
  String _soStartHour = "";

  void setStartnummern(BuildContext context) async {
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return;
    }

    final FormState form = formKey.currentState!;
    form.save();

    bool confirm = await dialogConfim(context, "Es wird der Zeitplan, entsprechend der Abteilungen und Pausen erstellt. Nach größeren Nachmeldungen kann diese Funktion nochmal gestartet werden.");

    if (!confirm) {
      return;
    }
    
    await Future.delayed(const Duration(milliseconds: 50));

    dialogLoading(context);

    ApiResponse res = await ApiRequester(baseUrl: ApiUrl.setZeitplan).post(
      body: {
        "sa_start_stunde": int.tryParse(_saStartHour) ?? "",
        "so_start_stunde": int.tryParse(_soStartHour) ?? "",
      },
    );

    Navigator.of(context).pop();
    await Future.delayed(const Duration(milliseconds: 50));

    if (res.status) {
      dialogOkay(context, res.data);
    } else {
      dialogError(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      "Zeitplan",
      Center(
        child: Card(
          child: Container(
            height: 340,
            width: 320,
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Erstelle/Aktualisiere Zeitplan:",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Divider(),
                  textField(
                    context,
                    "Startstunde Sa:",
                    Icons.timer,
                    (val) => _saStartHour = val ?? "",
                    initialValue: "10",
                    txtInpType: TextInputType.number,
                  ),
                  textField(
                    context,
                    "Startstunde Sa:",
                    Icons.timer,
                    (val) => _soStartHour = val ?? "",
                    initialValue: "9",
                    txtInpType: TextInputType.number,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => setStartnummern(context),
                        child: const Column(
                          children: [
                            Icon(Icons.access_time),
                            Text("Erstellen"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
