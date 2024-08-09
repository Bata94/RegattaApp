import 'package:flutter/material.dart';

Widget textField(BuildContext context, String labelStr, IconData icon, void Function(String?) onSaved, {TextInputType txtInpType=TextInputType.text, bool obscureText=false, String? initialValue}) {
  Widget label = Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(icon),
      const SizedBox(width: 8,),
      Text(
        labelStr,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    ],
  );
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      label,
      TextFormField(
        autofocus: false,
        obscureText: obscureText,
        initialValue: initialValue ?? "",
        keyboardType: txtInpType,
        validator: (value) => value!.isEmpty ? "Bitte ausfüllen!" : null,
        onSaved: onSaved,
      ),
    ],
  );
}
