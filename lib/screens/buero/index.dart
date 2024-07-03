import 'package:flutter/material.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/layout_grid.dart';
import 'package:regatta_app/widgets/nav_btn.dart';

class BueroIndex extends StatelessWidget {
  const BueroIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      "Regattabüro",
      LayoutGrid([
        NavBtn(
          context,
          Icons.clear,
          "/buero/abmeldung",
          "Abmeld.",
        ),
        NavBtn(
          context,
          Icons.switch_left,
          "/buero/ummeldung",
          "Ummeld.",
        ),
        NavBtn(
          context,
          Icons.new_label,
          "/buero/nachmeldung",
          "Nachmeld.",
        ),
        NavBtn(
          context,
          Icons.person_add,
          "/buero/athletAnlegen",
          "Athlet anl.",
        ),
        NavBtn(
          context,
          Icons.medical_information,
          "/buero/missingAktivenPass",
          "Ärztl. Besch.",
        ),
        NavBtn(
          context,
          Icons.scale,
          "/buero/waage",
          "Waage",
        ),
        NavBtn(
          context,
          Icons.money,
          "/buero/startnummern",
          "Startnr-Ausg",
        ),
        NavBtn(
          context,
          Icons.swap_horiz,
          "/buero/startnummerwechseln",
          "Startnr-Wechsel",
        ),
        NavBtn(
          context,
          Icons.calculate,
          "/buero/kasse",
          "Kasse",
        ),
      ],
      ),
    );
  }
}
