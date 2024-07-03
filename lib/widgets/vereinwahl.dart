import 'package:flutter/material.dart';
import 'package:regatta_app/models/verein.dart';
import 'package:regatta_app/widgets/clickable_listtile.dart';
import 'package:regatta_app/widgets/easy_future_builder.dart';

class VereinWahl extends StatefulWidget {
  final void Function(Verein)? onTap;
  final bool getMissingAktivenPass;
  final bool getMissingWaage;

  const VereinWahl({
    super.key,
    this.onTap,
    this.getMissingAktivenPass = false,
    this.getMissingWaage = false,
  });

  @override
  State<VereinWahl> createState() => _VereinWahlState();
}

class _VereinWahlState extends State<VereinWahl> {
  @override
  Widget build(BuildContext context) {
    return easyFutureBuilder(
      fetchVereinAll(
        getMissingAktivenPass: widget.getMissingAktivenPass,
        getMissingWaage: widget.getMissingWaage,
      ),
      (data) {
        List<Verein> vereinLs = data as List<Verein>;

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, i) {
            Verein verein = vereinLs[i];
            return ClickableListTile(
              title: verein.name,
              onTap: () => widget.onTap != null ? widget.onTap!(verein) : null,
            );
          },
        );
      },
    );
  }
}

