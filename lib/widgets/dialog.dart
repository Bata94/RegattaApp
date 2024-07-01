import 'package:flutter/material.dart';
import 'package:regatta_app/services/api_request.dart';
import 'package:regatta_app/widgets/loading_spinner.dart';

void dialogLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    useRootNavigator: false,
    builder: (context) => Dialog(
      child: Container(
        height: 200,
        width: 200,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            loadingSpinner(context),
            const Text("Bitte warten ... "),
          ],
        ),
      ),
    ),
  );
}

void dialogOkay(BuildContext context, String message, {String title = "Okay"}) {
  TextTheme txtTheme = Theme.of(context).textTheme;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: txtTheme.titleLarge,
        ),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            message,
            softWrap: true,
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
            style: txtTheme.bodyMedium,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Okay",
              style: txtTheme.bodyLarge,
            ),
          ),
        ],
      );
    },
  );
}

void dialogError(BuildContext context, ApiResponse err) {
  TextTheme txtTheme = Theme.of(context).textTheme;
  ColorScheme colorScheme = Theme.of(context).colorScheme;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          err.error,
          style: txtTheme.titleLarge,
        ),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            err.msg,
            softWrap: true,
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
            style: txtTheme.bodyMedium!.copyWith(color: colorScheme.error),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(colorScheme.error),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Okay",
              style: txtTheme.bodyLarge!.copyWith(color: colorScheme.onError),
            ),
          ),
        ],
      );
    },
  );
}

Future<bool> dialogConfim(BuildContext context, String message, {String title = "Sind Sie sicher?"}) async {
  bool confirm = false;

  TextTheme txtTheme = Theme.of(context).textTheme;
  ColorScheme colorScheme = Theme.of(context).colorScheme;

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: txtTheme.titleLarge,
        ),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            message,
            softWrap: true,
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
            style: txtTheme.bodyMedium,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              confirm = true;
              Navigator.of(context).pop();
            },
            child: Text(
              "Ja",
              style: txtTheme.bodyLarge,
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(colorScheme.error),
            ),
            onPressed: () {
              confirm = false;
              Navigator.of(context).pop();
            },
            child: Text(
              "Nein",
              style: txtTheme.bodyLarge!.copyWith(color: colorScheme.onError),
            ),
          ),
        ],
      );
    },
  );

  return confirm;
}