import 'package:flutter/material.dart';
import 'package:parity_web_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  // Token löschen und zurück zur login seite
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

  }
  //Kundendaten aus der API laden und anzeigen
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
        // Sidebar und navigation
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
                          buildMenupunkt('assets/icons/home.png', 'Home', nurIcons),
                          buildMenupunkt('assets/icons/ku.png', 'Kundenübersicht', nurIcons),
                          buildMenupunkt('assets/icons/ap.png', 'Ansprechpartner', nurIcons),
                          buildMenupunkt('assets/icons/ue.png', 'Umsatz/Ertrag', nurIcons),
                          buildMenupunkt('assets/icons/op.png', 'Offene Posten', nurIcons),
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
                                      onChanged: (wert) async {
                                        setState(() {
                                          suchbegriff = wert.toLowerCase();
                                        });

                                      if (kunden.isEmpty) {
                                        print('Suche gestartet - lade Kunden...');
                                        final daten = await ladeKombinierteKunden(); 

                                        setState(() {
                                          kunden = daten;
                                        });
                                      }
                                        setState(() {                 
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
                        // Seiteninhalt
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
                                            ],
                                          ),
                                  );
                                case 'Kundenübersicht':
                                  return ausgewaehlterKunde != null
                                      ? Kundenuebersicht(kunde: ausgewaehlterKunde!)
                                      : const Center(child: Text('Kein Kunde ausgewählt'));

                                case 'Ansprechpartner':
                                  return Ansprechpartner(kunde: ausgewaehlterKunde!);

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

  Widget buildMenupunkt(String imagePath, String label, bool nurIcons) {
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
} 
