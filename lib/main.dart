import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Screen',
      theme: ThemeData(
        fontFamily: 'Inter',
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController benutzerController = TextEditingController();
  final TextEditingController passwortController = TextEditingController();

  
  // Login mit Benutzerdaten und speichern des Tokens
  Future<bool> login() async {
  try {
    final url = Uri.parse("https://api.parity-software.com/api/v1/auth/login");
    final benutzer = benutzerController.text;
    final passwort = passwortController.text;

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'login': benutzer,
        'password': passwort,
      }),
    );

    print('Statuscode: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final expiresAtUnix = data['expiresAt'];
      final expiresAt = DateTime.fromMillisecondsSinceEpoch(expiresAtUnix * 1000);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('expiresAt', expiresAt.toIso8601String());

      // Token vor Ablauf automatisch erneuern
      final refreshZeit = expiresAt.difference(DateTime.now()) - const Duration(minutes: 2);
      if (refreshZeit > Duration.zero) {
        Timer(refreshZeit, () {
          refreshToken();
        });
      }

      print('Login erfolgreich!');
      print('Token: $token');
      print('Gültig bis: $expiresAt');
      return true;
    } else {
      print('Login fehlgeschlagen: ${response.statusCode}');
      print('Antwort vom Server: ${response.body}');
      return false;
    }
  } catch (error) {
    print('Fehler beim Login: $error');
    return false;
  }
}


  Future<void> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('https://api.parity-software.com/api/v1/auth/update'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
    },
      body: jsonEncode({
        'token': token,
        'expiresAt': 0,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newtoken = data ['token'];
      final newExpiresAtUnix = data['expiresAt'];
      final newExpiresAt = DateTime.fromMillisecondsSinceEpoch(newExpiresAtUnix * 1000);

      await prefs.setString('token', newtoken);
      await prefs.setString('expiresAt', newExpiresAt.toIso8601String());

      final refreshZeit = newExpiresAt.difference(DateTime.now()) - const Duration(minutes: 2); // Zeit bis Ablauf berechnen
      if (refreshZeit > Duration.zero) { // Timer nur starten wenn noch gültig
        Timer(refreshZeit, () { 
          refreshToken(); 
        });
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double logoHeight = screenWidth < 600 ? screenWidth * 0.3 : screenWidth * 0.25;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: logoHeight,
                  ),
                ),
                TextField(
                  cursorColor: const Color(0xFF333333),
                  controller: benutzerController,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Benutzer',
                    labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                      color: Color(0xFF333333),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(color: Color(0xFF333333)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(color: Color(0xFF333333), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  cursorColor: const Color(0xFF333333),
                  controller: passwortController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Passwort',
                    labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                      color: Color(0xFF333333),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(color: Color(0xFF333333)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(color: Color(0xFF333333), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    print('Login gedrückt');
                    print('Benutzer: ${benutzerController.text}');
                    print('Passwort: ${passwortController.text}');

                    bool success = await login();
                    if (success) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Login fehlgeschlagen')),
                      );
                    }

                  },

                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(const Color(0xFFFFCD00)),
                    foregroundColor: WidgetStateProperty.all<Color>(const Color(0xFF333333)),
                    elevation: WidgetStateProperty.resolveWith<double>((states) {
                      if (states.contains(WidgetState.hovered)) {
                        return 8.0;
                      }
                      return 0.0;
                    }),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    padding: WidgetStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
