import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget NavBtn(
  BuildContext context,
  IconData iconData,
  String route,
  String label,
) {
  return ElevatedButton(
    onPressed: () => Navigator.pushNamed(
      context,
      route,
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .1 + 100,
        width: MediaQuery.of(context).size.width * .1 + 140,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              iconData,
              size: MediaQuery.of(context).size.width * .03 + 50,
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    overflow: TextOverflow.clip,
                  ),
            ),
          ],
        ),
      ),
    ),
  );
}

