import 'package:flutter/material.dart';
import 'package:regatta_app/models/rennen.dart';
import 'package:regatta_app/widgets/clickable_listtile.dart';
import 'package:regatta_app/widgets/easy_future_builder.dart';

class RennenWahl extends StatefulWidget {
  final String wettkampfIdentifier;
  final String? vereinId;
  final void Function(Rennen)? onTap;
  final bool getStartedMeldungen;
  final bool getEmpty;

  const RennenWahl({
    super.key,
    this.wettkampfIdentifier = "all",
    this.vereinId,
    this.onTap,
    this.getStartedMeldungen = true,
    this.getEmpty = false,
  });

  @override
  State<RennenWahl> createState() => _RennenWahlState();
}

class _RennenWahlState extends State<RennenWahl> {
  Future<List<Rennen>> fetchData(String wettkampfIdentifier, String? vereinId) {
    if (vereinId != null) {
      return fetchRennenAll();
    }
    if (wettkampfIdentifier == "all") {
      return fetchRennenAll();
    } else {
      return fetchRennenAll(wettkampf: wettkampfIdentifier);
    }
  }

  @override
  Widget build(BuildContext context) {
    return easyFutureBuilder(
      fetchData(widget.wettkampfIdentifier, widget.vereinId),
      (data) {
        List<Rennen> rennenLs = data as List<Rennen>;

        return ListView.builder(
          itemCount: rennenLs.length,
          itemBuilder: (context, i) {
            Rennen rennen = rennenLs[i];

            if (widget.getEmpty == false && rennen.numMeldungen == 0) {
              return const SizedBox(
                width: 2,
              );
            } else {
              return ClickableListTile(
                title:
                    "Rennen ${rennen.nummer} ${rennen.bezeichnung} ${rennen.zusatz}",
                subtitle:
                    "${rennen.numMeldungen} Meldungen in ${rennen.numAbteilungen} Abteilungen -> Startzeit: ${rennen.startZeit}",
                onTap: () =>
                    widget.onTap != null ? widget.onTap!(rennen) : null,
              );
            }
          },
        );
      },
    );
  }
}

