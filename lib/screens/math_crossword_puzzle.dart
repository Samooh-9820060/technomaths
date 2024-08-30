import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:technomaths/config/ThemeHelper.dart';
import 'package:technomaths/screens/puzzle_modes_screen.dart';
import 'package:technomaths/utils/commonFunctions.dart';

class MathCrosswordPuzzleSettings extends StatefulWidget {
  @override
  _MathCrosswordPuzzleSettingsState createState() => _MathCrosswordPuzzleSettingsState();
}


class _MathCrosswordPuzzleSettingsState extends State<MathCrosswordPuzzleSettings> {

  String currentType = '3x3';

  @override
  Widget build(BuildContext context) {
    final themeColors = ThemeHelper(context);

    var textColorUsed = themeColors.textColor;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: themeColors.iconColor, size: 30),
          onPressed: () async {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PuzzleModesScreen())
            );
          },
        ),
        /*actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0), // Adjust the horizontal padding as needed
            child: IconButton(
              icon: FaIcon(FontAwesomeIcons.trophy, color: themeColors.iconColor, size: 30),
              onPressed: () async {
                await performVibration();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => WallOfFameScreen(
                    gameMode: GameMode.Addition,
                  ),
                ));
              },
            ),
          )
        ],*/
      ),
      body: Container(
        decoration: themeColors.currentTheme.backgroundDecoration(false),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Choose Puzzle Setting',
                style: GoogleFonts.fredoka(fontSize: 30, color: themeColors.headerColor), // Use Google font here
              ),
              const SizedBox(height: 50),
              Text(
                'Puzzle Size',
                style: GoogleFonts.fredoka(fontSize: 20, color: themeColors.textColor),
              ),
              const SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      themeColors.primaryColor,
                      themeColors.secondaryColor
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: PopupMenuButton<String>(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Increased padding
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currentType,
                          style: GoogleFonts.fredoka(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              color: themeColors.btnTextColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_drop_down, color: themeColors.btnTextColor),
                      ],
                    ),
                  ),
                  onSelected: (String type) {
                    setState(() {
                      currentType = type; // Update the state on selection
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    List<String> types = ['Random', '3x3', '4x4', '5x5', '6x6', '7x7'];

                    return types.map((String type) {
                      return PopupMenuItem<String>(
                        value: type,
                        child: Text(
                          type,
                          style: GoogleFonts.fredoka(
                              fontWeight: FontWeight.normal,
                              color: textColorUsed,
                              fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Number Starting (Min):',
                          style: GoogleFonts.fredoka(fontSize: 20, color: themeColors.textColor),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.fredoka(fontSize: 18, color: themeColors.primaryColor),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Min',
                            ),
                            // Example: controller: _minNumberController,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20), // Add space between the two input fields
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Number Ending (Max):',
                          style: GoogleFonts.fredoka(fontSize: 20, color: themeColors.textColor),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.fredoka(fontSize: 18, color: themeColors.primaryColor),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Max',
                            ),
                            // Example: controller: _maxNumberController,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
