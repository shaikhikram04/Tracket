import 'package:flutter/material.dart';
import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/matches/models/extras.dart';
import 'package:tracket/matches/models/fall_of_wickets.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

/// Example usage of the BattingScorecard widget
class BattingScorecardExample extends StatelessWidget {
  const BattingScorecardExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Batting Scorecard'),
        backgroundColor: CricketColors.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BattingScorecard(
            teamName: 'India',
            extras: sampleExtras,
            totalScore: 295,
            wickets: 2,
            overs: '42.3',
            fallOfWickets: sampleFallOfWickets,
            battingScores: sampleBatsmen,
          ),
        ),
      ),
    );
  }
}

class CricketColors {
  static const Color primaryColor = Color(0xFF1B5E20); // Dark green
  static const Color primaryVariant = Color(0xFF2E7D32); // Medium green
  static const Color secondaryColor = Color(0xFF43A047); // Light green
  static const Color pitchBrown = Color(0xFF8D6E63); // Brown
  static const Color lightPitchBrown = Color(0xFFBCAAA4); // Light brown
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color white = Colors.white;
  static const Color highlightYellow = Color(0xFFFFF59D);
}

class BattingScorecard extends StatelessWidget {
  final String teamName;
  final List<BattingScore> battingScores;
  final Extras extras;
  final int totalScore;
  final int wickets;
  final String overs;
  final List<FallOfWicket> fallOfWickets;

  const BattingScorecard({
    super.key,
    required this.teamName,
    required this.battingScores,
    required this.extras,
    required this.totalScore,
    required this.wickets,
    required this.overs,
    required this.fallOfWickets,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: CricketColors.primaryColor, width: 1.5),
      ),
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTeamHeaderRow(),
          const Divider(height: 1, thickness: 1, color: CricketColors.divider),
          _buildColumnHeaders(),
          const Divider(height: 1, thickness: 1, color: CricketColors.divider),
          _buildBatsmenList(),
          const Divider(height: 1, thickness: 1, color: CricketColors.divider),
          _buildExtrasRow(),
          const Divider(height: 1, thickness: 1, color: CricketColors.divider),
          _buildTotalRow(),
          if (fallOfWickets.isNotEmpty) ...[
            const Divider(
                height: 1, thickness: 1, color: CricketColors.divider),
            _buildFallOfWicketsRow(),
          ],
        ],
      ),
    );
  }

  /// Builds the team name and score header row
  Widget _buildTeamHeaderRow() {
    String oversText = ' (${overs} ov)';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: CricketColors.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            teamName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: CricketColors.white,
            ),
          ),
          Text(
            '$totalScore/$wickets$oversText',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: CricketColors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the column headers for the batting statistics
  Widget _buildColumnHeaders() {
    return Container(
      color: CricketColors.lightPitchBrown.withOpacity(0.3),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicWidth(
          child: Row(
            children: [
              _buildHeaderCell('BATSMAN',
                  flex: 3, alignment: Alignment.centerLeft),
              _buildHeaderCell('R'),
              _buildHeaderCell('B'),
              _buildHeaderCell('4s'),
              _buildHeaderCell('6s'),
              _buildHeaderCell('SR'),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a header cell for the column headers
  Widget _buildHeaderCell(String text,
      {int flex = 1, Alignment alignment = Alignment.center}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        alignment: alignment,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: CricketColors.textSecondary,
          ),
        ),
      ),
    );
  }

  /// Builds the list of batsmen innings using ListView.builder for performance
  Widget _buildBatsmenList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: battingScores.length,
      itemBuilder: (context, index) {
        final batsman = battingScores[index];
        final isNotOut = !batsman.isOut;
        final backgroundColor = index % 2 == 0
            ? CricketColors.white
            : CricketColors.lightPitchBrown.withOpacity(0.1);

        return Container(
          color: backgroundColor,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: IntrinsicWidth(
              child: Row(
                children: [
                  _buildBatsmanNameCell(
                      batsman.playerName, batsman.dismissalInfo, isNotOut),
                  _buildStatsCell('${batsman.runs}',
                      isHighlighted: batsman.runs! >= 50),
                  _buildStatsCell('${batsman.ballsFaced}'),
                  _buildStatsCell('${batsman.fours}'),
                  _buildStatsCell('${batsman.sixes}'),
                  _buildStatsCell(batsman.strikeRate!.toStringAsFixed(1)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds a batsman name and dismissal cell
  Widget _buildBatsmanNameCell(
      String name, String dismissalInfo, bool isNotOut) {
    return Expanded(
      flex: 3,
      child: Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: CricketColors.textPrimary,
                fontStyle: isNotOut ? FontStyle.italic : FontStyle.normal,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              dismissalInfo,
              style: TextStyle(
                fontSize: 12,
                color: isNotOut
                    ? CricketColors.secondaryColor
                    : CricketColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a stats cell for runs, balls, fours, sixes, or strike rate
  Widget _buildStatsCell(String text, {bool isHighlighted = false}) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: isHighlighted
            ? BoxDecoration(
                color: CricketColors.highlightYellow.withOpacity(0.3),
              )
            : null,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            color: CricketColors.textPrimary,
          ),
        ),
      ),
    );
  }

  /// Builds the extras row showing byes, leg byes, wides, no balls, and penalties
  Widget _buildExtrasRow() {
    return Container(
      color: CricketColors.lightPitchBrown.withOpacity(0.15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Expanded(
            flex: 2,
            child: Text(
              'Extras',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: CricketColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Text(
              '${extras.total} (b ${extras.byes}, lb ${extras.legByes}, w ${extras.wides}, '
              'nb ${extras.noBalls}, p ${extras.penaltyRuns})',
              style: const TextStyle(
                fontSize: 13,
                color: CricketColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the total score row
  Widget _buildTotalRow() {
    String oversText = ' in ${overs} overs';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: CricketColors.primaryVariant.withOpacity(0.15),
      child: Row(
        children: [
          const Expanded(
            flex: 2,
            child: Text(
              'Total',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: CricketColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Text(
              '$totalScore for $wickets$oversText',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: CricketColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the fall of wickets row
  Widget _buildFallOfWicketsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fall of Wickets',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: CricketColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _formatFallOfWickets(),
            style: const TextStyle(
              fontSize: 13,
              color: CricketColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  /// Formats the fall of wickets data into a readable string
  String _formatFallOfWickets() {
    return fallOfWickets.map((wicket) {
      String oversText = wicket.overs != null
          ? ' (${wicket.overs!.toStringAsFixed(1)} ov)'
          : '';
      return '${wicket.wicketNumber}-${wicket.runsAtFall} ${wicket.batsmanName}$oversText';
    }).join(' • ');
  }
}

class _ScrollableStatsSection extends StatelessWidget {
  const _ScrollableStatsSection(this.innings);

  final Inning innings;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicWidth(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BattingColumn(innings: innings),
            ..._buildStatColumns(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStatColumns(BuildContext context) {
    final statConfigs = [
      _StatConfig('R', (b) => b.runs, 40),
      _StatConfig('B', (b) => b.ballsFaced, 40),
      _StatConfig("4's", (b) => b.fours, 40),
      _StatConfig("6's", (b) => b.sixes, 40),
      _StatConfig('S/R', (b) => b.strikeRate, 60,
          formatValue: (num? value) => value?.toStringAsFixed(2)),
    ];

    return statConfigs
        .map((config) => _StatColumn(
              title: config.title,
              values: innings.battingStats
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

class _ExtrasAndTotalSection extends StatelessWidget {
  const _ExtrasAndTotalSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(
          label: 'Extras',
          value: '6  (W 1, LB 5)',
        ),
        const _Divider(),
        _InfoRow(
          label: 'Total runs',
          value: '121  (5 wkts, 10 ovs)',
        ),
        const _Divider(),
      ],
    );
  }
}

class _FallOfWickets extends StatelessWidget {
  const _FallOfWickets();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            'Fall of wickets',
            style: MyTextStyle(context).bodyLarge,
          ),
        ),
        _buildWicketsList(context),
        const SizedBox(height: 6),
        const _Divider(),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildWicketsList(BuildContext context) {
    final wickets = [
      _WicketInfo(score: '12/1', player: 'Batsman1', overs: '1.2'),
      _WicketInfo(score: '12/1', player: 'Batsman1', overs: '1.2'),
      _WicketInfo(score: '12/1', player: 'Batsman1', overs: '1.2'),
      _WicketInfo(score: '12/1', player: 'Batsman1', overs: '1.2'),
    ];

    return Text.rich(
      TextSpan(
        children: wickets
            .expand((wicket) => [
                  TextSpan(text: wicket.score),
                  TextSpan(
                    text: '  (${wicket.player}, ${wicket.overs} ovs)',
                    style: MyTextStyle(context)
                        .bodyMedium
                        .copyWith(color: Colors.grey.shade600),
                  ),
                  if (wicket != wickets.last) const TextSpan(text: '  •  '),
                ])
            .toList(),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 215,
          height: 35,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: MyTextStyle(context).bodyLarge,
            ),
          ),
        ),
        Text(
          value,
          style: MyTextStyle(context)
              .bodyLarge
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _StatConfig<T> {
  final String title;
  final T? Function(BattingScore) valueGetter;
  final double width;
  final String? Function(T?)? formatValue;

  const _StatConfig(
    this.title,
    this.valueGetter,
    this.width, {
    this.formatValue,
  });
}

class _WicketInfo {
  final String score;
  final String player;
  final String overs;

  const _WicketInfo({
    required this.score,
    required this.player,
    required this.overs,
  });
}

class _BattingColumn extends StatelessWidget {
  final Inning innings;

  const _BattingColumn({required this.innings});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Batting'),
          const _Divider(),
          ...innings.battingStats.expand((batsman) => [
                Text(
                  batsman.playerName,
                  style: MyTextStyle(context).bodyLarge,
                ),
                Text(
                  'batsman.dismissalInfo',
                  style: MyTextStyle(context)
                      .bodyMedium
                      .copyWith(color: Colors.grey.shade600),
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
                const Text(''),
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
