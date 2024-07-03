import 'package:flutter/material.dart';

Widget txtBtn(
  BuildContext context,
  String label,
  void Function() onPressed,
) {
  return ElevatedButton(
    onPressed: onPressed,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .1 + 20,
        width: MediaQuery.of(context).size.width * .1 + 60,
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
      ),
    ),
  );
}

