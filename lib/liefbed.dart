class Liefbed {
  final int lbdNr;
  final String lbdBez;

  Liefbed({
    required this.lbdNr,
    required this.lbdBez,
  });

  factory Liefbed.fromJson(Map<String, dynamic> json) {
    return Liefbed(
      lbdNr: json['lbdNr'] ?? 0,
      lbdBez: json['lbdBez'] ?? '',
    );
  }

  static Liefbed leer() => Liefbed(lbdNr: 0, lbdBez: '-');
}
