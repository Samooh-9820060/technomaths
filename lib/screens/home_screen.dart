import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:technomaths/enums/game_mode.dart';
import 'package:technomaths/screens/wall_of_fame.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart'; // Import shimmer
import 'endless_mode_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.deepPurple, Colors.blueAccent],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.grey,
                child: Text(
                  'TechnoMaths',
                  style: GoogleFonts.fredoka(
                    fontSize: 48,
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
              ),
              SizedBox(height: 60),
              ..._menuItems(context)
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _menuItems(BuildContext context) {
    List<Map<String, dynamic>> items = [
      {
        'title': 'Endless',
        'icon': Icons.loop,
        'onPressed': () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => EndlessModeScreen()))
      },
      {
        'title': 'Wall of Fame',
        'icon': Icons.star,
        'onPressed': () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => WallOfFameScreen(gameMode: GameMode.Addition)))
      },
      {'title': 'Rate the Game', 'icon': Icons.rate_review, 'onPressed': () {}},
      {'title': 'Quit', 'icon': Icons.exit_to_app, 'onPressed': () => SystemNavigator.pop()}
    ];

    return items.map((item) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: ElevatedButton.icon(
          onPressed: item['onPressed'],
          icon: Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: Colors.grey,
            child: Icon(item['icon'], color: Colors.white),
          ),
          label: Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: Colors.grey,
            child: Text(item['title'], style: GoogleFonts.fredoka(fontSize: 18)),
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
