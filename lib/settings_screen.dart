import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart'; 
import 'auth_page.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isMusicOn = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    bool? musicPref = prefs.getBool('music');
    if (musicPref == null) {
      await prefs.setBool('music', true);
      musicPref = true;
    }

    setState(() {
      _isMusicOn = musicPref!;
    });
    if (_isMusicOn) {
      if (audioPlayer.state != PlayerState.playing) {
        await audioPlayer.resume();
      }
    } 
    else 
    {
      if (audioPlayer.state == PlayerState.playing) {
        await audioPlayer.pause();
      }
    }
  }
  Future<void> _toggleMusic(bool value) async {
    setState(() {
      _isMusicOn = value;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('music', _isMusicOn);
    if (_isMusicOn)
    {
      await audioPlayer.resume();
    }
    else
    {
      await audioPlayer.pause();
    }
  }
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'НАСТРОЙКИ ИГРЫ',
          style: GoogleFonts.pressStart2p(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 151, 39, 173),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: Text(
                'МУЗОН',
                style: GoogleFonts.pressStart2p(
                  fontSize: 18,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Color.fromARGB(255, 123, 46, 104),
                      blurRadius: 15,
                    ),
                  ],
                ),
              ),
              value: _isMusicOn,
              onChanged: _toggleMusic,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                bool? loggedIn = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => AuthPage()),);
                if (loggedIn == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Успешный вход')),
                  );
                }
              },
              child: Text(
                'Вход / Регистрация',
                style: GoogleFonts.pressStart2p(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}