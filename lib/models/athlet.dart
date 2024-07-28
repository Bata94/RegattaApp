import 'package:regatta_app/models/meldung.dart';
import 'package:regatta_app/models/verein.dart';

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

    return Athlet(
      uuid: json['uuid'],
      vorname: json['vorname'],
      name: json['name'],
      vereinUuid: json['verein_uuid'],
      jahrgang: json['jahrgang'],
      geschlecht: json['geschlecht'],
      // TODO: Implement
      startberechtigt: json['startberechtigt'] ??= true,
      gewicht: double.tryParse(json['gewicht'].toString()) ?? 99.99,
      rolle: json['rolle'],
      position: json['position'],
      verein: json.containsKey("verein") ? Verein.fromJson(json['verein']) : null,
      meldungen: lsMeld,
    );
  }
}

