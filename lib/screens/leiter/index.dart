import 'package:flutter/material.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/layout_grid.dart';
import 'package:regatta_app/widgets/nav_btn.dart';

class LeitungIndex extends StatelessWidget {
  const LeitungIndex({super.key});

  @override
  Widget build(BuildContext context) {
      return BaseLayout(
      "Regattaleiter",
      LayoutGrid([
        NavBtn(
          context,
          Icons.upload_file,
          "/leitung/drvupload",
          "DRV Meldung Upload",
        ),
        NavBtn(
          context,
          Icons.shuffle,
          "/leitung/setzungslosung",
          "Setzungslosung",
        ),
        NavBtn(
          context,
          Icons.sort,
          "/leitung/setzunganpassen",
          "Setzung anpassen",
        ),
        NavBtn(
          context,
          Icons.filter_1,
          "/leitung/startnummernvergabe",
          "Startnummernvergabe",
        ),
        NavBtn(
          context,
          Icons.coffee,
          "/leitung/pausen",
          "Rennpausen",
        ),
        NavBtn(
          context,
          Icons.access_time,
          "/leitung/zeitplan",
          "Zeitplan erstellen",
        ),
        NavBtn(
          context,
          Icons.assignment,
          "/leitung/meldeergebnis",
          "Meldeergebnis PDF",
        ),
        NavBtn(
          context,
          Icons.school,
          "/leitung/urkunden",
          "Urkunden PDF",
        ),
        NavBtn(
          context,
          Icons.social_distance,
          "/leitung/rennabstand",
          "Rennabst.",
        ),
      ],
      ),
    );
  }
}
