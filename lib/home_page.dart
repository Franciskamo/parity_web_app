import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parity_web_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'ansprechpartner.dart';
import 'kundenuebersicht.dart';
import 'api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<KundeMitAdresse> kunden = [];
  bool istLaden = true;

  String currentPage = 'Home';
  String? hoveredPage;
  KundeMitAdresse? ausgewaehlterKunde;
  String suchbegriff = '';
  List<KundeMitAdresse> suchErgebnisse = [];
  bool dropdownSichtbar = false;

  final GlobalKey _topBarKey = GlobalKey();

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('expiresAt');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    ladeKunden();
  }

  Future<void> ladeKunden() async {
    final daten = await ladeKombinierteKunden();
    print('Geladene Kunden: ${daten.length}');
    setState(() {
      kunden = daten;
      istLaden = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double breite = constraints.maxWidth;
        bool nurIcons = breite < 800;
        double sidebarBreite = nurIcons ? 70 : 250;

        return Scaffold(
          backgroundColor: const Color(0xFFF7F7F7),
          body: Row(
            children: [
              Container(
                width: sidebarBreite,
                color: Colors.white,
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          nurIcons ? 'assets/images/logo_icon.png' : 'assets/images/logo.png',
                          width: nurIcons ? 28 : 203,
                          height: nurIcons ? 28 : 64,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Column(
                        children: [
                          _buildMenuItem('assets/icons/home.png', 'Home', nurIcons),
                          _buildMenuItem('assets/icons/ku.png', 'Kundenübersicht', nurIcons),
                          _buildMenuItem('assets/icons/ap.png', 'Ansprechpartner', nurIcons),
                          _buildMenuItem('assets/icons/ue.png', 'Umsatz/Ertrag', nurIcons),
                          _buildMenuItem('assets/icons/op.png', 'Offene Posten', nurIcons),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          key: _topBarKey,
                          color: Colors.white,
                          constraints: const BoxConstraints(
                            minHeight: 40,
                            maxHeight: 50,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 500,
                                      minHeight: 30,
                                      maxHeight: 40,
                                      ),
                                    child: TextField(
                                      cursorHeight: 16,
                                      cursorColor: const Color(0xFF333333),
                                      cursorRadius: Radius.circular(3),
                                      onChanged: (wert) {
                                        setState(() {
                                          suchbegriff = wert.toLowerCase();
                                          suchErgebnisse = kunden.where((k) {
                                            return k.name.toLowerCase().contains(suchbegriff) ||
                                              k.kundennummer.toLowerCase().contains(suchbegriff);
                                          }).toList();
                                          dropdownSichtbar = suchErgebnisse.isNotEmpty && suchbegriff.isNotEmpty;
                                        });
                                      },               
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        hintText: 'Suchen...',
                                        prefixIcon: const Icon(Icons.search),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(color: Color(0xFF333333), width: 0.5),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(color: Color(0xFF333333), width: 2),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              PopupMenuButton<String>(
                                offset: const Offset(0, 40),
                                onSelected: (value) {
                                  if (value == 'logout') {
                                    _logout();
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'logout',
                                    child: Text('Logout'),
                                  ),
                                ],
                                child: const CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Color(0xFFFFE299),
                                  child: Icon(Icons.person, color: Color(0xFF333333)),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: Builder(
                            builder: (context) {
                              switch (currentPage) {
                                case 'Home':
                                  return Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: istLaden
                                        ? const Center(child: CircularProgressIndicator())
                                        : ListView(
                                            children: [
                                              const Text(
                                                'Zuletzt aufgerufen',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              ...kunden.map((kunde) => _buildKundenZeile(
                                                kunde.kundennummer,
                                                kunde.name,
                                                kunde.telefon,
                                                kunde.email,
                                              )),
                                            ],
                                          ),
                                  );
                                case 'Kundenübersicht':
                                  return Kundenuebersicht(kunde: ausgewaehlterKunde);
                                case 'Ansprechpartner':
                                  return const Ansprechpartner();
                                default:
                                  return const Center(child: Text('Seite nicht gefunden'));
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    if (dropdownSichtbar)
                      Positioned(
                        top: 60,
                        left: 16,
                        right: 16,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 200),
                            child: Material(
                              elevation: 2,
                              borderRadius: BorderRadius.circular(8),
                              child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: suchErgebnisse.length,
                                itemBuilder: (context, index) {
                                  final eintrag = suchErgebnisse[index];
                                  return ListTile(
                                    title: Text('[${eintrag.kundennummer}] ${eintrag.name}'),
                                    subtitle: Text(eintrag.telefon),
                                    onTap: () {
                                      setState(() {
                                        ausgewaehlterKunde = eintrag;
                                        currentPage = 'Kundenübersicht';
                                        dropdownSichtbar = false;
                                        suchbegriff = '';
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(String imagePath, String label, bool nurIcons) {
    bool istAktiv = label == currentPage;
    bool istHover = label == hoveredPage;

    return MouseRegion(
      onEnter: (_) => setState(() => hoveredPage = label),
      onExit: (_) => setState(() => hoveredPage = null),
      child: GestureDetector(
        onTap: () => setState(() => currentPage = label),
        child: Container(
          color: istAktiv || istHover ? const Color(0xFFFFE299) : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: 25,
                height: 25,
                fit: BoxFit.contain,
              ),
              if (!nurIcons) ...[
                const SizedBox(width: 16),
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKundenZeile(String nummer, String name, String telefon, String email) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(nummer)),
          Expanded(flex: 4, child: Text(name)),
          Expanded(flex: 3, child: Text(telefon)),
          Expanded(flex: 4, child: Text(email)),
        ],
      ),
    );
  }
} 
