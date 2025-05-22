import 'package:flutter/material.dart';
import 'package:parity_web_app/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'anspr.dart';
import 'dart:convert';


class Ansprechpartner extends StatefulWidget {
  final KundeMitAdresse kunde;
  const Ansprechpartner({Key? key, required this.kunde}) : super(key: key);

  @override
  State<Ansprechpartner> createState() => _AnsprechpartnerState();
}

class _AnsprechpartnerState extends State<Ansprechpartner> {
  List<AnsprechpartnerModel> ansprechpartnerListe = [];
  bool istLaden = true;
  int? bearbeiteIndex;

  @override
  void initState() {
    super.initState();
    ladeAnsprechpartner(); 
  }

  Future<void> ladeAnsprechpartner() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(
      Uri.parse('https://api.parity-software.com/api/v1/ansprechpartner/${widget.kunde.id}'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final liste = (decoded as List)
          .map((e) => AnsprechpartnerModel(
                nachname: e['anpAnspr'] ?? '',
                vorname: e['anpVorname'] ?? '',
                abteilung: e['anpAbteilung'] ?? '',
                telefon: e['anpTelefon'] ?? '',
                email: e['anpEmail'] ?? '',
              ))
          .toList();

      setState(() {
        ansprechpartnerListe = liste;
        istLaden = false;
      });
    } else {
      print("Fehler beim Laden: \${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text("Home", style: TextStyle(color: Color(0xFF333333))),
              Text(" > "),
              Text("Ansprechpartner", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.kunde.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            widget.kunde.kundennummer,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth >= 600) {
                      return Column(
                        children: [
                          Row(
                            children: const [
                              Expanded(flex: 2, child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 2, child: Text('Vorname', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 3, child: Text('Abteilung', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 2, child: Text('Telefon', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 3, child: Text('E-Mail', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 1, child: SizedBox()),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: const Color(0xFFFFCD00),
                          ),
                          const SizedBox(height: 12),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                ...ansprechpartnerListe.asMap().entries.map((eintrag) {
                  final index = eintrag.key;
                  final ap = eintrag.value;

                  if (bearbeiteIndex == index) {
                    final nachnameCtrl = TextEditingController(text: ap.nachname);
                    final vornameCtrl = TextEditingController(text: ap.vorname);
                    final abteilungCtrl = TextEditingController(text: ap.abteilung);
                    final telefonCtrl = TextEditingController(text: ap.telefon);
                    final emailCtrl = TextEditingController(text: ap.email);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoZeileWidget('Nachname', TextField(controller: nachnameCtrl)),
                          _buildInfoZeileWidget('Vorname', TextField(controller: vornameCtrl)),
                          _buildInfoZeileWidget('Abteilung', TextField(controller: abteilungCtrl)),
                          _buildInfoZeileWidget('Telefon', TextField(controller: telefonCtrl)),
                          _buildInfoZeileWidget('E-Mail', TextField(controller: emailCtrl)),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check, size: 18),
                                onPressed: () {
                                  setState(() {
                                    bearbeiteIndex = null; // Nur UI zurücksetzen
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () {
                                  setState(() {
                                    bearbeiteIndex = null;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth >= 600) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: Text(ap.nachname)),
                                Expanded(flex: 2, child: Text(ap.vorname)),
                                Expanded(flex: 3, child: Text(ap.abteilung)),
                                Expanded(flex: 2, child: Text(ap.telefon)),
                                Expanded(flex: 3, child: Text(ap.email)),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 16),
                                        onPressed: () {
                                          setState(() {
                                            bearbeiteIndex = index;
                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, size: 16),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return buildInfoCard(
                            "\${ap.vorname} \${ap.nachname}",
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoZeile("Abteilung", ap.abteilung),
                                _buildInfoZeile("Telefon", ap.telefon),
                                _buildInfoZeile("E-Mail", ap.email),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, size: 16),
                                      onPressed: () {
                                        setState(() {
                                          bearbeiteIndex = index;
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, size: 16),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    );
                  }
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoZeile(String label, String wert) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "\$label:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(wert)),
        ],
      ),
    );
  }

  Widget _buildInfoZeileWidget(String label, Widget widget) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "\$label:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: widget),
        ],
      ),
    );
  }

  Widget buildInfoCard(String title, Widget content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Container(
            height: 1,
            width: double.infinity,
            color: const Color(0xFFFFCD00),
          ),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }
}
