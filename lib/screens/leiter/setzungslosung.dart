// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:regatta_app/services/api_request.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/dialog.dart';

class Setzungslosung extends StatelessWidget {
  const Setzungslosung({super.key});

  void setSetzung(BuildContext context) async {
    bool confirm = await dialogConfim(context, "Es werden alle Meldungen zufällig in die Abteilungen und Bahenen zugewiesen. Das kann nur einmal getan werden, also nachdem alle Meldungen importiert wurden!");

    if (!confirm) {
      return;
    }
    
    await Future.delayed(const Duration(milliseconds: 50));

    dialogLoading(context);

    ApiResponse res = await ApiRequester(baseUrl: ApiUrl.setzungsLosung).post();

    Navigator.of(context).pop();
    await Future.delayed(const Duration(milliseconds: 50));

    if (res.status) {
      dialogOkay(context, res.data["msg"]);
    } else {
      dialogError(context, res);
    }
  }

  void resetSetzung(BuildContext context) async {
    bool confirm = await dialogConfim(context, "Es werden die zugewiesenen Abteilungen und Bahnen wieder zurückgesetzt. Dies kann nicht rückgängig gemacht werden!");

    if (!confirm) {
      return;
    }
    
    await Future.delayed(const Duration(milliseconds: 50));

    dialogLoading(context);

    ApiResponse res = await ApiRequester(baseUrl: ApiUrl.setzungsLosungReset).post();

    Navigator.of(context).pop();
    await Future.delayed(const Duration(milliseconds: 50));

    if (res.status) {
      dialogOkay(context, res.data["msg"]);
    } else {
      dialogError(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      "Setzungslosung",
      Center(
        child: Card(
          child: Container(
            height: 160,
            width: 320,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Nur ein einmal ausführen!",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => setSetzung(context),
                      child: const Column(
                        children: [
                          Icon(Icons.shuffle),
                          Text("Erstellen"),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => resetSetzung(context),
                      child: const Column(
                        children: [
                          Icon(Icons.restore),
                          Text("Reset"),
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
    );
  }
}
