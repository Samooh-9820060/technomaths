  import 'package:flutter/material.dart';
  import 'package:google_fonts/google_fonts.dart';
  import 'package:flutter_shimmer/flutter_shimmer.dart';
  import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import the font_awesome_flutter package
  import 'package:shimmer/shimmer.dart';
  import 'package:technomaths/widgets/animated_buttons.dart';
  import 'package:technomaths/screens/game_screen.dart';
  import 'package:technomaths/enums/game_mode.dart';
  import 'package:technomaths/enums/game_speed.dart';

  class EndlessModeScreen extends StatelessWidget {
    const EndlessModeScreen({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.deepPurple, Colors.blueAccent],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: AppBar().preferredSize.height),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    LogoShimmer(),
                    SizedBox(height: 30),
                    ..._buildModeButtons(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    List<Widget> _buildModeButtons(BuildContext context) {
      List<Map<String, dynamic>> modes = [
        {'title': 'Addition', 'gameMode': GameMode.Addition, 'icon': FontAwesomeIcons.plus},
        {'title': 'Subtraction', 'gameMode': GameMode.Subtraction, 'icon': FontAwesomeIcons.minus},
        {'title': 'Multiplication', 'gameMode': GameMode.Multiplication, 'icon': FontAwesomeIcons.times},
        {'title': 'Division', 'gameMode': GameMode.Division, 'icon': FontAwesomeIcons.divide},
        {'title': 'All', 'gameMode': GameMode.All, 'icon': FontAwesomeIcons.infinity},
      ];

      return modes.map((mode) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameScreen(
                    gameMode: mode['gameMode'],
                    gameSpeed: GameSpeed.fifteen,
                  ),
                ),
              );
            },
            icon: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: Colors.grey,
              child: Icon(mode['icon'], color: Colors.white),
            ),
            label: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: Colors.grey,
              child: Text(mode['title'], style: GoogleFonts.fredoka(fontSize: 18, color: Colors.white)),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.deepPurple,
              onPrimary: Colors.red,
              textStyle: TextStyle(fontSize: 18),
              elevation: 5.0,
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              side: BorderSide(color: Colors.blueAccent, width: 2),
            ),
          ),
        );
      }).toList();
    }
  }

  class LogoShimmer extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Shimmer.fromColors(
        baseColor: Colors.white,
        highlightColor: Colors.grey,
        child: Text(
          'Choose Mode',
          style: GoogleFonts.fredoka(
            fontSize: 36,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black.withOpacity(0.5),
                offset: Offset(5.0, 5.0),
              ),
            ],
          ),
        ),
      );
    }
  }
