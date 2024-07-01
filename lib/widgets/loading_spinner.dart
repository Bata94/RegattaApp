import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget loadingSpinner(
  BuildContext context, {
  double size = 80.0,
}) {
  return SpinKitPouringHourGlass(
    color: Theme.of(context).primaryColor,
    size: size,
    // duration: duration,
  );
}

