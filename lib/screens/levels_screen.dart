import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:technomaths/config/extended_theme.dart';
import 'package:technomaths/config/theme_notifier.dart';
import 'package:technomaths/config/themes.dart';
import 'package:technomaths/config/ThemeHelper.dart';
import 'package:technomaths/levels/Basic%20Arithmetic/Counting%20Numbers/1.dart';
import 'package:tuple/tuple.dart';
import 'home_screen.dart';

final Map<String, Map<String, List<Tuple2<String, Widget>>>> categories = {
  'Basic Arithmetic': {
    'Counting numbers': [
      Tuple2('Level 1', lvl1()),
      Tuple2('Level 2', lvl1()),
      Tuple2('Level 3', lvl1()),
      Tuple2('Level 4', lvl1()),
      Tuple2('Level 5', lvl1()),
    ],
    'Addition up to 10': [
      Tuple2('Level 6', lvl1()),
      Tuple2('Level 7', lvl1()),
      Tuple2('Level 8', lvl1()),
      Tuple2('Level 9', lvl1()),
      Tuple2('Level 10', lvl1()),
    ],
    /*'Addition up to 20': List.generate(5, (index) => 'Level ${index + 11}'),
    'Subtraction up to 10': List.generate(5, (index) => 'Level ${index + 16}'),
    'Subtraction up to 20': List.generate(5, (index) => 'Level ${index + 21}'),
    'Multiplication tables 1-5': List.generate(5, (index) => 'Level ${index + 26}'),
    'Multiplication tables 6-10': List.generate(5, (index) => 'Level ${index + 31}'),
    'Basic Division': List.generate(5, (index) => 'Level ${index + 36}'),*/
  },
  /*'Foundations': {
    'Number patterns': List.generate(5, (index) => 'Level ${index + 41}'),
    'Number lines': List.generate(3, (index) => 'Level ${index + 46}'),
    'Place values': List.generate(4, (index) => 'Level ${index + 49}'),
    'Comparing numbers': List.generate(3, (index) => 'Level ${index + 53}'),
  },
  'Fractions and Decimals': {
    'Introduction to fractions': List.generate(4, (index) => 'Level ${index + 56}'),
    'Equivalent fractions': List.generate(4, (index) => 'Level ${index + 60}'),
    'Converting fractions to decimals': List.generate(4, (index) => 'Level ${index + 64}'),
    'Decimal operations': List.generate(4, (index) => 'Level ${index + 68}'),
  },
  'Basic Geometry': {
    'Shapes properties': List.generate(5, (index) => 'Level ${index + 72}'),
    'Perimeter and area': List.generate(5, (index) => 'Level ${index + 77}'),
    'Introduction to angles': List.generate(3, (index) => 'Level ${index + 82}'),
    'Basic solids': List.generate(4, (index) => 'Level ${index + 85}'),
  },
  'Advanced Arithmetic': {
    'Factors of large numbers': List.generate(5, (index) => 'Level ${index + 89}'),
    'Prime factorization': List.generate(5, (index) => 'Level ${index + 94}'),
  },
  'Percentages, Ratios, and Proportions': {
    'Basic percentages': List.generate(4, (index) => 'Level ${index + 99}'),
    'Basic ratios': List.generate(4, (index) => 'Level ${index + 103}'),
    'Proportions': List.generate(4, (index) => 'Level ${index + 107}'),
    'Mixed concepts': List.generate(4, (index) => 'Level ${index + 111}'),
  },
  'Pre-Algebra': {
    'Evaluating algebraic expressions': List.generate(4, (index) => 'Level ${index + 115}'),
    'Solving equations': List.generate(4, (index) => 'Level ${index + 119}'),
    'Word problems': List.generate(4, (index) => 'Level ${index + 123}'),
  },
  'Advanced Geometry': {
    'Congruency': List.generate(4, (index) => 'Level ${index + 127}'),
    'Similarity': List.generate(4, (index) => 'Level ${index + 131}'),
    '3D Geometry': List.generate(4, (index) => 'Level ${index + 135}'),
  },
  'Basic Statistics': {
    'Interpreting bar graphs': List.generate(3, (index) => 'Level ${index + 139}'),
    'Pie charts': List.generate(3, (index) => 'Level ${index + 142}'),
    'Histograms': List.generate(3, (index) => 'Level ${index + 145}'),
  },
  'Algebra': {
    'Quadratic equations': List.generate(5, (index) => 'Level ${index + 148}'),
    'Polynomials': List.generate(5, (index) => 'Level ${index + 153}'),
    'Algebraic fractions': List.generate(4, (index) => 'Level ${index + 158}'),
  },
  'Trigonometry': {
    'Sine, Cosine, Tangent': List.generate(6, (index) => 'Level ${index + 162}'),
    'Inverse Trigonometric Functions': List.generate(5, (index) => 'Level ${index + 168}'),
    'Applications': List.generate(4, (index) => 'Level ${index + 173}'),
  },
  'Advanced Statistics & Probability': {
    'Probability distributions': List.generate(5, (index) => 'Level ${index + 177}'),
    'Hypothesis testing': List.generate(5, (index) => 'Level ${index + 182}'),
    'Regression analysis': List.generate(4, (index) => 'Level ${index + 187}'),
  },
  'Pre-Calculus': {
    'Functions and their properties': List.generate(5, (index) => 'Level ${index + 191}'),
    'Composite functions': List.generate(4, (index) => 'Level ${index + 196}'),
    'Inverse functions': List.generate(4, (index) => 'Level ${index + 200}'),
  },
  'Calculus': {
    'Differentiation techniques': List.generate(6, (index) => 'Level ${index + 204}'),
    'Integration techniques': List.generate(6, (index) => 'Level ${index + 210}'),
    'Applications of derivatives': List.generate(5, (index) => 'Level ${index + 216}'),
    'Applications of integrals': List.generate(5, (index) => 'Level ${index + 221}'),
  },
  'Linear Algebra': {
    'Vector operations': List.generate(5, (index) => 'Level ${index + 226}'),
    'Matrix transformations': List.generate(5, (index) => 'Level ${index + 231}'),
    'Eigenvalues and eigenvectors': List.generate(5, (index) => 'Level ${index + 236}'),
  },
  'Advanced Topics': {
    'Number theory': List.generate(4, (index) => 'Level ${index + 241}'),
    'Complex numbers': List.generate(4, (index) => 'Level ${index + 245}'),
    'Differential equations': List.generate(4, (index) => 'Level ${index + 249}'),
  },*/
};

class LevelsJourneyScreen extends StatefulWidget {
  @override
  _LevelsJourneyScreenState createState() => _LevelsJourneyScreenState();
}

class _LevelsJourneyScreenState extends State<LevelsJourneyScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeHelper = ThemeHelper(context);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Sliver App Bar
          SliverAppBar(
            automaticallyImplyLeading: false,
            leading: null,
            pinned: false,
            floating: true,
            snap: true,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            flexibleSpace: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: themeHelper.iconColor, size: 30),
                      onPressed: () async {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen())
                        );
                      },
                    ),
                    Icon(FontAwesomeIcons.starAndCrescent, color: themeHelper.iconColor, size: 30)
                  ],
                ),
              ),
            ),
          ),
          // Sliver List for Categories
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                String categoryKey = categories.keys.elementAt(index);
                return CategoryTile(category: categoryKey, topics: categories[categoryKey]!);
              },
              childCount: categories.keys.length,
            ),
          ),
        ],
      ),
    );
  }
}


class CategoryTile extends StatefulWidget {
  final String category;
  final Map<String, List<Tuple2<String, Widget>>> topics;

  CategoryTile({required this.category, required this.topics});

  @override
  _CategoryTileState createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack)); // Using easeOutBack for a slight overshoot effect

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeHelper = ThemeHelper(context);
    double fontSize = 22;

    // Adjust font size based on the length of the category string
    if (widget.category.length > 15) {
      fontSize = 18;
    } else if (widget.category.length > 20) {
      fontSize = 16;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(thickness: 2),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      widget.category,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: themeHelper.textColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(thickness: 2),
                  ),
                ],
              ),
            ),
          ),
        ),
        ...widget.topics.keys.map((key) {
          return RepaintBoundary(child: TopicExpansionTile(topic: key, levels: widget.topics[key]!));
        }).toList()
      ],
    );
  }
}




class TopicExpansionTile extends StatefulWidget {
  final String topic;
  final List<Tuple2<String, Widget>> levels;

  TopicExpansionTile({required this.topic, required this.levels});

  @override
  _TopicExpansionTileState createState() => _TopicExpansionTileState();

}



class _TopicExpansionTileState extends State<TopicExpansionTile> with SingleTickerProviderStateMixin {
  bool allLevelsCompleted = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
    _rotationAnimation = Tween<double>(begin: 0.0, end: -0.05).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeHelper = ThemeHelper(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 8.0),
      child: Card(
        elevation: 8,
        color: themeHelper.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: themeHelper.primaryColor, width: 2),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                themeHelper.secondaryColor.withOpacity(0.7),
                themeHelper.primaryColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ExpansionTile(
            onExpansionChanged: (expanded) {
              if (expanded) {
                Future.delayed(Duration(milliseconds: 100), () {
                  _controller.forward();
                });              } else {
                _controller.reverse();
              }
            },
            backgroundColor: Colors.transparent,
            tilePadding: EdgeInsets.symmetric(horizontal: 15),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    widget.topic,
                    style: GoogleFonts.bangers(
                      fontSize: 20,
                      color: themeHelper.btnTextColor,
                      fontWeight: FontWeight.w100,
                    ),
                    overflow: TextOverflow.clip,  // Will use '...' for text that can't fit.
                  ),
                ),
                if (allLevelsCompleted)
                  Icon(
                    Icons.check_circle_outline, // Or any other icon you want.
                    color: themeHelper.positiveColor,
                  ),
              ],
            ),
            leading: RotationTransition(
              turns: _rotationAnimation,
              child: CircleAvatar(
                child: Icon(
                  FontAwesomeIcons.diceD6,
                  color: themeHelper.btnTextColor,
                ),
                backgroundColor: themeHelper.buttonIndicatorColor,
              ),
            ),
              children: widget.levels
                  .asMap()
                  .entries
                  .map((entry) {
                int idx = entry.key;
                Tuple2<String, Widget> levelDetail = entry.value;
                return LevelItem(
                  levelDetail: levelDetail,
                  index: idx, // Use the index of the level within this topic
                );
              })
                  .toList(),
          ),
        ),
      ),
    );
  }
}


class LevelItem extends StatefulWidget  {
  final Tuple2<String, Widget> levelDetail;
  final int index;

  LevelItem({required this.levelDetail, required this.index});

  @override
  _LevelItemState createState() => _LevelItemState();
}

class _LevelItemState extends State<LevelItem> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  void _navigateToLevel(BuildContext context, Widget levelScreen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => levelScreen));
  }

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _slideAnimation = Tween<Offset>(begin: Offset(1, 0), end: Offset.zero).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final themeHelper = ThemeHelper(context);
    final levelName = widget.levelDetail.item1;
    final levelScreen = widget.levelDetail.item2;


    return SlideTransition(
      position: _slideAnimation,
      child: InkWell(
        onTap: () {
          _navigateToLevel(context, levelScreen);
        },
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: themeHelper.secondaryColor,
            child: Text(
              (widget.index + 1).toString(),
              style: GoogleFonts.bangers(color: themeHelper.btnTextColor, fontSize: 18),
            ),
          ),
          title: Text(
            levelName,
            style: GoogleFonts.bangers(color: themeHelper.btnTextColor, fontSize: 20),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.lock_open, // Replace with a lock if the level is locked
              color: themeHelper.iconColor,
            ),
            onPressed: () {
              _navigateToLevel(context, levelScreen);
            },
          ),
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: LevelsJourneyScreen()));
