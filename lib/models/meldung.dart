import 'package:regatta_app/models/rennen.dart';
import 'package:regatta_app/models/athlet.dart';
import 'package:regatta_app/models/verein.dart';

class Meldung {
  final String uuid;
  final String meldungstyp;
  final String? bemerkung;
  bool abgemeldet;
  bool dns;
  bool dnf;
  bool dsq;
  int? startNr;
  int? abteilung;
  int? bahn;
  int? kosten;
  final String rennNr;
  final String rennenUuid;
  final String vereinUuid;
  Verein? verein;
  Rennen? rennen;
  List<Athlet> athlets;

  Meldung({
    required this.uuid,
    required this.rennNr,
    this.startNr,
    this.bahn,
    this.abteilung,
    this.kosten,
    this.bemerkung,
    required this.abgemeldet,
    required this.dns,
    required this.dnf,
    required this.dsq,
    required this.meldungstyp,
    required this.vereinUuid,
    required this.rennenUuid,
    this.athlets = const [],
    this.verein,
    this.rennen,
  });

  String isLeichtGW() {
    if (rennen == null) {
      return "unbekannt";
    }
    if (rennen!.leichtgewicht) {
      return "Ja";
    } else {
      return "Nein";
    }
  }

  String isStartBer() {
    if (athlets.isEmpty) {
      return "unbekannt";
    }

    bool startBer = true;

    for (Athlet athlet in athlets) {
      if (athlet.startberechtigt == false) {
        startBer = false;
        break;
      }
    }

    if (startBer) {
      return "Ja";
    } else {
      return "Nein";
    }
  }

  int setzGewichtung() {
    int abteilungsGew = abteilung ??= 1;
    abteilungsGew = abteilungsGew * 1000;
    int bahnGew = bahn ??= 1;

    return abteilungsGew + bahnGew;
  }

  factory Meldung.fromJson(Map<String, dynamic> json) {
    List<Athlet> athletLs = [];
    if (json.containsKey("athleten")) {
      for (Map<String, dynamic> athletMap in json['athleten']) {
        athletLs.add(Athlet.fromJson(athletMap));
      }
    }

    return Meldung(
      uuid: json['uuid'] ??= "",
      meldungstyp: json['typ'] ??= "",
      bemerkung: json['bemerkung'] ??= "",
      abgemeldet: json['abgemeldet'] ??= false,
      dns: json['dns'] ??= false,
      dnf: json['dnf'] ??= false,
      dsq: json['dsq'] ??= false,
      startNr: json['start_nummer'],
      abteilung: json['abteilung'],
      bahn: json['bahn'],
      kosten: json['kosten_eur'] ?? 0,
      rennNr: json['renn_nr'] ??= "",
      rennenUuid: json['rennen_uuid'] ??= "",
      vereinUuid: json['verein_uuid'] ??= "",
      athlets: athletLs,
      verein: json.containsKey("verein") ? Verein.fromJson(json['verein']) : null,
      rennen: json.containsKey("rennen") ? Rennen.fromJson(json['rennen']) : null,
    );
  }
}

