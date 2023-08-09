import 'package:flutter/material.dart';
import 'package:technomaths/enums/game_mode.dart';

import '../database/database_helper.dart';

class WallOfFameScreen extends StatefulWidget {
  @override
  _WallOfFameScreenState createState() => _WallOfFameScreenState();
}

class _WallOfFameScreenState extends State<WallOfFameScreen> {

  List<Map<String, dynamic>> scores = [];
  int rowsPerPage = 10; // Number of rows to show per page
  GameMode selectedMode = GameMode.Addition;

  // Load scores from the database upon initialization
  @override
  void initState() {
    super.initState();
    _loadScores();
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
          title: Text('Wall of Fame'),
          actions: [
            DropdownButtonHideUnderline(
              child: DropdownButton<GameMode>(
                value: selectedMode,
                dropdownColor: Colors.grey,
                onChanged: (GameMode? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedMode = newValue;
                    });
                  }
                },
                items: GameMode.values.map((GameMode mode) {
                  return DropdownMenuItem<GameMode>(
                    value: mode,
                    child: Text(mode.toString().split('.').last, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
              ),
            )
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Local'),
              Tab(text: '24h'),
              Tab(text: 'All Time'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildScoreList(scores, selectedMode),
            _buildScoreList(scores, selectedMode),
            _buildScoreList(scores, selectedMode),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreList(List<Map<String, dynamic>> scores, GameMode mode) {
    var filteredScores = scores.where((score) => score['gameMode'] == mode.toString()).toList();

    return SingleChildScrollView(
      child: PaginatedDataTable(
        header: Text('Scores'),
        rowsPerPage: rowsPerPage,
        availableRowsPerPage: [10, 20, 30, 50],
        onRowsPerPageChanged: (value) {
          setState(() {
            rowsPerPage = value!;
          });
        },
        columns: [
          DataColumn(
              label: Center(child: Text('#', style: TextStyle(fontWeight: FontWeight.bold)))
          ),
          DataColumn(
              label: Center(child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)))
          ),
          DataColumn(
              label: Center(child: Text('Score', style: TextStyle(fontWeight: FontWeight.bold)))
          ),
          DataColumn(
              label: Center(child: Text('Time', style: TextStyle(fontWeight: FontWeight.bold)))
          ),
        ],
        source: _DataTableSource(filteredScores),
      ),
    );
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