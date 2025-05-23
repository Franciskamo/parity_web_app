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


Future<List<KundeMitAdresse>> ladeKombinierteKunden() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  final headers = {'Authorization': 'Bearer $token'};
// Kunden und Adressdaten vom Server abrufen
  final kundenResponse = await http.get(
    Uri.parse('https://api.parity-software.com/api/v1/kunden'),
    headers: headers,
  );

  final adressenResponse = await http.get(
    Uri.parse('https://api.parity-software.com/api/v1/adressen'),
    headers: headers,
  );

  final kundenJson = json.decode(kundenResponse.body);
  final adressenJson = json.decode(adressenResponse.body);

  final kunden = (kundenJson as List).map((k) => Kunde.fromJson(k)).toList();
  final adressen = (adressenJson as List).map((a) => Adresse.fromJson(a)).toList();

  List<KundeMitAdresse> kombiniert = [];

  for (Kunde kunde in kunden) {
    Adresse adresse = adressen.firstWhere(
      (a) => a.ansnr == kunde.id,
      orElse: () => Adresse.leer(),
    );

    final ansprechpartnerResponse = await http.get(
      Uri.parse('https://api.parity-software.com/api/v1/ansprechpartner/${kunde.kdnLfdnr}'),
      headers: headers,
    );
    final ansprechpartnerJson = json.decode(ansprechpartnerResponse.body);
    final ansprechpartnerListe = (ansprechpartnerJson as List)
        .map((a) => AnsprechpartnerModel.fromJson(a))
        .toList();

    final zahlbedResponse = await http.get(
      Uri.parse('https://api.parity-software.com/api/v1/zahlungsbedingungen/${kunde.kdnZbnr}'),
      headers: headers,
    );
    final decodedZahlung = json.decode(zahlbedResponse.body);
    final zahlung = Zahlbed.fromJson(decodedZahlung[0]);

    final liefbedResponse = await http.get(
      Uri.parse('https://api.parity-software.com/api/v1/lieferbedingungen/${kunde.kdnLbdnr}'),
      headers: headers,
    );
    final decodedLiefer = json.decode(liefbedResponse.body);
    final liefer = Liefbed.fromJson(decodedLiefer[0]);

    Versart versand = Versart.leer(); // falls keine passende Adresse gefunden

    try {
      final versartResponse = await http.get(
        Uri.parse('https://api.parity-software.com/api/v1/versandarten/${kunde.kdnVsanr}'),
        headers: headers,
      );
      final decodedVersand = json.decode(versartResponse.body);
      versand = Versart.fromJson(decodedVersand[0]);
    } catch (e) {
      print('Versandart konnte nicht geladen werden für Kunde ${kunde.kdnVsanr}');
    }


  kombiniert.add(KundeMitAdresse(
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

  ));
}


  return kombiniert;
}