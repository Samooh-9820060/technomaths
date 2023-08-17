import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:technomaths/config/game_mode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../database/database_helper.dart';
import '../config/ad_config.dart';
import '../utils/commonFunctions.dart';

class WallOfFameScreen extends StatefulWidget {
  GameMode gameMode;

  WallOfFameScreen({
    Key? key,
    required this.gameMode,
  }) : super(key: key);

  @override
  _WallOfFameScreenState createState() => _WallOfFameScreenState();
}

class _WallOfFameScreenState extends State<WallOfFameScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> scores = [];
  List<Map<String, dynamic>> scores24h = [];
  List<Map<String, dynamic>> allTimeScores = [];
  List<Map<String, dynamic>> personalScores = [];
  late TabController _tabController;
  int bestScore = 0;
  int bestScoreRank = 0;

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  int rowsPerPage = 10; // Number of rows to show per page
  int totalCount = 0;
  int initialRow = 0;
  int _tableKey = 0;
  DocumentSnapshot? lastDocumentAllTime;

  GameMode selectedMode = GameMode.Addition;

  //loading variables
  bool _isLoadingAllTimeNextPage = false;

  // Load scores from the database upon initialization
  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
    selectedMode = widget.gameMode;
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _loadScores();
  }

  void _handleTabSelection() {
    var previousMode;
    if (_tabController.indexIsChanging || previousMode != selectedMode) {
      setState(() {
        initialRow = 0; // reset the initial row index
      });
      //reset the scores
      bestScoreRank = 0;
      bestScore = 0;
      previousMode = selectedMode;
      switch (_tabController.index) {
        case 0: // Local
          _loadScores(); // This fetches scores from local db
          break;
        case 1: // 24h
          _load24hScores().then((fetchedScores) {
            setState(() {
              scores24h = fetchedScores;
            });
          }); // Fetches 24-hour scores from Firestore
          _buildScoreList(scores24h, selectedMode, '24h');
          break;
        case 2: // All Time
          _loadAllTimeScores().then((fetchedScores) {
            setState(() {
              allTimeScores = fetchedScores;
            });
          });
          _buildScoreList(allTimeScores, selectedMode, 'All Time');
          break;
      }
    }
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: commonFunctions.getAdUnitId(AdType.interstitial),
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            showAd();
          },
          onAdFailedToLoad: (LoadAdError error) {
            _interstitialAd = null;
            _numInterstitialLoadAttempts += 1;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }
  void showAd() {
    var rng = new Random();
    if (rng.nextInt(100) < 30) {
      if (_interstitialAd == null) {
        return;
      }
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        //_createInterstitialAd();  // Load another ad for next time
      }, onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        //_createInterstitialAd();  // Load another ad for next time
      });

      _interstitialAd!.show();
    }
  }

  Future<void> _loadScores() async {
    List<Map<String, dynamic>> dbRows = await DatabaseHelper.instance
        .queryRowsByGameMode(selectedMode.toString());
    // Create a new list from the database result to avoid read-only issues
    List<Map<String, dynamic>> rows = List.from(dbRows);
    totalCount = rows.length;

    rows.sort((a, b) {
      int compareScore = b['score'].compareTo(a['score']);

      if (compareScore == 0) {
        return a['timeElapsed'].compareTo(b['timeElapsed']);
      }

      return compareScore;
    });

    setState(() {
      scores = rows;
    });
  }
  Future<List<Map<String, dynamic>>> _load24hScores() async {
    final endTime = DateTime.now().add(Duration(minutes: 1));
    final startTime = endTime.subtract(Duration(hours: 24));
    String startIsoString = startTime.toIso8601String();
    String endIsoString = endTime.toIso8601String();

    //filter and get the 24h scores that falls in the time limit
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('endlessModeGameData')
        .where('gameMode', isEqualTo: selectedMode.toString())
        .where('datetime', isGreaterThanOrEqualTo: startIsoString)
        .where('datetime', isLessThanOrEqualTo: endIsoString)
        .get();

    totalCount = snapshot.size;
    List<Map<String, dynamic>> fetchedScores =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    fetchedScores.sort((a, b) {
      int compareScore = b['score'].compareTo(a['score']);

      if (compareScore == 0) {
        return a['timeElapsed'].compareTo(b['timeElapsed']);
      }

      return compareScore;
    });

    //get personal best and rank
    String deviceUUID = await commonFunctions.getDeviceUUID();
    int highestScoreForUUID = 0;
    int rankForUUID = -1;

    for (int i = 0; i < fetchedScores.length; i++) {
      Map<String, dynamic> entry = fetchedScores[i];
      if (entry['deviceUID'] == deviceUUID) {
        if (entry['score'] > highestScoreForUUID) {
          highestScoreForUUID = entry['score'];
          rankForUUID = i + 1; // +1 because list index starts at 0
        }
      }
    }

    if (highestScoreForUUID != 0 && rankForUUID != -1) {
      bestScore = highestScoreForUUID;
      bestScoreRank = rankForUUID;
    }
    totalCount = fetchedScores.length;
    return fetchedScores;
  }
  Future<List<Map<String, dynamic>>> _loadAllTimeScores() async {
    //get total count and update it
    AggregateQuerySnapshot countSnapshot = await FirebaseFirestore.instance
        .collection('endlessModeGameData')
        .where('gameMode', isEqualTo: selectedMode.toString())
        .count()
        .get();
    totalCount = countSnapshot.count;

    Query query = FirebaseFirestore.instance
        .collection('endlessModeGameData')
        .where('gameMode', isEqualTo: selectedMode.toString())
        .orderBy('score', descending: true)
        .orderBy('timeElapsed')
        .limit(rowsPerPage);

    QuerySnapshot snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      lastDocumentAllTime = snapshot.docs.last;
    }

    List<Map<String, dynamic>> fetchedScores =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    return fetchedScores;
  }
  Future<void> _loadNextPage() async {
    if (lastDocumentAllTime == null) {
      // We're already at the beginning, so just return
      return;
    }

    if (_isLoadingAllTimeNextPage) return;
    _isLoadingAllTimeNextPage = true;
    Query query = FirebaseFirestore.instance
        .collection('endlessModeGameData')
        .where('gameMode', isEqualTo: selectedMode.toString())
        .orderBy('score', descending: true)
        .orderBy('timeElapsed')
        .limit(rowsPerPage)
        .startAfterDocument(lastDocumentAllTime!);

    QuerySnapshot snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      lastDocumentAllTime = snapshot.docs.last;
      List<Map<String, dynamic>> newScores = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Assuming scores is a member variable, update it
      allTimeScores.addAll(newScores);

      // Trigger a rebuild so that the new scores are reflected
      setState(() {});
    }
    _isLoadingAllTimeNextPage = false;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title:
                Text('Wall of Fame', style: GoogleFonts.fredoka(fontSize: 22)),
            // Use a different font
            backgroundColor: Colors.deepPurple,
            // Gradient start color
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
              controller: _tabController,
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
                colors: [
                  Colors.blueAccent.withOpacity(0.2),
                  Colors.deepPurple.withOpacity(0.2)
                ],
              ),
            ),
            child: Stack(
              children: [
                TabBarView(
                  controller: _tabController,
                  children: [
                    _buildScoreList(scores, selectedMode, 'local'),
                    _buildScoreList(scores24h, selectedMode, '24h'),
                    _buildScoreList(allTimeScores, selectedMode, 'allTime'),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildScoreList(
      List<Map<String, dynamic>> scores, GameMode mode, String tabType) {
    return FutureBuilder(
        // Delay for 2 seconds
        future: Future.delayed(Duration(seconds: 2), () => scores),
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          var filteredScores = scores;
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            filteredScores = scores;
          }

          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
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
              child: Column(
                children: [
                  if (tabType != 'local' &&
                      bestScore != 0 &&
                      bestScoreRank != 0)
                    Container(
                      margin: EdgeInsets.only(bottom: 16.0),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.amber[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Your Best Score: ${bestScore}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text("Rank: $bestScoreRank"),
                        ],
                      ),
                    ),
                  PaginatedDataTable(
                    key: ValueKey(_tableKey),
                    rowsPerPage: rowsPerPage,
                    initialFirstRowIndex: initialRow,
                    header: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Scores',
                            style: GoogleFonts.fredoka(
                                fontWeight: FontWeight.bold, fontSize: 24),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
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
                                initialRow = 0;
                                _tableKey++;
                              });
                              _handleTabSelection();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  selectedMode.toString().split('.').last,
                                  style: GoogleFonts.fredoka(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                              ],
                            ),
                            itemBuilder: (BuildContext context) =>
                                GameMode.values.map((GameMode mode) {
                              return PopupMenuItem<GameMode>(
                                value: mode,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      mode.toString().split('.').last,
                                      style: GoogleFonts.fredoka(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Icon(_getIconForMode(mode),
                                        color: Colors.deepPurple),
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
                        label: Center(
                            child: Text('#',
                                style: GoogleFonts.fredoka(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                      ),
                      DataColumn(
                        label: Center(
                            child: Text('Name',
                                style: GoogleFonts.fredoka(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                      ),
                      DataColumn(
                        label: Center(
                            child: Text('Score',
                                style: GoogleFonts.fredoka(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                      ),
                      DataColumn(
                        label: Center(
                            child: Text('Time',
                                style: GoogleFonts.fredoka(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                      ),
                    ],
                    source: _DataTableSource(
                        filteredScores, totalCount, _loadNextPage),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

IconData _getIconForMode(GameMode mode) {
  switch (mode) {
    case GameMode.Addition:
      return Icons.add_circle_outline;
    case GameMode.Subtraction:
      return Icons.remove_circle_outline;
    case GameMode.Multiplication:
      return Icons
          .close; // using the 'close' icon which looks like a multiplication sign (x)
    case GameMode.Division:
      return Icons
          .horizontal_split; // using the 'horizontal_split' which can represent division
    case GameMode.Mix:
      return Icons.all_inclusive; // a general icon to represent 'all'
    default:
      return Icons.help_outline;
  }
}

class _DataTableSource extends DataTableSource {
  final List<Map<String, dynamic>> scores;
  final int totalCount;
  final VoidCallback loadNextPage;

  _DataTableSource(this.scores, this.totalCount, this.loadNextPage);

  @override
  DataRow? getRow(int index) {
    if (index >= scores.length && index <= totalCount) {
      // Fetch the next page of data
      loadNextPage();
      return null; // Return null for now, data will be updated when fetched
    }
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
  int get rowCount => totalCount;

  @override
  int get selectedRowCount => 0;
}
