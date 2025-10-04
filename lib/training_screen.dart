import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'КРАТКОЕ ОБУЧЕНИЕ',
          style: GoogleFonts.pressStart2p(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purple[800],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'img/obuchenie.jpg',
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
