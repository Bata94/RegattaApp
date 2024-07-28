import 'package:flutter/material.dart';
import 'package:regatta_app/models/athlet.dart';
import 'package:regatta_app/models/verein.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/easy_future_builder.dart';
import 'package:regatta_app/widgets/vereinwahl.dart';
import 'package:regatta_app/widgets/athletwahl.dart';

class BueroWaage extends StatefulWidget {
  const BueroWaage({super.key});

  @override
  State<BueroWaage> createState() => _BueroWaageState();
}

class _BueroWaageState extends State<BueroWaage> {
  Verein? verein;
  List<Athlet> athletLs = [];
  bool athletenFetched = false;
  Athlet? athlet;

  Widget body() {
    if (verein == null) {
      return VereinWahl(
        onTap: (ver) => setState(() => verein = ver)
      );
    }

    if (athlet != null) {
      return Text(athlet!.name);
    }

    if (!athletenFetched) {
      return easyFutureBuilder(
        fetchMissWaage(verein!),
        (data) {
          setState(() {
            athletenFetched = true;
            athletLs = data;
          });
          return const Text("Redirecting...");
        }
      );
    } else {
      return AthletWahl(
        athletLs: athletLs,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout("Waage", body());
  }
}
