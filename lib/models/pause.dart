import 'package:regatta_app/services/api_request.dart';

// TODO: Error Handling!!
Future<List<Pause>> fetchAllPausen() async {
  ApiResponse res = await ApiRequester(baseUrl: ApiUrl.pause).get();

  List<Pause> pausenLs = [];
  for (Map<String, dynamic> pauseJson in res.data) {
    pausenLs.add(Pause.fromJson(pauseJson));
  }

  return pausenLs;
}

// TODO: Error Handling!!
Future<Pause> createPause(int laenge, String nachRennenUuid) async {
  ApiResponse res = await ApiRequester(baseUrl: ApiUrl.pause).post(body: {
    "laenge": laenge,
    "nach_rennen_uuid": nachRennenUuid
  });

  return Pause.fromJson(res.data);
}

class Pause {
  int id;
  int laenge;
  String nachRennenUuid;

  Pause({
    required this.id,
    required this.laenge,
    required this.nachRennenUuid,
  });

  void updateLaenge(int newLaenge) async {
    ApiResponse res = await ApiRequester(baseUrl: ApiUrl.pause).put(body: {
      "id": id,
      "laenge": newLaenge,
      "nach_rennen_uuid": nachRennenUuid
    });
  
    if (res.status) {
      laenge = newLaenge;
    }
  }

  factory Pause.fromJson(Map<String, dynamic> json) {
    return Pause(
      id: json["id"],
      laenge: json["laenge"],
      nachRennenUuid: json["nachRennenUuid"],
    );
  }
}
