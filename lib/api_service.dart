import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'adresse.dart';
import 'kunde.dart';
import 'zahlbed.dart';
import 'liefbed.dart';
import 'versart.dart';
import 'anspr.dart';

class KundeMitAdresse {
  final int kdnLfdnr;
  final int id;
  final String kundennummer;
  final String name;
  final String strasse;
  final String plz;
  final String ort;
  final String land;
  final String telefon;
  final String fax;
  final String email;
  final String homepage;
  final String zahlungsNr;
  final String zahlungsText;
  final String lieferNr;
  final String lieferText;
  final String versandNr;
  final String versandText;
  final List<AnsprechpartnerModel> ansprechpartner;

  KundeMitAdresse({
    required this.kdnLfdnr,
    required this.id,
    required this.kundennummer,
    required this.name,
    required this.strasse,
    required this.plz,
    required this.ort,
    required this.land,
    required this.telefon,
    required this.fax,
    required this.email,
    required this.homepage,
    required this.zahlungsNr,
    required this.zahlungsText,
    required this.lieferNr,
    required this.lieferText,
    required this.versandNr,
    required this.versandText,
    required this.ansprechpartner,
  });
}

Future<List<AnsprechpartnerModel>> ladeAnsprechpartner(String kundenId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final headers = {'Authorization': 'Bearer $token'};

  print('Lade Ansprechpartner für KundenID: $kundenId');

  final response = await http.get(
    Uri.parse('https://api.parity-software.com/api/v1/ansprechpartner/$kundenId'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    final decoded = json.decode(response.body);
    return (decoded as List).map((e) => AnsprechpartnerModel(
      nachname: e['anpAnspr'] ?? '',
      vorname: e['anpVorname'] ?? '',
      abteilung: e['anpAbteilung'] ?? '',
      telefon: e['anpTelefon'] ?? '',
      email: e['anpEmail'] ?? '',
    )).toList();
  } else {
    throw Exception("Fehler beim Laden: ${response.statusCode}");
  }
}

Future<List<Kunde>> sucheKunden() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final headers = {'Authorization': 'Bearer $token'};
  

  final kundenResponse = await http.get(
    Uri.parse('https://api.parity-software.com/api/v1/kunden'),
    headers: headers,
  );
  final adressenResponse = await http.get(
    Uri.parse('https://api.parity-software.com/api/v1/adressen'),
    headers: headers,
  );

  if (kundenResponse.statusCode == 200 && adressenResponse.statusCode == 200) {
    final kundenJson = json.decode(kundenResponse.body);
    print('Rohdaten erster Kunde: ${kundenJson[0]}');
    final adressenJson = json.decode(adressenResponse.body);

    final kunden = (kundenJson as List).map((k) => Kunde.fromJson(k)).toList();
    final adressen = (adressenJson as List).map((a) => Adresse.fromJson(a)).toList();

    for (var kunde in kunden) {
      final adresse = adressen.firstWhere(
        (a) => a.ansnr == kunde.id,
        orElse: () => Adresse.leer(),
      );
      kunde.name = adresse.name;
      print('Kunde: ${kunde.kontonummer}, kdnLfdnr: ${kunde.kdnLfdnr}');
    }

    return kunden;
  } else {
    throw Exception('Fehler beim Laden der Kunden oder Adressen');
  }
}

Future<KundeMitAdresse> ladeKundeMitAdresse(Kunde kunde) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final headers = {'Authorization': 'Bearer $token'};

  final adressenResponse = await http.get(
    Uri.parse('https://api.parity-software.com/api/v1/adressen'),
    headers: headers,
  );
  final adressenJson = json.decode(adressenResponse.body);
  final adressen = (adressenJson as List).map((a) => Adresse.fromJson(a)).toList();
  final adresse = adressen.firstWhere(
    (a) => a.ansnr == kunde.id,
    orElse: () => Adresse.leer(),
  );

  final ansprechpartnerListe = <AnsprechpartnerModel>[];

  Zahlbed zahlung;
  try {
    final r = await http.get(
      Uri.parse('https://api.parity-software.com/api/v1/zahlungsbedingungen/${kunde.kdnZbnr}'),
      headers: headers,
    );
    zahlung = r.statusCode == 200 ? Zahlbed.fromJson(json.decode(r.body)[0]) : Zahlbed.leer();
  } catch (_) {
    zahlung = Zahlbed.leer();
  }

  Liefbed liefer;
  try {
    final r = await http.get(
      Uri.parse('https://api.parity-software.com/api/v1/lieferbedingungen/${kunde.kdnLbdnr}'),
      headers: headers,
    );
    liefer = r.statusCode == 200 ? Liefbed.fromJson(json.decode(r.body)[0]) : Liefbed.leer();
  } catch (_) {
    liefer = Liefbed.leer();
  }

  Versart versand;
  try {
    final r = await http.get(
      Uri.parse('https://api.parity-software.com/api/v1/versandarten/${kunde.kdnVsanr}'),
      headers: headers,
    );
    versand = r.statusCode == 200 ? Versart.fromJson(json.decode(r.body)[0]) : Versart.leer();
  } catch (_) {
    versand = Versart.leer();
  }

  return KundeMitAdresse(
    kdnLfdnr: kunde.kdnLfdnr,
    id: kunde.id,
    kundennummer: kunde.kontonummer,
    name: adresse.name,
    strasse: adresse.strasse,
    plz: adresse.plz,
    ort: adresse.ort,
    land: adresse.land,
    telefon: adresse.telefon,
    fax: adresse.telefax,
    email: adresse.email,
    homepage: adresse.homepage,
    zahlungsNr: zahlung.zbdNr.toString(),
    zahlungsText: zahlung.zbdBez,
    lieferNr: liefer.lbdNr.toString(),
    lieferText: liefer.lbdBez,
    versandNr: versand.vsaNr.toString(),
    versandText: versand.vsaBez,
    ansprechpartner: ansprechpartnerListe,
  );
}
