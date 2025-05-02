import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/custom_widgets/my_card.dart';
import 'package:tracket/features/players/models/player.dart';
import 'package:tracket/utils/constants/colors.dart';

class PlayerStatsCard extends StatefulWidget {
  final Player playerData;

  const PlayerStatsCard({
    Key? key,
    required this.playerData,
  }) : super(key: key);

  @override
  State<PlayerStatsCard> createState() => _PlayerStatsCardState();
}

class _PlayerStatsCardState extends State<PlayerStatsCard> {
  // Selected format index (default to ODI/50 overs)
  int _selectedFormatIndex = 2;

  // Available formats
  final List<String> _formats = ['T5', 'T10', 'T20', 'ODI', 'Test'];

  // Get stats based on the selected format
  Map<String, dynamic> _getStatsForFormat() {
    final cricketDetails = widget.playerData.playerCricketDetails!;
    final format = _formats[_selectedFormatIndex];

    switch (format) {
      case 'T5':
        return {
          'matches': cricketDetails.allFormatStats.over5.matches ?? 0,
          'runs': cricketDetails.allFormatStats.over5.battingStats.totalRuns,
          'wickets':
              cricketDetails.allFormatStats.over5.bowlingStats?.wicket ?? 0,
        };
      case 'T10':
        return {
          'matches': cricketDetails.allFormatStats.over10.matches ?? 0,
          'runs': cricketDetails.allFormatStats.over10.battingStats.totalRuns,
          'wickets':
              cricketDetails.allFormatStats.over10.bowlingStats?.wicket ?? 0,
        };
      case 'T20':
        return {
          'matches': cricketDetails.allFormatStats.over20.matches ?? 0,
          'runs': cricketDetails.allFormatStats.over20.battingStats.totalRuns,
          'wickets':
              cricketDetails.allFormatStats.over20.bowlingStats?.wicket ?? 0,
        };
      case 'ODI':
        return {
          'matches': cricketDetails.allFormatStats.over50.matches ?? 0,
          'runs': cricketDetails.allFormatStats.over50.battingStats.totalRuns,
          'wickets':
              cricketDetails.allFormatStats.over50.bowlingStats?.wicket ?? 0,
        };
      case 'Test':
        return {
          'matches': cricketDetails.allFormatStats.test.matches ?? 0,
          'runs': cricketDetails.allFormatStats.test.battingStats.totalRuns,
          'wickets':
              cricketDetails.allFormatStats.test.bowlingStats?.wicket ?? 0,
        };
      default:
        return {
          'matches': cricketDetails.allFormatStats.over50.matches ?? 0,
          'runs': cricketDetails.allFormatStats.over50.battingStats.totalRuns,
          'wickets':
              cricketDetails.allFormatStats.over50.bowlingStats?.wicket ?? 0,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stats = _getStatsForFormat();

    return MyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Player Statistics',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 22,
                  color: isDark ? primaryLight : primaryColor,
                ),
          ),
          const SizedBox(height: 16),

          // Format selector - Segmented Buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_formats.length, (index) {
                final isSelected = _selectedFormatIndex == index;
                return Padding(
                  padding: EdgeInsets.only(
                      right: index < _formats.length - 1 ? 8 : 0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedFormatIndex = index;
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? primaryColor : primaryLight)
                            : (isDark ? Colors.grey[800] : Colors.grey[200]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _formats[index],
                        style: TextStyle(
                          color: isSelected
                              ? (isDark ? Colors.black : Colors.white)
                              : (isDark ? Colors.white70 : Colors.black87),
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 20),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatsData(
                number: stats['matches'],
                label: 'Matches',
                numColor: isDark ? secondaryLight : secondaryColor,
                labelStyle: Theme.of(context).textTheme.bodyLarge,
              ),
              StatsData(
                number: stats['runs'],
                label: 'Runs',
                numColor: isDark ? primaryLight : primaryColor,
                labelStyle: Theme.of(context).textTheme.bodyLarge,
              ),
              StatsData(
                number: stats['wickets'],
                label: 'Wickets',
                numColor: isDark ? Colors.redAccent : Colors.red,
                labelStyle: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),

          // Format details label
          const SizedBox(height: 16),
          Center(
            child: Text(
              _getFormatFullName(),
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[700],
                fontStyle: FontStyle.italic,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get the full format name
  String _getFormatFullName() {
    switch (_formats[_selectedFormatIndex]) {
      case 'T5':
        return '5 Overs Format';
      case 'T10':
        return '10 Overs Format';
      case 'T20':
        return 'Twenty20 Format';
      case 'ODI':
        return 'One Day International (50 Overs)';
      case 'Test':
        return 'Test Cricket';
      default:
        return '50 Overs Format';
    }
  }
}

// Existing StatsData widget
class StatsData extends StatelessWidget {
  final int number;
  final String label;
  final Color numColor;
  final TextStyle? labelStyle;

  const StatsData({
    Key? key,
    required this.number,
    required this.label,
    required this.numColor,
    this.labelStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: numColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: labelStyle ?? Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
