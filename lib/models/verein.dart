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

class Verein {
  final String id;
  final String kuerzel;
  final String kurzform;
  final String name;

  Verein({
    required this.id,
    required this.kuerzel,
    required this.kurzform,
    required this.name,
  });

  factory Verein.fromJson(Map<String, dynamic> json) {

    return Verein(
      id: json['id'],
      kuerzel: json['lettern'],
      kurzform: json['kurzform'],
      name: json['name'],
    );
  }
}

