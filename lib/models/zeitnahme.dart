import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:regatta_app/services/api_request.dart';

Future<List<Zeitnahme>> fetchOpenStarts() async {
  final ApiResponse response = await ApiRequester(baseUrl: ApiUrl.zeitnahmeOpenStarts).get();
  List<Zeitnahme> retLs = [];

  for (dynamic z in response.data) {
    retLs.add(Zeitnahme.fromJson(z));
  }

  if (response.statusCode == 200) {
    return retLs;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Fehler beim Laden. Server Error${response.statusCode}!');
  }
}

Future<bool> postStart(String rennNr, List<String> startNummern, {int latency=0}) async {
  final res = await ApiRequester(baseUrl: ApiUrl.zeitnahmePostStart).post(body: {
    "rennen_nummer": rennNr,
    "start_nummern": startNummern,
    "time_client": "${DateTime.now().toIso8601String()}Z",
    "measured_latency": latency,
  });

  debugPrint(res.msg);

  return res.status;
}

class Zeitnahme {
  int id;
  DateTime? timeClient;
  DateTime? timeServer;
  String? rennenNummer;
  String? startNummer;
  bool? verarbeitet;

  Zeitnahme({
    required this.id,
    this.timeClient,
    this.timeServer,
    this.rennenNummer,
    this.startNummer,
    this.verarbeitet,
  });

  Map toMap() {
    return {
      'id': id,
      'time_client': timeClient?.toIso8601String(),
      'time_server': timeServer?.toIso8601String(),
      'rennen_nummer': rennenNummer,
      'start_nummer': startNummer,
      'verarbeitet': verarbeitet,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory Zeitnahme.fromJson(Map<String, dynamic> jsonData) {
    return Zeitnahme(
      id: jsonData['id'],
      timeClient: DateTime.parse(jsonData['time_client']),
      timeServer: DateTime.parse(jsonData['time_server']),
      rennenNummer: jsonData['rennen_nummer'],
      startNummer: jsonData['start_nummer'],
      verarbeitet: jsonData['verarbeitet'],
    );
  }
}
