import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget LayoutGrid(List<Widget> children) {
  return GridView.extent(
    maxCrossAxisExtent: 400,
    padding: const EdgeInsets.all(24),
    mainAxisSpacing: 24,
    crossAxisSpacing: 24,
    childAspectRatio: 1.8,
    children: children,
  );
}
