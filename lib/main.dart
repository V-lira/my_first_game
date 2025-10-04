import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sleeping_pony_widget.dart';
import 'level_select_screen.dart';
import 'training_screen.dart';
import 'settings_screen.dart';
import 'progress_screen.dart';
import 'skin_selected_screen.dart';
import 'package:audioplayers/audioplayers.dart';

final AudioPlayer audioPlayer = AudioPlayer();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await audioPlayer.setReleaseMode(ReleaseMode.loop);
  //await audioPlayer.play(AssetSource('music/background.mp3'));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MenuScreen(),
    );
  }
}

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  double startScale = 1.0;
  double trainingScale = 1.0;
  double settingsScale = 1.0;
  double progressScale = 1.0;
  double skinScale = 1.0;
 @override
  void initState() {
    super.initState();
    _initMusic();
  }
Future<void> _initMusic() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    bool isMusicOn = prefs.getBool('music') ?? true;

    if (isMusicOn) {
      await audioPlayer.setReleaseMode(ReleaseMode.loop);
      await audioPlayer.play(AssetSource('background.wav'));
    }
  } 
  catch (e) 
  {
    print('Error: $e');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'img/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: SleepingPonyWidget(),
          ),
          Positioned(
            top: 20,
            right: 10,
            child: MouseRegion(
              onEnter: (_) => _updateScale(1.1, 'skin'),
              onExit: (_) => _updateScale(1.0, 'skin'),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SkinSelectScreen()),
                  );
                },
                child: Transform.scale(
                  scale: skinScale,
                  child: Image.asset(
                    'img/skin_icon.png',
                    width: 90,
                    height: 90,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 10,
            child: MouseRegion(
              onEnter: (_) => _updateScale(1.1, 'progress'),
              onExit: (_) => _updateScale(1.0, 'progress'),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProgressScreen()),
                  );
                },
                child: Transform.scale(
                  scale: progressScale,
                  child: Image.asset(
                    'img/progress.png',
                    width: 75,
                    height: 75,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 159),
                  Text(
                    'FLYING PONI',
                    style: GoogleFonts.pressStart2p(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 163, 110, 165),
                      shadows: [
                        Shadow(
                          offset: Offset(5, 5),
                          color: Color.fromARGB(255, 243, 179, 245),
                        ),
                        Shadow(
                          offset: Offset(-5, -5),
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildButton(
                    assetPath: 'img/button_start.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LevelSelectScreen()),
                      );
                    },
                    scale: startScale,
                    onEnter: () => _updateScale(1.1, 'start'),
                    onExit: () => _updateScale(1.0, 'start'),
                  ),
                  SizedBox(height: 20),
                  _buildButton(
                    assetPath: 'img/button_obuchenie.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => TrainingScreen()),
                      );
                    },
                    scale: trainingScale,
                    onEnter: () => _updateScale(1.1, 'training'),
                    onExit: () => _updateScale(1.0, 'training'),
                  ),
                  SizedBox(height: 20),
                  _buildButton(
                    assetPath: 'img/button_settings.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SettingsScreen()),
                      );
                    },
                    scale: settingsScale,
                    onEnter: () => _updateScale(1.1, 'settings'),
                    onExit: () => _updateScale(1.0, 'settings'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String assetPath,
    required VoidCallback onTap,
    required double scale,
    required VoidCallback onEnter,
    required VoidCallback onExit,
  }) 
  {
    return MouseRegion(
      onEnter: (_) => onEnter(),
      onExit: (_) => onExit(),
      child: GestureDetector(
        onTap: onTap,
        child: Transform.scale(
          scale: scale,
          child: Image.asset(
            assetPath,
            width: 300,
            height: 120,
          ),
        ),
      ),
    );
  }

  void _updateScale(double scale, String key) {
    setState(() {
      if (key == 'start') startScale = scale;
      if (key == 'training') trainingScale = scale;
      if (key == 'settings') settingsScale = scale;
      if (key == 'progress') progressScale = scale;
      if (key == 'skin') skinScale = scale;
    });
  }
}
