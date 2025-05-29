class Zahlbed {
  final int zbdNr;
  final String zbdBez;

  Zahlbed({
    required this.zbdNr,
    required this.zbdBez,
  });

  factory Zahlbed.fromJson(Map<String, dynamic> json) {
    return Zahlbed(
      zbdNr: json['zbdNr'] ?? 0,
      zbdBez: json['zbdBez'] ?? '',
    );
  }

  factory Zahlbed.leer() {
  return Zahlbed(
    zbdNr: 0,
    zbdBez: '',
  );
}

}
