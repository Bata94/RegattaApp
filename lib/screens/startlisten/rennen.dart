import 'package:flutter/material.dart';
import 'package:regatta_app/models/rennen.dart';
import 'package:regatta_app/widgets/abteilungwahl.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/easy_future_builder.dart';

class StartlisteRennen extends StatefulWidget {
  final String rennenUuid;
  const StartlisteRennen (this.rennenUuid, {super.key});

  @override
  State<StartlisteRennen> createState() => _StartlisteRennenState();
}

class _StartlisteRennenState extends State<StartlisteRennen> {
  Rennen? rennen;

  Widget _body() {
    if (rennen == null) {
      return easyFutureBuilder(
        fetchRennen(widget.rennenUuid),
        (data) {
          rennen = data;
          return AbteilungWahl(rennUuid: rennen!.uuid);
        }
      );
    } else {
      return AbteilungWahl(rennUuid: rennen!.uuid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout("Rennen Übersicht", _body());
  }
}
