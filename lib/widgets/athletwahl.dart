import 'package:flutter/material.dart';
import 'package:regatta_app/models/teilnehmer.dart';
import 'package:regatta_app/widgets/clickable_listtile.dart';

class TeilnehmerWahl extends StatefulWidget {
  final List<Teilnehmer> teilnehmerLs;
  final void Function(Teilnehmer)? onTap;
  const TeilnehmerWahl({
    super.key,
    required this.teilnehmerLs,
    this.onTap,
  });

  @override
  State<TeilnehmerWahl> createState() => _TeilnehmerWahlState();
}

class _TeilnehmerWahlState extends State<TeilnehmerWahl> {
  @override
  Widget build(BuildContext context) {
    List<Teilnehmer> teilnehmerLs = widget.teilnehmerLs;

    return ListView.builder(
      itemCount: teilnehmerLs.length,
      itemBuilder: (context, i) {
        Teilnehmer teilnehmer = teilnehmerLs[i];

        return ClickableListTile(
          title: teilnehmer.toString(),
          onTap: () => widget.onTap != null ? widget.onTap!(teilnehmer) : null,
        );
      },
    );
  }
}

