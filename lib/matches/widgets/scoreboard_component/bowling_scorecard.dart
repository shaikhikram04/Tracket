import 'package:flutter/material.dart';
import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/matches/models/bowling_score.dart';
import 'package:tracket/matches/models/extras.dart';
import 'package:tracket/matches/models/fall_of_wickets.dart';
import 'package:tracket/matches/widgets/scoreboard_component/batting_scorecard.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

/// Example usage and demo widget
class BowlingScorecardDemo extends StatelessWidget {
  const BowlingScorecardDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data
    final sampleStats = [
      BowlingScore(
        playerName: "Jasprit Bumrah",
        balls: 24,
        maidenOvers: 1,
        runsGiven: 14,
        wickets: 3,
        uuid: '1',
      ),
      BowlingScore(
        playerName: "Mohammed Shami",
        balls: 24,
        maidenOvers: 0,
        runsGiven: 23,
        wickets: 2,
        uuid: '2',
      ),
      BowlingScore(
        playerName: "Ravindra Jadeja",
        balls: 24,
        maidenOvers: 0,
        runsGiven: 28,
        wickets: 1,
        uuid: '3',
      ),
      BowlingScore(
        playerName: "Yuzvendra Chahal",
        balls: 12,
        maidenOvers: 0,
        runsGiven: 35,
        wickets: 0,
        uuid: '4',
      ),
      BowlingScore(
        playerName: "Shardul Thakur",
        balls: 15,
        maidenOvers: 0,
        runsGiven: 33,
        wickets: 1,
        uuid: '5',
      ),
    ];

    final List<BattingScore> sampleBatsmen = [
      BattingScore(
        playerName: 'Rohit Sharma',
        dismissalInfo: 'c Root b Anderson',
        runs: 83,
        ballsFaced: 68,
        fours: 12,
        sixes: 2,
        uuid: '1',
      ),
      BattingScore(
        playerName: 'KL Rahul',
        dismissalInfo: 'b Archer',
        runs: 42,
        ballsFaced: 64,
        fours: 6,
        sixes: 0,
        uuid: '2',
      ),
      BattingScore(
        playerName: 'Virat Kohli',
        dismissalInfo: 'Not out',
        runs: 122,
        ballsFaced: 98,
        fours: 14,
        sixes: 4,
        uuid: '3',
      ),
      BattingScore(
        playerName: 'Rishabh Pant',
        dismissalInfo: 'Not out',
        runs: 28,
        ballsFaced: 18,
        fours: 3,
        sixes: 2,
        uuid: '4',
      ),
    ];

    final Extras sampleExtras = Extras(
      byes: 4,
      legByes: 6,
      wides: 8,
      noBalls: 2,
    );

    final List<FallOfWicket> sampleFallOfWickets = [
      FallOfWicket(
        wicketNumber: 1,
        runsAtFall: 105,
        batsmanName: 'Rohit Sharma',
        overs: 14.2,
      ),
      FallOfWicket(
        wicketNumber: 2,
        runsAtFall: 142,
        batsmanName: 'KL Rahul',
        overs: 22.5,
      ),
    ];

    // Check if we're in dark mode
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bowling Scorecard'),
        backgroundColor: isDarkMode ? primaryVariant : primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BattingScorecard(
                  teamName: 'India',
                  battingScores: sampleBatsmen,
                  extras: sampleExtras,
                  totalScore: 336,
                  wickets: 3,
                  overs: '50.0',
                  fallOfWickets: sampleFallOfWickets),
              BowlingScorecard(
                bowlerStats: sampleStats,
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BowlingScorecard extends StatelessWidget {
  final List<BowlingScore> bowlerStats;
  final bool isDarkMode;

  const BowlingScorecard({
    super.key,
    required this.bowlerStats,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isTabletOrLarger = MediaQuery.of(context).size.width >= 600;

    // Responsive font sizing
    final headerFontSize = isTabletOrLarger ? 16.0 : 14.0;
    final dataFontSize = isTabletOrLarger ? 14.0 : 12.0;

    // Text colors based on mode
    final headerTextColor =
        isDarkMode ? DarkThemeColors.primaryText : primaryColor;
    final dataTextColor = isDarkMode
        ? DarkThemeColors.secondaryText
        : LightThemeColors.secondaryText;

    // Row colors
    final evenRowColor = isDarkMode
        ? DarkThemeColors.surfaceColor
        : LightThemeColors.surfaceColor;
    final oddRowColor =
        isDarkMode ? DarkThemeColors.cardColor : LightThemeColors.cardColor;

    return Card(
      elevation: 2,
      color:
          isDarkMode ? DarkThemeColors.cardColor : LightThemeColors.cardColor,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Bowling Statistics',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? DarkThemeColors.primaryText : primaryColor,
              ),
            ),
          ),

          // Scorecard header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? primaryVariant.withOpacity(0.8)
                  : primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: _buildHeaderRow(
                headerFontSize, headerTextColor, isTabletOrLarger),
          ),

          // Scorecard data rows
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(
                  bowlerStats.length,
                  (index) => _buildDataRow(
                    bowlerStats[index],
                    index % 2 == 0 ? evenRowColor : oddRowColor,
                    dataFontSize,
                    dataTextColor,
                    isTabletOrLarger,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow(
      double fontSize, Color textColor, bool isTabletOrLarger) {
    return Row(
      children: [
        _buildHeaderCell('Bowler',
            flex: 5, fontSize: fontSize, textColor: textColor),
        _buildHeaderCell('O',
            flex: 2, fontSize: fontSize, textColor: textColor),
        _buildHeaderCell('M',
            flex: 2, fontSize: fontSize, textColor: textColor),
        _buildHeaderCell('R',
            flex: 2, fontSize: fontSize, textColor: textColor),
        _buildHeaderCell('W',
            flex: 2, fontSize: fontSize, textColor: textColor),
        _buildHeaderCell('Econ',
            flex: 3, fontSize: fontSize, textColor: textColor),
      ],
    );
  }

  Widget _buildHeaderCell(String text,
      {required int flex, required double fontSize, required Color textColor}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            color: textColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDataRow(BowlingScore stats, Color backgroundColor,
      double fontSize, Color textColor, bool isTabletOrLarger) {
    // Define economy color based on performance
    Color economyColor;
    if (stats.economy < 6.0) {
      economyColor = StatusColors.success;
    } else if (stats.economy < 8.0) {
      economyColor = StatusColors.info;
    } else if (stats.economy < 10.0) {
      economyColor = StatusColors.warning;
    } else {
      economyColor = StatusColors.error;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Handle row tap - could show detailed player stats
        },
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border(
              bottom: BorderSide(
                color: isDarkMode
                    ? DarkThemeColors.secondaryBackground
                    : LightThemeColors.dividerColor,
                width: 0.5,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    stats.playerName,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              _buildDataCell(stats.overs.toString(),
                  flex: 2, fontSize: fontSize, textColor: textColor),
              _buildDataCell(stats.maidenOvers.toString(),
                  flex: 2, fontSize: fontSize, textColor: textColor),
              _buildDataCell(stats.runsGiven.toString(),
                  flex: 2, fontSize: fontSize, textColor: textColor),
              _buildDataCell(
                stats.wickets.toString(),
                flex: 2,
                fontSize: fontSize,
                textColor: stats.wickets > 2 ? StatusColors.success : textColor,
                fontWeight:
                    stats.wickets > 2 ? FontWeight.bold : FontWeight.normal,
              ),
              _buildDataCell(
                stats.economy.toStringAsFixed(1),
                flex: 3,
                fontSize: fontSize,
                textColor: economyColor,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataCell(
    String text, {
    required int flex,
    required double fontSize,
    required Color textColor,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: textColor,
            fontWeight: fontWeight,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _ScrollableStatsSection extends StatelessWidget {
  const _ScrollableStatsSection(this.bowlingScores);

  final List<BowlingScore> bowlingScores;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicWidth(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BowlingColumn(bowlingScores: bowlingScores),
            ..._buildStatColumns(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStatColumns(BuildContext context) {
    final statConfigs = [
      _StatConfig('O', (b) => b.overs, 40,
          formatValue: (num? value) => value?.toStringAsFixed(1)),
      _StatConfig('M', (b) => b.maidenOvers, 40),
      _StatConfig('R', (b) => b.runsGiven, 40),
      _StatConfig('W', (b) => b.wickets, 40),
      _StatConfig('Econ', (b) => b.economy, 60,
          formatValue: (num? value) => value?.toStringAsFixed(2)),
    ];

    return statConfigs
        .map((config) => _StatColumn(
              title: config.title,
              values: bowlingScores
                  .map((b) =>
                      config.formatValue?.call(config.valueGetter(b)) ??
                      config.valueGetter(b)?.toString() ??
                      '-')
                  .toList(),
              width: config.width,
            ))
        .toList();
  }
}

class _StatConfig<T> {
  final String title;
  final T? Function(BowlingScore) valueGetter;
  final double width;
  final String? Function(T?)? formatValue;

  const _StatConfig(
    this.title,
    this.valueGetter,
    this.width, {
    this.formatValue,
  });
}

class _BowlingColumn extends StatelessWidget {
  final List<BowlingScore> bowlingScores;

  const _BowlingColumn({required this.bowlingScores});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Bowling'),
          const _Divider(),
          ...bowlingScores.expand((bowler) => [
                Text(
                  bowler.playerName,
                  style: MyTextStyle(context).bodyLarge,
                ),
                const _Divider(),
              ]),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String title;
  final List<String> values;
  final double width;

  const _StatColumn({
    required this.title,
    required this.values,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          Text(title),
          const _Divider(),
          ...values.expand((value) => [
                Text(
                  value,
                  style: MyTextStyle(context).bodyLarge,
                ),
                const _Divider(),
              ]),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 3),
      width: double.infinity,
      color: Colors.black38,
    );
  }
}

// Add this class to your models
class BowlerData {
  final String name;
  final double overs;
  final int maidens;
  final int runs;
  final int wickets;
  final double economy;

  const BowlerData({
    required this.name,
    required this.overs,
    required this.maidens,
    required this.runs,
    required this.wickets,
    required this.economy,
  });
}
