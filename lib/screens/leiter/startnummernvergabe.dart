// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:regatta_app/services/api_request.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/dialog.dart';

class Startnummernvergabe extends StatelessWidget {
  const Startnummernvergabe({super.key});

  void setStartnummern(BuildContext context) async {
    bool confirm = await dialogConfim(context, "Es werden allen Meldungen, entsprechend ihrer Setzung Starnummern zugeordnet. Diese Funktion sollte nur vor der Veröffentlichung des ersten Meldeergebnisses verwendet werden!");

    if (!confirm) {
      return;
    }
    
    await Future.delayed(const Duration(milliseconds: 50));

    dialogLoading(context);

    ApiResponse res = await ApiRequester(baseUrl: ApiUrl.setStartnummern).post();

    Navigator.of(context).pop();
    await Future.delayed(const Duration(milliseconds: 50));

    if (res.status) {
      dialogOkay(context, res.data);
    } else {
      dialogApiError(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      "Startnummernvergabe",
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
                  "Nur einmal ausführen!",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => setStartnummern(context),
                      child: const Column(
                        children: [
                          Icon(Icons.filter_1),
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
    );
  }
}
