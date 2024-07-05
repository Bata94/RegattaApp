// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:regatta_app/services/api_request.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/dialog.dart';

class Zeitplan extends StatefulWidget {
  const Zeitplan({super.key});

  @override
  State<Zeitplan> createState() => _ZeitplanState();
}

class _ZeitplanState extends State<Zeitplan> {
  final formKey = GlobalKey<FormState>();
  double _saStartHour = 10;
  double _soStartHour = 9;

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
        "sa_start_stunde": _saStartHour.round(),
        "so_start_stunde": _soStartHour.round(),
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
            height: 400,
            width: 400,
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Erstelle/Aktualisiere Zeitplan:",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.timer),
                        Text(
                          "Startstunde Samstag:",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          _saStartHour.round().toString(),
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Slider(
                    min: 6,
                    max: 14,
                    divisions: 9,
                    value: _saStartHour,
                    onChanged: (val) => setState(() => _saStartHour = val),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.timer),
                        Text(
                          "Startstunde Sonntag:",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          _soStartHour.round().toString(),
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Slider(
                    min: 6,
                    max: 14,
                    divisions: 9,
                    value: _soStartHour,
                    onChanged: (val) => setState(() => _soStartHour = val),
                  ),
                  const Divider(),
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
            ),
          ),
        ),
      ),
    );
  }
}
