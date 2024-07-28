import 'package:flutter/material.dart';
import 'package:regatta_app/models/athlet.dart';
import 'package:regatta_app/widgets/clickable_listtile.dart';

class AthletWahl extends StatefulWidget {
  final List<Athlet> athletLs;
  final void Function(Athlet)? onTap;
  const AthletWahl({
    super.key,
    required this.athletLs,
    this.onTap,
  });

  @override
  State<AthletWahl> createState() => _AthletWahlState();
}

class _AthletWahlState extends State<AthletWahl> {
  @override
  Widget build(BuildContext context) {
    List<Athlet> athletLs = widget.athletLs;

    return ListView.builder(
      itemCount: athletLs.length,
      itemBuilder: (context, i) {
        Athlet athlet = athletLs[i];

        return ClickableListTile(
          title: athlet.toString(),
          onTap: () => widget.onTap != null ? widget.onTap!(athlet) : null,
        );
      },
    );
  }
}

