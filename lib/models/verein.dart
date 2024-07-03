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

