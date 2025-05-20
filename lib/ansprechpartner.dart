import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ansprechpartner.dart';
import 'offene_posten.dart';
import 'umsatz_ertrag.dart';
import 'home_page.dart';

class AnsprechpartnerModel {
  String nachname;
  String vorname;
  String abteilung;
  String telefon;
  String email;
  bool istUpdate;

  AnsprechpartnerModel({
    required this.nachname,
    required this.vorname,
    required this.abteilung,
    required this.telefon,
    required this.email,
    this.istUpdate = false,
  });
}

class Ansprechpartner extends StatefulWidget {
  const Ansprechpartner({Key? key}) : super(key: key);

  @override
  State<Ansprechpartner> createState() => _AnsprechpartnerState();
}

class _AnsprechpartnerState extends State<Ansprechpartner> {
  List<AnsprechpartnerModel> ansprechpartnerListe = [
    AnsprechpartnerModel(
      nachname: 'Heid',
      vorname: 'Franziska',
      abteilung: 'EK Spindeltechnik',
      telefon: '0911/5691-323',
      email: 'ekspindeln@gmn.de',
    ),
    AnsprechpartnerModel(
      nachname: 'Müller',
      vorname: 'Anna',
      abteilung: 'Vertrieb',
      telefon: '0911/5691-111',
      email: 'vertrieb@gmn.de',
    ),
    AnsprechpartnerModel(
      nachname: 'Schmidt',
      vorname: 'Lukas',
      abteilung: 'IT Support',
      telefon: '0911/5691-222',
      email: 'itsupport@gmn.de',
    ),
    AnsprechpartnerModel(
      nachname: 'Keller',
      vorname: 'Julia',
      abteilung: 'Marketing',
      telefon: '0911/5691-444',
      email: 'marketing@gmn.de',
    ),
    AnsprechpartnerModel(
      nachname: 'Weber',
      vorname: 'Tom',
      abteilung: 'Buchhaltung',
      telefon: '0911/5691-555',
      email: 'buchhaltung@gmn.de',
    ),
  ];

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
          const Text(
            "GMN Paul Müller Industrie GmbH & Co. KG",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            "2184000",
            style: TextStyle(fontSize: 16, color: Colors.grey),
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
                  final ap = eintrag.value;

                  if (ap.istUpdate) {
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
                                  final nachname = nachnameCtrl.text.trim();
                                  final vorname = vornameCtrl.text.trim();
                                  final abteilung = abteilungCtrl.text.trim();
                                  final telefon = telefonCtrl.text.trim();
                                  final email = emailCtrl.text.trim();

                                  // Validierung: Name muss vorhanden sein + Telefon oder E-Mail
                                  if (nachname.isEmpty || vorname.isEmpty || (telefon.isEmpty && email.isEmpty)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Bitte Vorname, Nachname und entweder Telefon oder E-Mail angeben."),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  setState(() {
                                    ap.nachname = nachname;
                                    ap.vorname = vorname;
                                    ap.abteilung = abteilung;
                                    ap.telefon = telefon;
                                    ap.email = email;
                                    ap.istUpdate = false;
                                  });
                                },

                              ),
                              IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () {
                                  setState(() {
                                    final istNeu = ap.nachname.isEmpty &&
                                        ap.vorname.isEmpty &&
                                        ap.abteilung.isEmpty &&
                                        ap.telefon.isEmpty &&
                                        ap.email.isEmpty;

                                    if (istNeu) {
                                      ansprechpartnerListe.remove(ap); // eintrag löschen
                                    } else {
                                      ap.istUpdate = false; // nur Bearbeiten abbrechen
                                    }
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
                                        visualDensity: VisualDensity.compact,
                                        hoverColor: Colors.transparent,
                                        // splashColor: Colors.transparent,
                                        // highlightColor: Colors.transparent,
                                        onPressed: () {
                                          setState(() {
                                            ap.istUpdate = true;
                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, size: 16),
                                        hoverColor: Colors.transparent,
                                        // splashColor: Colors.transparent,
                                        // highlightColor: Colors.transparent,
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
                            "${ap.vorname} ${ap.nachname}",
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
                                      hoverColor: Colors.transparent,
                                      // splashColor: Colors.transparent,
                                      // highlightColor: Colors.transparent,
                                      onPressed: () {
                                        setState(() {
                                          ap.istUpdate = true;
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, size: 16),
                                      hoverColor: Colors.transparent,
                                      // splashColor: Colors.transparent,
                                      // highlightColor: Colors.transparent,
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
                const SizedBox(height: 1),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      ansprechpartnerListe.add(
                        AnsprechpartnerModel(
                          nachname: '',
                          vorname: '',
                          abteilung: '',
                          telefon: '',
                          email: '',
                          istUpdate: true, 
                        ),
                      );
                    });
                  },
                  icon: const Icon(Icons.add, color: Color(0xFF333333),),
                  label: const Text(
                    'Neuen Ansprechpartner anlegen',
                    style: TextStyle(color: Color(0xFF333333)),
                  ),
                  style: ButtonStyle(
                    overlayColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                      if (states.contains(WidgetState.hovered)) return Colors.transparent;
                      return null;
                    }),
                  ),

                ),
              ],
            ),
          )
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
              "$label:",
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
              "$label:",
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
