import 'package:regatta_app/models/athlet.dart';
import 'package:regatta_app/services/api_request.dart';

Future<Verein> fetchVerein(String uuid) async {
  ApiResponse res = await ApiRequester(baseUrl: ApiUrl.vereine).get(param: uuid);
  if (!res.status) {
    throw Exception("Error!");
  }

  return Verein.fromJson(res.data);
}

Future<List<Verein>> fetchVereinAll() async {
  ApiResponse res = await ApiRequester(baseUrl: ApiUrl.vereine).get();
  if (!res.status) {
    throw Exception("Error!");
  }

  List<Verein> retLs = [];
  for (Map<String, dynamic> json in res.data) {
    retLs.add(Verein.fromJson(json));
  }
  return retLs;
}

Future<List<VereinWithAthleten>> fetchAllMissWaageByVerein() async {
  ApiResponse res = await ApiRequester(baseUrl: ApiUrl.athletenWaage).get();
  if (!res.status) {
    throw Exception("Error!");
  }
      
  List<VereinWithAthleten> retLs = [];
  for (Map<String, dynamic> d in res.data) {
    List<AthletWithFirstRace> athleten = [];
    for (Map<String, dynamic> a in d['athleten']) {
      athleten.add(AthletWithFirstRace.fromJson(a));
    }
    retLs.add(VereinWithAthleten(
      verein: Verein.fromJson(d['verein']),
      athleten: athleten,
    ));
  }

  return retLs;
}

Future<List<VereinWithAthleten>> fetchAllMissStartberechtigungByVerein() async {
  ApiResponse res = await ApiRequester(baseUrl: ApiUrl.athletenStartberechtigung).get();
  if (!res.status) {
    throw Exception("Error!");
  }
      
  List<VereinWithAthleten> retLs = [];
  for (Map<String, dynamic> d in res.data) {
    List<AthletWithFirstRace> athleten = [];
    for (Map<String, dynamic> a in d['athleten']) {
      athleten.add(AthletWithFirstRace.fromJson(a));
    }
    retLs.add(VereinWithAthleten(
      verein: Verein.fromJson(d['verein']),
      athleten: athleten,
    ));
  }

  return retLs;
}

Future<List<Athlet>> fetchMissWaage(Verein verein) async {
  ApiResponse res = await ApiRequester(baseUrl: ApiUrl.vereinWaage).get(param: verein.uuid);
  if (!res.status) {
    throw Exception("Error!");
  }
      
  List<Athlet> athletLs = [];
  for (Map<String, dynamic> ath in res.data) {
    athletLs.add(Athlet.fromJson(ath));
  }

  return athletLs;
}

Future<List<Athlet>> fetchMissStartberechtigung(Verein verein) async {
  ApiResponse res = await ApiRequester(baseUrl: ApiUrl.vereinStartberechtigung).get(param: verein.uuid);
  if (!res.status) {
    throw Exception("Error!");
  }
      
  List<Athlet> athletLs = [];
  for (Map<String, dynamic> ath in res.data) {
    athletLs.add(Athlet.fromJson(ath));
  }

  return athletLs;
}

class Verein {
  final String uuid;
  final String kuerzel;
  final String kurzform;
  final String name;

  Verein({
    required this.uuid,
    required this.kuerzel,
    required this.kurzform,
    required this.name,
  });

  factory Verein.fromJson(Map<String, dynamic> json) {

    return Verein(
      uuid: json['uuid'],
      kuerzel: json['kuerzel'],
      kurzform: json['kurzform'] == "" ? json['kuerzel'] : json["kurzform"],
      name: json['name'],
    );
  }
}

class VereinWithAthleten {
  final Verein verein;
  final List<AthletWithFirstRace> athleten;

  VereinWithAthleten({required this.verein, required this.athleten});
}

