import 'package:regatta_app/models/meldung.dart';
import 'package:regatta_app/services/api_request.dart';

Future<Rennen> fetchRennen(String uuid) async {
  ApiResponse res = await ApiRequester(baseUrl: ApiUrl.rennen).get(param: uuid);
  if (!res.status) {
    throw Exception("Error!");
  }

  Rennen ret = Rennen.fromJson(res.data);

  return ret;
}

Future<List<Rennen>> fetchRennenAll() async {
  ApiResponse res = await ApiRequester(baseUrl: ApiUrl.rennen).get();
  if (!res.status) {
    throw Exception("Error!");
  }

  List<Rennen> retLs = [];
  for (Map<String, dynamic> rennenJson in res.data) {
    retLs.add(Rennen.fromJson(rennenJson));
  }
  return retLs;
}

class Rennen {
  final String uuid;
  final String nummer;
  final int sortId;
  final String geschlecht;
  final String altersklasse;
  final String bootsklasse;
  final bool leichtgewicht;
  final String wettkampf;
  final String tag;
  final List<Meldung> meldungen;
  final int anzAbteilungen;
  final int anzMeldungen;
  final String bezeichnung;
  final String zusatz;
  final String startZeit;

  Rennen({
    required this.uuid,
    required this.nummer,
    required this.sortId,
    required this.geschlecht,
    required this.altersklasse,
    required this.bootsklasse,
    required this.leichtgewicht,
    required this.wettkampf,
    required this.tag,
    this.meldungen = const [],
    required this.anzAbteilungen,
    required this.anzMeldungen,
    required this.bezeichnung,
    required this.zusatz,
    required this.startZeit,
  });

  @override
  String toString() =>
      "$nummer $bezeichnung $zusatz -> $anzMeldungen Meldungen in $anzAbteilungen Abteilungen";

  factory Rennen.fromJson(Map<String, dynamic> json) {
    List<Meldung> lsMeld = [];
    if (json.containsKey('meldungen')) {
      for (var meld in json['meldungen']) {
        lsMeld.add(Meldung.fromJson(meld));
      }
    }

    lsMeld.sort((a, b) => a.setzGewichtung().compareTo(b.setzGewichtung()));

    Rennen newRennen = Rennen(
      uuid: json['uuid'],
      nummer: json['nummer'],
      sortId: json['sort_id'] ??= 999,
      bezeichnung: json['bezeichnung'] ??= "",
      zusatz: json['zusatz'] ??= "",
      leichtgewicht: json['leichtgewicht'] ??= false,
      geschlecht: json['geschlecht']['geschlecht'] ??= "",
      bootsklasse: json['bootsklasse'] ??= "",
      altersklasse: json['alterklasse'] ??= "",
      tag: json['tag'] ??= "",
      wettkampf: json['wettkampf'] ??= "",
      anzAbteilungen: json['num_abteilungen'] ??= 0,
      anzMeldungen: json['num_meldungen'] ??= 0,
      startZeit: json['startzeit'] ??= "",
      meldungen: lsMeld,
    );

    return newRennen;
  }
}

