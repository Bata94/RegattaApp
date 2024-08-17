import 'package:regatta_app/models/rennen.dart';
import 'package:regatta_app/models/athlet.dart';
import 'package:regatta_app/models/verein.dart';
import 'package:regatta_app/services/api_request.dart';

Future<List<Meldung>> fetchMedlungForVerein(String vereinUuid) async {
  ApiResponse res = await ApiRequester(baseUrl: ApiUrl.meldungForVerein).get(param: vereinUuid);
  if (!res.status) {
    throw Exception("Error!");
  }

  List<Meldung> retLs = [];
  for (Map<String, dynamic> meld in res.data) {
    retLs.add(Meldung.fromJson(meld));
  }

  return retLs;
}

class AthletPosition {
  final String uuid;
  final String position;

  AthletPosition(this.uuid, this.position);
}

Future<Meldung> postUmmeldung(String meldUuid, List<AthletPosition> athletenLs) async {
  Map<String, dynamic> body = {
    "meldung_uuid": meldUuid,
    "athleten": athletenLs.map((a) => {"uuid": a.uuid, "position": a.position}).toList(),
  };

  ApiResponse res = await ApiRequester(baseUrl: ApiUrl.ummeldung).post(body: body);

  if (!res.status) {
    throw Exception(res.msg);
  }

  return Meldung.fromJson(res.data);
}

Future<Meldung> postNachmeldung(String vereinUuid, rennenUuid, bool doppeltesMeldeentgeldBefreiung, List<AthletPosition> athletenLs) async {
  Map<String, dynamic> body = {
    "verein_uuid": vereinUuid,
    "rennen_uuid": rennenUuid,
    "doppeltes_meldentgeld_befreiung": doppeltesMeldeentgeldBefreiung,
    "athleten": athletenLs.map((a) => {"uuid": a.uuid, "position": a.position}).toList(),
  };

  ApiResponse res = await ApiRequester(baseUrl: ApiUrl.nachmeldung).post(body: body);

  if (!res.status) {
    throw Exception(res.msg);
  }

  return Meldung.fromJson(res.data);
}

Future<ApiResponse> postAbmeldung(String uuid) async {
  ApiResponse res = await ApiRequester(baseUrl: ApiUrl.bueroAbmeldung).post(body: {"uuid": uuid});
  return res;
}

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

  String athletenStr() {
    String retStr = "";
    if (athlets.isEmpty) {
      return "Keine Athleten gefunden!";
    }
    if (athlets[0].position == null || athlets[0].rolle == null || athlets[0].rolle == "") {
      return "Athletenauslesung fehlgeschlagen!";
    }

    List<Athlet> ruderer = [];
    List<Athlet> steuermann= [];
    List<Athlet> trainer = [];

    for (Athlet a in athlets) {
      if (a.rolle == "Ruderer") {
        ruderer.add(a);
      } else if (a.rolle == "Trainer") {
        trainer.add(a);
      } else if (a.rolle == "Stm.") {
        steuermann.add(a);
      }
    }

    ruderer.sort((a,b)=>a.position!.compareTo(b.position!));
    trainer.sort((a,b)=>a.position!.compareTo(b.position!));
    steuermann.sort((a,b)=>a.position!.compareTo(b.position!));

    for (Athlet a in ruderer) {
      if (retStr != "") {
        retStr += " - ";
      }
      retStr += "#${a.position} ${a.toString()}";
    }

    for (Athlet a in steuermann) {
      if (retStr != "") {
        retStr += " - ";
      }
      retStr += "Stm. ${a.toString()}";
    }

    return retStr;
  }

  factory Meldung.fromJson(Map<String, dynamic> json) {
    List<Athlet> athletLs = [];
    if (json.containsKey("athleten") && json['athleten'] != null && json['athleten'].isNotEmpty) {
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
      verein: json.containsKey("verein") && json['verein'] != null ? Verein.fromJson(json['verein']) : null,
      rennen: json.containsKey("rennen") && json['rennen'] != null ? Rennen.fromJson(json['rennen']) : null,
    );
  }
}

