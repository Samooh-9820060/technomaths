import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:technomaths/enums/game_mode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../database/database_helper.dart';

class WallOfFameScreen extends StatefulWidget {
  GameMode gameMode;

  WallOfFameScreen({
    Key? key,
    required this.gameMode,
  }) : super(key: key);

  @override
  _WallOfFameScreenState createState() => _WallOfFameScreenState();
}

class _WallOfFameScreenState extends State<WallOfFameScreen> {

  List<Map<String, dynamic>> scores = [];
  List<Map<String, dynamic>> scores24h = [];
  List<Map<String, dynamic>> allTimeScores = [];

  int rowsPerPage = 10; // Number of rows to show per page
  GameMode selectedMode = GameMode.Addition;

  // Load scores from the database upon initialization
  @override
  void initState() {
    super.initState();
    selectedMode = widget.gameMode;
    _loadScores();  // for local scores
    _load24hScores().then((fetchedScores) {
      setState(() {
        scores24h = fetchedScores;
      });
    });
    _loadAllTimeScores().then((fetchedScores) {
      setState(() {
        allTimeScores = fetchedScores;
      });
    });
  }


  Future<List<Map<String, dynamic>>> _load24hScores() async {
    final endTime = DateTime.now().add(Duration(minutes: 1));
    final startTime = endTime.subtract(Duration(hours: 24));

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('endlessModeGameData')
        .where('datetime', isGreaterThan: startTime.toIso8601String())
        .where('datetime', isLessThan: endTime.toIso8601String())
        .get();

    List<Map<String, dynamic>> fetchedScores = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    fetchedScores.sort((a, b) {
      int compareScore = b['score'].compareTo(a['score']);

      if (compareScore == 0) {
        return a['timeElapsed'].compareTo(b['timeElapsed']);
      }

      return compareScore;
    });

    return fetchedScores;
  }

  Future<List<Map<String, dynamic>>> _loadAllTimeScores() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('endlessModeGameData')
        .get();

    List<Map<String, dynamic>> fetchedScores = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    fetchedScores.sort((a, b) {
      int compareScore = b['score'].compareTo(a['score']);

      if (compareScore == 0) {
        return a['timeElapsed'].compareTo(b['timeElapsed']);
      }

      return compareScore;
    });

    return fetchedScores;
  }

  Future<void> _loadScores() async {
    List<Map<String, dynamic>> dbRows = await DatabaseHelper.instance.queryAllRows();
    // Create a new list from the database result to avoid read-only issues
    List<Map<String, dynamic>> rows = List.from(dbRows);

    rows.sort((a, b) {
      int compareScore = b['score'].compareTo(a['score']);

      if (compareScore == 0) {
        // Assuming 'timeElapsed' is in format 'mm:ss', you can compare as strings
        // because '05:00' < '06:00' and '05:01' < '05:02'
        return a['timeElapsed'].compareTo(b['timeElapsed']);
      }

      return compareScore;
    });

    setState(() {
      scores = rows;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Wall of Fame', style: GoogleFonts.fredoka(fontSize: 22)), // Use a different font
          backgroundColor: Colors.deepPurple, // Gradient start color
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.deepPurple, Colors.blueAccent],
              ),
            ),
          ),
          bottom: TabBar(
            indicatorColor: Colors.yellowAccent,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Local'),
              Tab(icon: Icon(Icons.access_time), text: '24h'),
              Tab(icon: Icon(Icons.stars), text: 'All Time'),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blueAccent.withOpacity(0.2), Colors.deepPurple.withOpacity(0.2)],
            ),
          ),
          child: TabBarView(
            children: [
              _buildScoreList(scores, selectedMode),
              _buildScoreList(scores24h, selectedMode),
              _buildScoreList(allTimeScores, selectedMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreList(List<Map<String, dynamic>> scores, GameMode mode) {
    var filteredScores = scores.where((score) => score['gameMode'] == mode.toString()).toList();

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0), // Slightly increased padding
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: PaginatedDataTable(
          header: Row(
            children: [
              Expanded(
                child: Text(
                  'Scores',
                  style: GoogleFonts.fredoka(fontWeight: FontWeight.bold, fontSize: 24),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.blueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: PopupMenuButton<GameMode>(
                  onSelected: (GameMode mode) {
                    setState(() {
                      selectedMode = mode;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedMode.toString().split('.').last,
                        style: GoogleFonts.fredoka(fontWeight: FontWeight.normal, fontSize: 18, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_drop_down, color: Colors.white),
                    ],
                  ),
                  itemBuilder: (BuildContext context) => GameMode.values.map((GameMode mode) {
                    return PopupMenuItem<GameMode>(
                      value: mode,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            mode.toString().split('.').last,
                            style: GoogleFonts.fredoka(fontWeight: FontWeight.normal, fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Icon(_getIconForMode(mode), color: Colors.deepPurple),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          columns: [
            DataColumn(
              label: Center(child: Text('#', style: GoogleFonts.fredoka(fontWeight: FontWeight.bold, fontSize: 18))),
            ),
            DataColumn(
              label: Center(child: Text('Name', style: GoogleFonts.fredoka(fontWeight: FontWeight.bold, fontSize: 18))),
            ),
            DataColumn(
              label: Center(child: Text('Score', style: GoogleFonts.fredoka(fontWeight: FontWeight.bold, fontSize: 18))),
            ),
            DataColumn(
              label: Center(child: Text('Time', style: GoogleFonts.fredoka(fontWeight: FontWeight.bold, fontSize: 18))),
            ),
          ],
          source: _DataTableSource(filteredScores),
        ),
      ),
    );
  }
}

IconData _getIconForMode(GameMode mode) {
  switch (mode) {
    case GameMode.Addition:
      return Icons.add_circle_outline;
    case GameMode.Subtraction:
      return Icons.remove_circle_outline;
    case GameMode.Multiplication:
      return Icons.close;  // using the 'close' icon which looks like a multiplication sign (x)
    case GameMode.Division:
      return Icons.horizontal_split;  // using the 'horizontal_split' which can represent division
    case GameMode.All:
      return Icons.all_inclusive;  // a general icon to represent 'all'
    default:
      return Icons.help_outline;
  }
}

class _DataTableSource extends DataTableSource {
  final List<Map<String, dynamic>> scores;

  _DataTableSource(this.scores);

  @override
  DataRow getRow(int index) {
    return DataRow(
      cells: [
        DataCell(Center(child: Text((index + 1).toString()))),
        DataCell(Center(child: Text(scores[index]['name']))),
        DataCell(Center(child: Text(scores[index]['score'].toString()))),
        DataCell(Center(child: Text(scores[index]['timeElapsed']))),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => scores.length;

  @override
  int get selectedRowCount => 0;
}