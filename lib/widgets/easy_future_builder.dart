import 'package:flutter/material.dart';
import 'package:regatta_app/widgets/loading_spinner.dart';

Widget easyFutureBuilder(
  Future future,
  Widget Function(dynamic) onLoad, {
  dynamic initData,
}) {
  return FutureBuilder(
    future: future,
    initialData: initData,
    builder: (BuildContext context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done &&
          snapshot.hasData) {
        return onLoad(snapshot.data);
      } else if (snapshot.hasError) {
        return Container(
          color: Colors.white,
          child: Center(
            child: Text(
              "Es ist ein Fehler aufgetreten!:\n${snapshot.error}",
            ),
          ),
        );
      } else if (snapshot.connectionState == ConnectionState.waiting) {
        return Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                loadingSpinner(context),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Bitte warten ...",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
        );
      } else {
        return Container(
          color: Colors.white,
          child: Center(
            child: Text(
              "Es ist ein unbekannter Fehler aufgetreten!:\n${snapshot.error}",
            ),
          ),
        );
      }
    },
  );
}

