import 'package:flutter/material.dart';
import 'package:regatta_app/models/verein.dart';
import 'package:regatta_app/widgets/clickable_listtile.dart';

class VereinWahl extends StatefulWidget {
  final void Function(Verein) onTap;
  final List<Verein> vereinLs;

  const VereinWahl({
    super.key,
    required this.onTap,
    required this.vereinLs,
  });

  @override
  State<VereinWahl> createState() => _VereinWahlState();
}

class _VereinWahlState extends State<VereinWahl> {
  @override
  Widget build(BuildContext context) {
    List<Verein> vereinLs = widget.vereinLs;
    return ListView.builder(
      itemCount: vereinLs.length,
      itemBuilder: (context, i) {
        Verein verein = vereinLs[i];
        return ClickableListTile(
          title: verein.name,
          onTap: () => widget.onTap(verein),
        );
      },
    );
  }
}

