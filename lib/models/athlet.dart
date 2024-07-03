import 'package:regatta_app/models/meldung.dart';
import 'package:regatta_app/models/verein.dart';

class Athlet {
  final String id;
  final String vorname;
  final String name;
  final String vereinId;
  final String jahrgang;
  final String geschlecht;
  final bool startberechtigt;
  final double gewicht;
  final List<Meldung> meldungen;
  final Verein? verein;

  Athlet({
    required this.id,
    required this.vorname,
    required this.name,
    required this.vereinId,
    required this.jahrgang,
    required this.geschlecht,
    required this.startberechtigt,
    required this.gewicht,
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
      id: json['id'],
      vorname: json['vorname'],
      name: json['name'],
      vereinId: json['verein_id'],
      jahrgang: json['jahrgang'],
      geschlecht: json['geschlecht'],
      // TODO: Implement
      startberechtigt: json['startberechtigt'] ??= true,
      gewicht: json['gewicht'],
      verein: json.containsKey("Verein") ? Verein.fromJson(json['Verein']) : null,
      meldungen: lsMeld,
    );
  }
}

