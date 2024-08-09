import 'package:flutter/material.dart';
import 'package:regatta_app/models/meldung.dart';
import 'package:regatta_app/models/rennen.dart';
import 'package:regatta_app/models/verein.dart';
import 'package:regatta_app/services/api_request.dart';

Future<Athlet> createAthlet(String vereinUuid, vorname, nachname, jahrgang, bool geschlechtMaennlich, startberechtigt) async {
  Map<String, dynamic> body = {
    "verein_uuid": vereinUuid,
    "vorname": vorname,
    "name": nachname,
    "jahrgang": jahrgang,
    "geschlecht": geschlechtMaennlich ? "w" : "m",
    "startberechtigt": startberechtigt,
  };

  ApiResponse res = await ApiRequester(baseUrl: ApiUrl.athlet).post(body: body);

  if (!res.status) {
    throw Exception(res.msg);
  }

  return Athlet.fromJson(res.data);
}

Future<ApiResponse> updateAthletGewicht(String uuid, double gewicht) async {
  ApiResponse res = await ApiRequester(baseUrl: ApiUrl.athletenWaage).put(
    body: {"uuid": uuid, "gewicht": (gewicht*10).round()},
  );
  return res;
}

Future<ApiResponse> updateAthletStartberechtigung(String uuid, bool startberechtigt) async {
  ApiResponse res = await ApiRequester(baseUrl: ApiUrl.athletenStartberechtigung).put(
    body: {"uuid": uuid, "startberechtigt": startberechtigt},
  );
  return res;
}

class Athlet {
  final String uuid;
  final String vorname;
  final String name;
  final String vereinUuid;
  final String jahrgang;
  final String geschlecht;
  final bool startberechtigt;
  final double gewicht;
  final String? rolle;
  final int? position;
  final List<Meldung> meldungen;
  final Verein? verein;

  Athlet({
    required this.uuid,
    required this.vorname,
    required this.name,
    required this.vereinUuid,
    required this.jahrgang,
    required this.geschlecht,
    required this.startberechtigt,
    required this.gewicht,
    this.rolle,
    this.position,
    this.meldungen = const [],
    this.verein,
  });

  @override
  String toString() =>
      "$vorname $name ${jahrgang.substring(jahrgang.length - 2)}";

  factory Athlet.fromJson(Map<String, dynamic> json) {
    List<Meldung> lsMeld = []; 
    if (json.containsKey("meldungen")) {
      for (var meld in json['meldungen']) {
        Meldung addMeld = Meldung.fromJson(meld);
        lsMeld.add(addMeld);
      }
    }

    double gewicht = 0.0;
    try {
      gewicht = json['gewicht'] / 10;
    } catch (e) {
      debugPrint(e.toString());
    }

    return Athlet(
      uuid: json['uuid'],
      vorname: json['vorname'],
      name: json['name'],
      vereinUuid: json['verein_uuid'],
      jahrgang: json['jahrgang'],
      geschlecht: json['geschlecht'],
      // TODO: Implement
      startberechtigt: json['startberechtigt'] ??= true,
      gewicht: gewicht,
      rolle: json['rolle'],
      position: json['position'],
      verein: json.containsKey("verein") ? Verein.fromJson(json['verein']) : null,
      meldungen: lsMeld,
    );
  }
}

class AthletWithFirstRace {
  final Athlet athlet;
  final Rennen firstRace;

  AthletWithFirstRace({
    required this.athlet,
    required this.firstRace,
  });

  factory AthletWithFirstRace.fromJson(Map<String, dynamic> json) {
    return AthletWithFirstRace(
      athlet: Athlet.fromJson(json['athlet']),
      firstRace: Rennen.fromJson(json['erstes_rennen']),
    );
  }
}
